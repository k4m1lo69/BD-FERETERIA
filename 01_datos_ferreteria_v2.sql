-- ============================================================
-- EV1 BDY1103 - Ferreteria ViSol
-- Datos de prueba v2 (esquema con detalle_pedidos)
-- ============================================================

-- CLIENTES
INSERT INTO clientes (nombre, email, telefono) VALUES ('Comercial Andes SPA', 'contacto@andes.cl', '+56911111111');
INSERT INTO clientes (nombre, email, telefono) VALUES ('Distribuidora Sur Ltda', 'ventas@sur.cl', '+56922222222');
INSERT INTO clientes (nombre, email, telefono) VALUES ('Retail Norte SA', 'info@retailnorte.cl', '+56933333333');
INSERT INTO clientes (nombre, email, telefono) VALUES ('Import Export Bio Bio', 'contacto@biobio.cl', '+56944444444');
INSERT INTO clientes (nombre, email, telefono) VALUES ('Tienda Central', 'admin@tiendacentral.cl', '+56955555555');

-- REGIONES / CIUDADES
INSERT INTO regiones (nombre) VALUES ('Metropolitana');
INSERT INTO regiones (nombre) VALUES ('Biobio');
INSERT INTO regiones (nombre) VALUES ('Antofagasta');
INSERT INTO regiones (nombre) VALUES ('Valparaiso');

INSERT INTO ciudades (nombre, region_id) VALUES ('Santiago',    (SELECT id FROM regiones WHERE nombre = 'Metropolitana'));
INSERT INTO ciudades (nombre, region_id) VALUES ('Concepcion',  (SELECT id FROM regiones WHERE nombre = 'Biobio'));
INSERT INTO ciudades (nombre, region_id) VALUES ('Antofagasta', (SELECT id FROM regiones WHERE nombre = 'Antofagasta'));
INSERT INTO ciudades (nombre, region_id) VALUES ('Los Angeles', (SELECT id FROM regiones WHERE nombre = 'Biobio'));
INSERT INTO ciudades (nombre, region_id) VALUES ('Valparaiso',  (SELECT id FROM regiones WHERE nombre = 'Valparaiso'));

-- DIRECCIONES
INSERT INTO direcciones (calle, codigo_postal, tipo, ciudad_id, cliente_id)
VALUES ('Av. Providencia 1234', '7500000', 'FACTURACION', (SELECT id FROM ciudades WHERE nombre = 'Santiago'), 1);
INSERT INTO direcciones (calle, codigo_postal, tipo, ciudad_id, cliente_id)
VALUES ('Calle Chacabuco 500', '4030000', 'ENTREGA', (SELECT id FROM ciudades WHERE nombre = 'Concepcion'), 2);
INSERT INTO direcciones (calle, codigo_postal, tipo, ciudad_id, cliente_id)
VALUES ('Av. Argentina 200', '1240000', 'FACTURACION', (SELECT id FROM ciudades WHERE nombre = 'Antofagasta'), 3);
INSERT INTO direcciones (calle, codigo_postal, tipo, ciudad_id, cliente_id)
VALUES ('Los Aromos 45', '4400000', 'ENTREGA', (SELECT id FROM ciudades WHERE nombre = 'Los Angeles'), 4);
INSERT INTO direcciones (calle, codigo_postal, tipo, ciudad_id, cliente_id)
VALUES ('Av. Brasil 890', '2340000', 'FACTURACION', (SELECT id FROM ciudades WHERE nombre = 'Valparaiso'), 5);

-- CATEGORIAS / MARCAS
INSERT INTO categorias (nombre) VALUES ('Herramientas Manuales');
INSERT INTO categorias (nombre) VALUES ('Herramientas Electricas');
INSERT INTO categorias (nombre) VALUES ('Materiales de Construccion');
INSERT INTO categorias (nombre) VALUES ('Pinturas y Barnices');
INSERT INTO categorias (nombre) VALUES ('Tornillos y Fijaciones');

