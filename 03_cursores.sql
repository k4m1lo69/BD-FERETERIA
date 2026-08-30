-- ============================================================
-- EV1 BDY1103 - Ferreteria ViSol (v2)
-- Punto 4: Cursores explicitos (simples, con parametros, loops anidados)
-- ============================================================

SET SERVEROUTPUT ON;

-- ---------- 4.1 Cursor explicito simple ----------
DECLARE
    CURSOR c_clientes IS
        SELECT id, nombre, email FROM clientes;
    v_cliente c_clientes%ROWTYPE;
BEGIN
    OPEN c_clientes;
    LOOP
        FETCH c_clientes INTO v_cliente;
        EXIT WHEN c_clientes%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Cliente #' || v_cliente.id || ': ' || v_cliente.nombre);
    END LOOP;
    CLOSE c_clientes;
END;
/

-- ---------- 4.2 Cursor explicito con parametro ----------
-- Recorre las lineas de detalle de UN pedido puntual
DECLARE
    CURSOR c_detalle_pedido(p_pedido_id NUMBER) IS
        SELECT dp.producto_id, pr.nombre AS producto_nombre, dp.cantidad, dp.precio_unitario
        FROM detalle_pedidos dp
        JOIN productos pr ON pr.id = dp.producto_id
        WHERE dp.pedido_id = p_pedido_id;
    v_linea c_detalle_pedido%ROWTYPE;
BEGIN
    OPEN c_detalle_pedido(4); -- pedido multiproducto
    LOOP
        FETCH c_detalle_pedido INTO v_linea;
        EXIT WHEN c_detalle_pedido%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_linea.producto_nombre || ' x' || v_linea.cantidad ||
                              ' @ ' || v_linea.precio_unitario);
    END LOOP;
    CLOSE c_detalle_pedido;
END;
/

-- ---------- 4.3 Cursores complejos con loops anidados ----------
-- Cliente -> sus pedidos -> el detalle de cada pedido -> sus pagos
DECLARE
    CURSOR c_clientes IS
        SELECT id, nombre FROM clientes;

    CURSOR c_pedidos_cliente(p_cliente_id NUMBER) IS
        SELECT id, estado, fecha
        FROM pedidos
        WHERE cliente_id = p_cliente_id;

    CURSOR c_detalle_pedido(p_pedido_id NUMBER) IS
        SELECT pr.nombre AS producto_nombre, dp.cantidad, dp.precio_unitario
        FROM detalle_pedidos dp
        JOIN productos pr ON pr.id = dp.producto_id
        WHERE dp.pedido_id = p_pedido_id;

    CURSOR c_pagos_pedido(p_pedido_id NUMBER) IS
        SELECT monto, metodo_pago, estado
        FROM pagos
        WHERE pedido_id = p_pedido_id;

    v_pago_encontrado BOOLEAN;
BEGIN
    FOR v_cliente IN c_clientes LOOP
        DBMS_OUTPUT.PUT_LINE('=== Cliente: ' || v_cliente.nombre || ' ===');

        FOR v_pedido IN c_pedidos_cliente(v_cliente.id) LOOP
            DBMS_OUTPUT.PUT_LINE('  Pedido #' || v_pedido.id || ' - Estado: ' || v_pedido.estado);

            FOR v_linea IN c_detalle_pedido(v_pedido.id) LOOP
                DBMS_OUTPUT.PUT_LINE('     - ' || v_linea.producto_nombre || ' x' ||
                                      v_linea.cantidad || ' @ ' || v_linea.precio_unitario);
            END LOOP;

            v_pago_encontrado := FALSE;
            FOR v_pago IN c_pagos_pedido(v_pedido.id) LOOP
                DBMS_OUTPUT.PUT_LINE('     Pago: ' || v_pago.monto || ' via ' || v_pago.metodo_pago ||
                                      ' (' || v_pago.estado || ')');
                v_pago_encontrado := TRUE;
            END LOOP;

            IF NOT v_pago_encontrado THEN
                DBMS_OUTPUT.PUT_LINE('     Sin pago registrado aun');
            END IF;
        END LOOP;
    END LOOP;
END;
/
