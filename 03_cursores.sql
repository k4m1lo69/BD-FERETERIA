SET SERVEROUTPUT ON;

Cursor simple stock bajo · SQL
 
DECLARE
   -- Cursor simple: no recibe parámetros, siempre trae los mismos productos
   -- (los que están en o bajo su cantidad mínima de reposición)
   CURSOR c_stock_bajo IS
      SELECT p.codigo, p.nombre, i.cantidad, i.cantidad_minima
      FROM productos p
      JOIN inventario i ON i.id_producto = p.id_producto
      WHERE i.cantidad <= i.cantidad_minima;
 
BEGIN
   DBMS_OUTPUT.PUT_LINE('REPORTE DE PRODUCTOS CON STOCK BAJO');
   DBMS_OUTPUT.PUT_LINE('=====================================');
 
   FOR r_prod IN c_stock_bajo LOOP
      DBMS_OUTPUT.PUT_LINE(r_prod.codigo || ' - ' || r_prod.nombre
         || ' | Stock actual: ' || r_prod.cantidad
         || ' | Mínimo: ' || r_prod.cantidad_minima);
   END LOOP;
 
END;
/



    

DECLARE
   -- Cursor externo: recibe el id del cliente como parámetro
   CURSOR c_ventas_cliente (p_id_cliente NUMBER) IS
      SELECT id_compra_cliente, fecha_venta
      FROM venta_cliente
      WHERE id_cliente = p_id_cliente;

   -- Cursor interno: recibe el id de la venta que entrega el cursor externo
   CURSOR c_detalle_venta (p_id_venta NUMBER) IS
      SELECT dv.cantidad, dv.precio_unitario, dv.descuento, p.nombre
      FROM detalle_ventas dv
      JOIN productos p ON p.id_producto = dv.id_producto
      WHERE dv.id_compra_cliente = p_id_venta;

   v_total_venta   NUMBER;
   v_total_cliente NUMBER := 0;
   v_id_cliente    NUMBER := 1;  -- Ejemplo: cliente 1

BEGIN
   DBMS_OUTPUT.PUT_LINE('HISTORIAL DE COMPRAS - CLIENTE ' || v_id_cliente);
   DBMS_OUTPUT.PUT_LINE('=====================================');

   -- Loop externo: recorre cada venta del cliente
   FOR r_venta IN c_ventas_cliente(v_id_cliente) LOOP
      v_total_venta := 0;
      DBMS_OUTPUT.PUT_LINE('Venta N° ' || r_venta.id_compra_cliente || ' (' || r_venta.fecha_venta || ')');

      -- Loop interno: recorre el detalle de esa venta
      FOR r_det IN c_detalle_venta(r_venta.id_compra_cliente) LOOP
         v_total_venta := v_total_venta
            + (r_det.cantidad * r_det.precio_unitario * (1 - r_det.descuento / 100));
         DBMS_OUTPUT.PUT_LINE('   - ' || r_det.nombre || ' x' || r_det.cantidad);
      END LOOP;

      DBMS_OUTPUT.PUT_LINE('   Subtotal venta: $' || v_total_venta);
      v_total_cliente := v_total_cliente + v_total_venta;
   END LOOP;

   DBMS_OUTPUT.PUT_LINE('=====================================');
   DBMS_OUTPUT.PUT_LINE('Total comprado por el cliente: $' || v_total_cliente);

END;
/