INSERT INTO marcas (nombre) VALUES ('Bosch');
INSERT INTO marcas (nombre) VALUES ('Stanley');
INSERT INTO marcas (nombre) VALUES ('Makita');
INSERT INTO marcas (nombre) VALUES ('Sherwin Williams');
INSERT INTO marcas (nombre) VALUES ('Fischer');

-- PRODUCTOS
INSERT INTO productos (nombre, descripcion, precio, sku, categoria_id, marca_id) VALUES ('Taladro Percutor 750W', 'Taladro percutor profesional 750W', 55000, 'SKU-1001', 2, 1);
INSERT INTO productos (nombre, descripcion, precio, sku, categoria_id, marca_id) VALUES ('Martillo Carpintero 16oz', 'Martillo de carpintero mango fibra', 8500, 'SKU-1002', 1, 2);
INSERT INTO productos (nombre, descripcion, precio, sku, categoria_id, marca_id) VALUES ('Amoladora Angular 4.5"', 'Amoladora angular 850W', 42000, 'SKU-1003', 2, 3);
INSERT INTO productos (nombre, descripcion, precio, sku, categoria_id, marca_id) VALUES ('Pintura Latex Blanco 1GL', 'Pintura latex interior/exterior', 18500, 'SKU-1004', 4, 4);
INSERT INTO productos (nombre, descripcion, precio, sku, categoria_id, marca_id) VALUES ('Caja Tornillos Autoperforantes', 'Caja 100un tornillos 1 pulgada', 6200, 'SKU-1005', 5, 5);
INSERT INTO productos (nombre, descripcion, precio, sku, categoria_id, marca_id) VALUES ('Set Destornilladores 6pz', 'Set destornilladores plano/phillips', 9800, 'SKU-1006', 1, 2);
INSERT INTO productos (nombre, descripcion, precio, sku, categoria_id, marca_id) VALUES ('Saco Cemento 25kg', 'Cemento uso general 25kg', 6500, 'SKU-1007', 3, NULL);

-- INVENTARIOS (Amoladora bajo el minimo, a proposito)
INSERT INTO inventarios (producto_id, cantidad, cantidad_minima, ubicacion) VALUES (1, 12, 5, 'Bodega A - Estante 3');
INSERT INTO inventarios (producto_id, cantidad, cantidad_minima, ubicacion) VALUES (2, 40, 10, 'Bodega A - Estante 1');
INSERT INTO inventarios (producto_id, cantidad, cantidad_minima, ubicacion) VALUES (3, 3, 5, 'Bodega B - Estante 2');
INSERT INTO inventarios (producto_id, cantidad, cantidad_minima, ubicacion) VALUES (4, 25, 8, 'Bodega A - Estante 5');
INSERT INTO inventarios (producto_id, cantidad, cantidad_minima, ubicacion) VALUES (5, 200, 50, 'Bodega C - Estante 1');
INSERT INTO inventarios (producto_id, cantidad, cantidad_minima, ubicacion) VALUES (6, 15, 10, 'Bodega A - Estante 1');
INSERT INTO inventarios (producto_id, cantidad, cantidad_minima, ubicacion) VALUES (7, 60, 20, 'Bodega B - Estante 4');

-- PEDIDOS (cabecera) + DETALLE_PEDIDOS
-- Pedido 1: un solo producto (equivalente a antes)
INSERT INTO pedidos (cliente_id, estado, fecha) VALUES (1, 'ENTREGADO', TIMESTAMP '2026-01-10 10:00:00');
INSERT INTO detalle_pedidos (pedido_id, producto_id, cantidad, precio_unitario) VALUES (1, 1, 2, 55000);

-- Pedido 2
INSERT INTO pedidos (cliente_id, estado, fecha) VALUES (2, 'PENDIENTE', TIMESTAMP '2026-02-15 11:30:00');
INSERT INTO detalle_pedidos (pedido_id, producto_id, cantidad, precio_unitario) VALUES (2, 4, 5, 18500);

