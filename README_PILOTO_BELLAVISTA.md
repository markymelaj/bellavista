# Bellavista Minimarket - piloto funcional

## Orden de cierre

1. Subir este proyecto a Vercel/GitHub.
2. En Supabase SQL Editor ejecutar `data/bellavista_supabase_piloto_solo_lista_actual.sql`.
3. En el admin revisar productos activos, destacados y pedidos.
4. Cargar primero fotos de destacados. No frenar el piloto por fotos secundarias.

## Qué hace esta versión

- Deja visibles solo los 108 productos de la lista actual.
- Oculta productos viejos, pero no los borra.
- Guarda el pedido en Supabase antes de abrir WhatsApp.
- El admin permite cambiar estados: Nuevo, Confirmado, En preparación, Preparado, Enviado, Retiro listo, Entregado, Cancelado.
- El cliente puede elegir retiro o envío a confirmar.
- Si pide envío, puede enviar ubicación actual desde el navegador.
- El cliente puede escribir productos que no aparecen en el catálogo en la nota del pedido.

## Decisión operativa

El envío nunca queda prometido automáticamente. Siempre se confirma por WhatsApp según disponibilidad del local. Si no se puede despachar, el pedido queda para retiro.

## Venta al peso

Queso Negrete, palta y cualquier producto con unidad kg quedan resueltos desde el carrito: el cliente suma o resta de 250 g, el total se calcula proporcionalmente y el pedido se guarda en admin con unidad kg.


## Versión kg/fracciones

- Productos con unidad `kg` se venden en pasos de 250 g.
- El subtotal se calcula proporcionalmente al precio por kg.
- `order_items.quantity` debe ser `numeric(10,3)` y `order_items.product_unit` guarda la unidad. El SQL final ya incluye esta migración.
- Para verdulería nueva, cargar productos con `unit = kg` para que usen automáticamente el selector por peso.

## Archivo SQL correcto

Ejecutar `data/bellavista_supabase_piloto_final_kg.sql`.
