SET SERVEROUTPUT ON;

DECLARE
    -- 1. Definición del VARRAY (máximo 3 medios de pago por venta)
    TYPE Multipagos_venta_varray IS VARRAY(3) OF NUMBER;
    v_metodos Multipagos_venta_varray;
    
    -- Variables auxiliares
    v_nombre_metodo METODOS_PAGO.NOMBRE%TYPE;

BEGIN
    -- 2. Recorremos TODAS las ventas de la base de datos
    FOR r_venta IN (SELECT ID_COMPRA_CLIENTE FROM VENTA_CLIENTE ORDER BY ID_COMPRA_CLIENTE) LOOP
        
        -- 3. Asignación directa del VARRAY según el ID de la venta 
        IF r_venta.ID_COMPRA_CLIENTE = 1 THEN
            v_metodos := Multipagos_venta_varray(1);       -- Venta 1: Efectivo
        ELSIF r_venta.ID_COMPRA_CLIENTE = 2 THEN
            v_metodos := Multipagos_venta_varray(3, 4);    -- Venta 2: Crédito y Transferencia
        ELSIF r_venta.ID_COMPRA_CLIENTE = 3 THEN
            v_metodos := Multipagos_venta_varray(2);       -- Venta 3: Débito
        ELSE
            v_metodos := Multipagos_venta_varray();        -- varray
        END IF;

        -- 4. Si el la variable (v_metodos) del  VARRAY tiene datos, los procesamos e imprimimos
        IF v_metodos.COUNT > 0 THEN
            
            DBMS_OUTPUT.PUT_LINE(' ');
            DBMS_OUTPUT.PUT_LINE('-> VENTA N° ' || r_venta.ID_COMPRA_CLIENTE || ' (' || v_metodos.COUNT || ' pago(s) procesado(s)):');

            -- Recorremos la variable(v_metodos) del VARRAY (Multipagos_venta_varray) 
            FOR i IN 1..v_metodos.COUNT LOOP
                
                SELECT NOMBRE 
                INTO v_nombre_metodo
                FROM METODOS_PAGO
                WHERE ID_METODO_PAGO = v_metodos(i);

                DBMS_OUTPUT.PUT_LINE('   * Medio #' || i || ': ' || v_nombre_metodo || ' (ID: ' || v_metodos(i) || ')');
                
            END LOOP;
            
        END IF;

    END LOOP;

    DBMS_OUTPUT.PUT_LINE(' ');
    DBMS_OUTPUT.PUT_LINE('==================================================');

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: Método de pago no encontrado.');
END;
/
