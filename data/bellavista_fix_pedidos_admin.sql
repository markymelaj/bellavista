-- Bellavista - FIX DEFINITIVO pedidos hacia admin
-- Ejecutar en Supabase SQL Editor.

begin;

-- Columnas necesarias
alter table public.categories add column if not exists image_url text;
alter table public.orders add column if not exists customer_name text;
alter table public.orders add column if not exists customer_phone text;
alter table public.orders add column if not exists delivery_type text default 'retiro';
alter table public.orders add column if not exists delivery_detail text;
alter table public.orders add column if not exists payment_method text default 'efectivo';
alter table public.orders add column if not exists notes text;
alter table public.orders add column if not exists subtotal int default 0;
alter table public.orders add column if not exists status text default 'nuevo';
alter table public.orders add column if not exists completed_at timestamptz;
alter table public.order_items add column if not exists product_unit text default 'unidad';
alter table public.order_items alter column quantity type numeric(10,3) using quantity::numeric;

-- RLS y permisos para que la web pública pueda crear pedidos y el admin autenticado pueda verlos/gestionarlos
alter table public.orders enable row level security;
alter table public.order_items enable row level security;

drop policy if exists orders_insert on public.orders;
create policy orders_insert on public.orders for insert with check (true);

drop policy if exists items_insert on public.order_items;
create policy items_insert on public.order_items for insert with check (true);

drop policy if exists ord_auth on public.orders;
create policy ord_auth on public.orders for all using (auth.role() = 'authenticated') with check (auth.role() = 'authenticated');

drop policy if exists items_auth on public.order_items;
create policy items_auth on public.order_items for all using (auth.role() = 'authenticated') with check (auth.role() = 'authenticated');

grant usage on schema public to anon, authenticated;
grant insert on public.orders to anon, authenticated;
grant insert on public.order_items to anon, authenticated;
grant select, update, delete on public.orders to authenticated;
grant select, update, delete on public.order_items to authenticated;
grant usage, select on all sequences in schema public to anon, authenticated;

commit;

-- Verificación
select 'orders_insert_policy_ok' as check, count(*) from pg_policies where schemaname='public' and tablename='orders' and policyname='orders_insert';
select 'items_insert_policy_ok' as check, count(*) from pg_policies where schemaname='public' and tablename='order_items' and policyname='items_insert';
