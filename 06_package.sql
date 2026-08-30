-- ============================================================
-- EV1 BDY1103 - Ferreteria ViSol (v2)
-- Punto 7: Package
-- ============================================================

SET SERVEROUTPUT ON;

-- ---------- 7.1 Especificacion ----------
CREATE OR REPLACE PACKAGE pkg_gestion_pedidos IS

    FUNCTION fn_calcular_total_pedido(
        p_pedido_id IN pedidos.id%TYPE
    ) RETURN NUMBER;

    PROCEDURE sp_registrar_pedido(
        p_cliente_id IN pedidos.cliente_id%TYPE,
        p_productos  IN t_id_array,
        p_cantidades IN t_qty_array
    );

    PROCEDURE sp_reporte_stock_critico;

END pkg_gestion_pedidos;
/

-- ---------- 7.2 Cuerpo ----------
CREATE OR REPLACE PACKAGE BODY pkg_gestion_pedidos IS

    FUNCTION fn_calcular_total_pedido(
        p_pedido_id IN pedidos.id%TYPE
    ) RETURN NUMBER
    IS
        v_total  NUMBER;
        v_existe NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_existe FROM pedidos WHERE id = p_pedido_id;
        IF v_existe = 0 THEN
            RAISE_APPLICATION_ERROR(-20002, 'No existe un pedido con id ' || p_pedido_id);
        END IF;

        SELECT NVL(SUM(cantidad * precio_unitario), 0)
        INTO v_total
        FROM detalle_pedidos
        WHERE pedido_id = p_pedido_id;

        RETURN v_total;
    END fn_calcular_total_pedido;


    PROCEDURE sp_registrar_pedido(
        p_cliente_id IN pedidos.cliente_id%TYPE,
        p_productos  IN t_id_array,
        p_cantidades IN t_qty_array
    )
    IS
        e_stock_insuficiente EXCEPTION;
        e_arreglos_no_calzan EXCEPTION;
        v_pedido_id pedidos.id%TYPE;
        v_precio    productos.precio%TYPE;
        v_stock     inventarios.cantidad%TYPE;
    BEGIN
        IF p_productos.COUNT != p_cantidades.COUNT THEN
            RAISE e_arreglos_no_calzan;
        END IF;

        INSERT INTO pedidos (cliente_id, estado, fecha)
        VALUES (p_cliente_id, 'PENDIENTE', SYSTIMESTAMP)
        RETURNING id INTO v_pedido_id;

        FOR i IN 1..p_productos.COUNT LOOP
            SELECT precio INTO v_precio FROM productos WHERE id = p_productos(i);
            SELECT cantidad INTO v_stock FROM inventarios WHERE producto_id = p_productos(i);

            IF v_stock < p_cantidades(i) THEN
                RAISE e_stock_insuficiente;
            END IF;

            INSERT INTO detalle_pedidos (pedido_id, producto_id, cantidad, precio_unitario)
            VALUES (v_pedido_id, p_productos(i), p_cantidades(i), v_precio);

            UPDATE inventarios
            SET cantidad = cantidad - p_cantidades(i)
            WHERE producto_id = p_productos(i);
        END LOOP;

        COMMIT;

        DBMS_OUTPUT.PUT_LINE('Pedido #' || v_pedido_id || ' registrado con ' || p_productos.COUNT ||
                              ' linea(s). Total: ' || fn_calcular_total_pedido(v_pedido_id));
    EXCEPTION
        WHEN e_arreglos_no_calzan THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('ERROR: la cantidad de productos y de cantidades no coincide.');
        WHEN e_stock_insuficiente THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('ERROR: stock insuficiente; se revirtio el pedido completo.');
        WHEN NO_DATA_FOUND THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('ERROR: producto o inventario no encontrado.');
    END sp_registrar_pedido;


    PROCEDURE sp_reporte_stock_critico
    IS
        CURSOR c_stock_critico IS
            SELECT p.nombre, i.cantidad, i.cantidad_minima
            FROM inventarios i
            JOIN productos p ON p.id = i.producto_id
            WHERE i.cantidad < i.cantidad_minima;

        v_encontrado BOOLEAN := FALSE;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('=== Reporte de Stock Critico ===');
        FOR r IN c_stock_critico LOOP
            DBMS_OUTPUT.PUT_LINE('Producto: ' || r.nombre || ' - Stock: ' || r.cantidad ||
                                  ' (minimo: ' || r.cantidad_minima || ')');
            v_encontrado := TRUE;
        END LOOP;

        IF NOT v_encontrado THEN
            DBMS_OUTPUT.PUT_LINE('No hay productos bajo el stock minimo.');
        END IF;
    END sp_reporte_stock_critico;

END pkg_gestion_pedidos;
/

-- ---------- 7.3 Pruebas ----------
BEGIN
    pkg_gestion_pedidos.sp_registrar_pedido(
        p_cliente_id => 1,
        p_productos  => t_id_array(2),
        p_cantidades => t_qty_array(4)
    );
END;
/

BEGIN
    pkg_gestion_pedidos.sp_reporte_stock_critico;
END;
/

BEGIN
    DBMS_OUTPUT.PUT_LINE('Total del pedido #4 (via package): ' || pkg_gestion_pedidos.fn_calcular_total_pedido(4));
END;
/
