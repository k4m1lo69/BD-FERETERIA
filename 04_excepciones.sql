-- ============================================================
-- EV1 BDY1103 - Ferreteria ViSol (v2)
-- Punto 5: Excepciones predefinidas y definidas por el usuario
-- ============================================================

SET SERVEROUTPUT ON;

-- ---------- 5.1 Excepcion predefinida: NO_DATA_FOUND ----------
DECLARE
    v_nombre clientes.nombre%TYPE;
BEGIN
    SELECT nombre INTO v_nombre FROM clientes WHERE id = 999;
    DBMS_OUTPUT.PUT_LINE('Cliente encontrado: ' || v_nombre);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: no existe un cliente con ese id.');
END;
/

-- ---------- 5.2 Excepcion predefinida: TOO_MANY_ROWS ----------
-- El pedido #4 tiene 2 lineas de detalle: un SELECT INTO esperando 1 fila falla
DECLARE
    v_producto_id detalle_pedidos.producto_id%TYPE;
BEGIN
    SELECT producto_id INTO v_producto_id FROM detalle_pedidos WHERE pedido_id = 4;
    DBMS_OUTPUT.PUT_LINE('Producto id: ' || v_producto_id);
EXCEPTION
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Error: el pedido tiene mas de una linea de detalle; se esperaba solo una.');
END;
/

-- ---------- 5.3 Excepcion DEFINIDA POR EL USUARIO: stock critico ----------
DECLARE
    e_stock_critico EXCEPTION;
    v_cantidad inventarios.cantidad%TYPE;
    v_minima   inventarios.cantidad_minima%TYPE;
    v_prod_id  inventarios.producto_id%TYPE := 3; -- Amoladora
BEGIN
    SELECT cantidad, cantidad_minima
    INTO v_cantidad, v_minima
    FROM inventarios
    WHERE producto_id = v_prod_id;

    IF v_cantidad < v_minima THEN
        RAISE e_stock_critico;
    END IF;

    DBMS_OUTPUT.PUT_LINE('Stock del producto ' || v_prod_id || ' esta OK (' || v_cantidad || ' unidades).');
EXCEPTION
    WHEN e_stock_critico THEN
        DBMS_OUTPUT.PUT_LINE('ALERTA: stock critico para el producto ' || v_prod_id ||
                              ' (' || v_cantidad || ' unidades, minimo requerido: ' || v_minima || ')');
END;
/

-- ---------- 5.4 Excepcion definida por el usuario con RAISE_APPLICATION_ERROR ----------
DECLARE
    v_cantidad_pedido NUMBER := -5;
BEGIN
    IF v_cantidad_pedido <= 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'La cantidad del pedido debe ser mayor que cero.');
    END IF;

    DBMS_OUTPUT.PUT_LINE('Pedido valido, cantidad: ' || v_cantidad_pedido);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al validar el pedido: ' || SQLERRM);
END;
/
