# BD-FERETERIA

Proyecto de base de datos para la Evaluación 1 (EV1) de **BDY1103 - Taller de Base de Datos**, DuocUC.

## Caso de negocio

Ferretería ViSol es una empresa retail que comercializa herramientas, materiales de construcción y
productos de ferretería en general. El proyecto modela y automatiza, mediante PL/SQL en Oracle
Database, el ciclo completo de venta: clientes y direcciones, catálogo de productos, inventario,
pedidos (con soporte multiproducto), pagos y generación automática de reportes.

## Requisitos

- Oracle Database Free 23ai (o superior)
- Oracle SQL Developer

## Orden de ejecución

Ejecutar los scripts en este orden exacto (cada uno depende del anterior):

| Script | Contenido |
|---|---|
| `00_esquema_ferreteria.sql` | Esquema completo (13 tablas, normalizado a 3FN, con política ON DELETE explícita) y la vista `vw_pedidos_totales` |
| `01_datos_ferreteria.sql` | Datos de prueba, incluyendo un pedido multiproducto |
| `02_record_varray.sql` | Ejemplos de tipos de datos compuestos RECORD y VARRAY |
| `03_cursores.sql` | Cursores explícitos simples, con parámetros y loops anidados (cliente → pedido → detalle/pago) |
| `04_excepciones.sql` | Excepciones predefinidas de Oracle (`NO_DATA_FOUND`, `TOO_MANY_ROWS`) y definidas por el usuario |
| `05_procedimientos_funciones.sql` | Función `fn_calcular_total_pedido` y procedimiento `sp_registrar_pedido` (recibe VARRAY de productos/cantidades) |
| `06_package.sql` | Package `pkg_gestion_pedidos`, que agrupa la función, el procedimiento y el reporte de stock crítico |
| `07_triggers.sql` | Triggers: validación de stock negativo, alerta automática de stock crítico, y auditoría de pedidos/detalle |

## Modelo de datos

13 tablas: `clientes`, `direcciones`, `regiones`, `ciudades`, `categorias`, `marcas`, `productos`,
`inventarios`, `pedidos`, `detalle_pedidos`, `pagos`, `reportes`, `usuarios`.

Decisiones clave de diseño:
- `pedidos` (cabecera) y `detalle_pedidos` (líneas) están separados para soportar pedidos con varios productos.
- El total de un pedido no se almacena: se calcula con la vista `vw_pedidos_totales` para evitar datos derivados desincronizados.
- `ciudad`/`región` se normalizaron en tablas propias para eliminar la dependencia transitiva dirección → ciudad → región.
- Cada FK tiene una política `ON DELETE` explícita (`CASCADE`, `SET NULL`, o bloqueo) según si la tabla hija depende del todo de su padre o si representa historial de negocio.
