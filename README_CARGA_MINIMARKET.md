# Carga final Minimarket Bellavista

## Qué está listo

- `data/bellavista_carga_productos_final.sql`: carga directa para Supabase SQL Editor.
- `data/bellavista_minimarket_listo.xlsx`: planilla de control con productos, portada y precios pendientes.
- `data/bellavista_productos_para_cargar.csv`: respaldo en formato tabular.
- `migrate.html` actualizado: ahora también respeta columnas `destacado`, `activo`, `posicion` y `unidad` si se usa migración por archivo.
- `minimarket.html` actualizado: los productos sin precio salen como **Consultar precio** y no se pueden agregar al pedido hasta que se edite el precio.
- `admin.html` actualizado: el modal permite editar el campo **Revisión interna** para saber qué falta corregir.

## Carga recomendada

1. Abrir Supabase Dashboard.
2. Ir a **SQL Editor → New query**.
3. Pegar el contenido de `data/bellavista_carga_productos_final.sql`.
4. Presionar **Run**.
5. Revisar el resumen que devuelve al final:
   - productos visibles
   - destacados de portada
   - visibles sin precio
   - visibles para revisión

## Importante

La carga deja como lista definitiva visible los productos preparados en este archivo. Si había productos anteriores en Supabase, quedan ocultos, no borrados.

Los productos principales sin precio quedan visibles como “Consultar precio” para que el minimarket no venda productos a $0. Se editan desde `/admin#productos`.
