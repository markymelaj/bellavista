-- =========================================================================
-- BELLAVISTA — Habilitar OFERTAS en la web (se manejan desde el PDV)
-- Ejecutar UNA VEZ en: Supabase Dashboard → SQL Editor → New query → Run
--
-- Sin esto la web funciona igual, pero las ofertas del PDV llegan sólo como
-- precio rebajado, sin el precio normal tachado ni la etiqueta.
-- =========================================================================

alter table public.products add column if not exists compare_at_price int;
alter table public.products add column if not exists promo_label      text;

comment on column public.products.compare_at_price is
  'Precio normal, para mostrarlo tachado cuando hay oferta. Lo escribe el PDV.';
comment on column public.products.promo_label is
  'Etiqueta de la oferta que ve el cliente (ej: "Oferta fin de semana"). Lo escribe el PDV.';

-- Índice para listar rápido las ofertas vigentes en la portada.
create index if not exists products_promo_idx
  on public.products(compare_at_price)
  where active = true and compare_at_price is not null;