-- Pedido 3
INSERT INTO pedidos (cliente_id, estado, fecha) VALUES (3, 'ENTREGADO', TIMESTAMP '2026-03-05 09:15:00');
INSERT INTO detalle_pedidos (pedido_id, producto_id, cantidad, precio_unitario) VALUES (3, 3, 1, 42000);

-- Pedido 4: MULTIPRODUCTO (esto es lo que el esquema anterior no podia representar bien)
INSERT INTO pedidos (cliente_id, estado, fecha) VALUES (1, 'EN_PROCESO', TIMESTAMP '2026-03-20 14:00:00');
INSERT INTO detalle_pedidos (pedido_id, producto_id, cantidad, precio_unitario) VALUES (4, 5, 10, 6200);
INSERT INTO detalle_pedidos (pedido_id, producto_id, cantidad, precio_unitario) VALUES (4, 2, 2, 8500);

-- Pedido 5
INSERT INTO pedidos (cliente_id, estado, fecha) VALUES (4, 'PENDIENTE', TIMESTAMP '2026-04-01 08:45:00');
INSERT INTO detalle_pedidos (pedido_id, producto_id, cantidad, precio_unitario) VALUES (5, 7, 20, 6500);

-- Pedido 6
INSERT INTO pedidos (cliente_id, estado, fecha) VALUES (5, 'ENTREGADO', TIMESTAMP '2026-04-10 16:20:00');
INSERT INTO detalle_pedidos (pedido_id, producto_id, cantidad, precio_unitario) VALUES (6, 2, 3, 8500);

-- PAGOS (monto = total real del pedido, calculado a mano aqui para los datos de prueba)
INSERT INTO pagos (pedido_id, monto, metodo_pago, estado, fecha) VALUES (1, 110000, 'TRANSFERENCIA', 'CONFIRMADO', TIMESTAMP '2026-01-10 10:05:00');
INSERT INTO pagos (pedido_id, monto, metodo_pago, estado, fecha) VALUES (3, 42000, 'TARJETA', 'CONFIRMADO', TIMESTAMP '2026-03-05 09:20:00');
INSERT INTO pagos (pedido_id, monto, metodo_pago, estado, fecha) VALUES (6, 25500, 'EFECTIVO', 'CONFIRMADO', TIMESTAMP '2026-04-10 16:25:00');

-- REPORTES
INSERT INTO reportes (pedido_id, tipo, descripcion, fecha_generacion, estado) VALUES (1, 'DETALLE_PEDIDO', 'Reporte de detalle para pedido entregado', TIMESTAMP '2026-01-11 09:00:00', 'GENERADO');
INSERT INTO reportes (pedido_id, tipo, descripcion, fecha_generacion, estado) VALUES (NULL, 'VENTAS_MENSUAL', 'Reporte agregado de ventas de enero 2026', TIMESTAMP '2026-02-01 09:00:00', 'GENERADO');
INSERT INTO reportes (pedido_id, tipo, descripcion, fecha_generacion, estado) VALUES (NULL, 'STOCK_CRITICO', 'Reporte de productos bajo stock minimo', TIMESTAMP '2026-04-15 09:00:00', 'GENERADO');

-- USUARIOS
INSERT INTO usuarios (username, password, rol) VALUES ('admin', 'hash_admin_123', 'ADMIN');
INSERT INTO usuarios (username, password, rol) VALUES ('vendedor1', 'hash_vend_456', 'VENDEDOR');
INSERT INTO usuarios (username, password, rol) VALUES ('bodeguero1', 'hash_bod_789', 'BODEGA');

COMMIT;

-- Verificacion rapida: total por pedido usando la vista (incluye el pedido multiproducto)
SELECT * FROM vw_pedidos_totales ORDER BY pedido_id;
