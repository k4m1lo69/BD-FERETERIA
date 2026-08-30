-- ============================================================
-- EV1 BDY1103 - Ferreteria ViSol 
-- Punto 3: RECORD y VARRAY (adaptado a cabecera/detalle)
-- ============================================================

SET SERVEROUTPUT ON;

DECLARE
    -- RECORD: datos clave de la cabecera de un pedido
    TYPE PedidoRec IS RECORD (
        ped_id      pedidos.id%TYPE,
        ped_cliente pedidos.cliente_id%TYPE,
        ped_estado  pedidos.estado%TYPE
    );
    v_pedido PedidoRec;

    -- VARRAY: cantidades de cada linea del pedido multiproducto (pedido #4)
    TYPE CantidadArray IS VARRAY(20) OF NUMBER;
    v_cantidades CantidadArray := CantidadArray(10, 2);

    v_total_items NUMBER := 0;
BEGIN
    SELECT id, cliente_id, estado
    INTO v_pedido
    FROM pedidos
    WHERE id = 4;

    DBMS_OUTPUT.PUT_LINE('Pedido #' || v_pedido.ped_id || ' - Cliente ' || v_pedido.ped_cliente ||
                          ' - Estado: ' || v_pedido.ped_estado);
    DBMS_OUTPUT.PUT_LINE('-----------------------------------------');

    FOR i IN 1..v_cantidades.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE('Linea ' || i || ': ' || v_cantidades(i) || ' unidades');
        v_total_items := v_total_items + v_cantidades(i);
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('-----------------------------------------');
    DBMS_OUTPUT.PUT_LINE('Total de items en el pedido: ' || v_total_items);
END;
/
