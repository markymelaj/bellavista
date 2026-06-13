-- =========================================================================
-- BELLAVISTA MINIMARKET — Supabase Schema
-- Ejecutar UNA VEZ en: Supabase Dashboard → SQL Editor → New query → Run
-- =========================================================================

create extension if not exists "uuid-ossp";

-- ---------- TABLAS ----------
create table if not exists public.categories (
  id          uuid primary key default uuid_generate_v4(),
  name        text not null,
  slug        text not null unique,
  icon        text default 'Package',
  image_url   text,
  position    int  not null default 100,
  active      boolean not null default true,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);
create index if not exists categories_pos_idx on public.categories(position) where active = true;

create table if not exists public.products (
  id              uuid primary key default uuid_generate_v4(),
  sku             text not null unique,
  ean             text,
  name            text not null,
  name_normalized text not null,
  slug            text not null unique,
  description     text,
  category_id     uuid references public.categories(id) on delete set null,
  price           int  not null default 0,
  cost            int  default 0,
  stock           int  default 0,
  unit            text default 'unidad',
  active          boolean not null default true,
  featured        boolean not null default false,
  needs_review    text,
  image_url       text,
  image_source    text default 'none',
  position        int  default 100,
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now()
);
create index if not exists products_cat_idx     on public.products(category_id) where active = true;
create index if not exists products_search_idx  on public.products(name_normalized) where active = true;

create table if not exists public.orders (
  id              uuid primary key default uuid_generate_v4(),
  order_number    serial not null,
  customer_name   text,
  customer_phone  text,
  delivery_type   text default 'retiro',
  delivery_detail text,
  payment_method  text default 'efectivo',
  notes           text,
  subtotal        int  not null default 0,
  status          text not null default 'nuevo',
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now()
);
create index if not exists orders_created_idx on public.orders(created_at desc);
create index if not exists orders_status_idx  on public.orders(status);

create table if not exists public.order_items (
  id            uuid primary key default uuid_generate_v4(),
  order_id      uuid not null references public.orders(id) on delete cascade,
  product_id    uuid references public.products(id) on delete set null,
  product_sku   text not null,
  product_name  text not null,
  product_unit  text default 'unidad',
  unit_price    int  not null,
  quantity      numeric(10,3) not null,
  subtotal      int  not null,
  created_at    timestamptz not null default now()
);
create index if not exists order_items_order_idx on public.order_items(order_id);

create table if not exists public.settings (
  key        text primary key,
  value      jsonb not null,
  updated_at timestamptz not null default now()
);

-- ---------- TRIGGER updated_at ----------
create or replace function public.set_updated_at()
returns trigger language plpgsql as $$
begin new.updated_at = now(); return new; end $$;

drop trigger if exists trg_cat_updated on public.categories;
create trigger trg_cat_updated before update on public.categories
  for each row execute function public.set_updated_at();

drop trigger if exists trg_prod_updated on public.products;
create trigger trg_prod_updated before update on public.products
  for each row execute function public.set_updated_at();

drop trigger if exists trg_orders_updated on public.orders;
create trigger trg_orders_updated before update on public.orders
  for each row execute function public.set_updated_at();

-- ---------- RLS ----------
alter table public.categories  enable row level security;
alter table public.products    enable row level security;
alter table public.orders      enable row level security;
alter table public.order_items enable row level security;
alter table public.settings    enable row level security;

drop policy if exists "cat_read"  on public.categories;
create policy "cat_read"  on public.categories for select using (active = true);

drop policy if exists "prod_read" on public.products;
create policy "prod_read" on public.products for select using (active = true);

drop policy if exists "set_read"  on public.settings;
create policy "set_read"  on public.settings for select using (true);

-- Cualquiera puede crear pedidos
drop policy if exists "orders_insert" on public.orders;
create policy "orders_insert" on public.orders for insert with check (true);

drop policy if exists "items_insert"  on public.order_items;
create policy "items_insert"  on public.order_items for insert with check (true);

-- Admin (autenticado) hace de todo
drop policy if exists "cat_auth"   on public.categories;
create policy "cat_auth"   on public.categories for all using (auth.role() = 'authenticated') with check (auth.role() = 'authenticated');

drop policy if exists "prod_auth"  on public.products;
create policy "prod_auth"  on public.products for all using (auth.role() = 'authenticated') with check (auth.role() = 'authenticated');

drop policy if exists "ord_auth"   on public.orders;
create policy "ord_auth"   on public.orders for all using (auth.role() = 'authenticated') with check (auth.role() = 'authenticated');

drop policy if exists "items_auth" on public.order_items;
create policy "items_auth" on public.order_items for all using (auth.role() = 'authenticated') with check (auth.role() = 'authenticated');

drop policy if exists "set_auth"   on public.settings;
create policy "set_auth"   on public.settings for all using (auth.role() = 'authenticated') with check (auth.role() = 'authenticated');

-- ---------- 12 CATEGORÍAS BELLAVISTA ----------
insert into public.categories (name, slug, icon, position) values
  ('Panadería y Pastelería',  'panaderia',         'Croissant',      1),
  ('Bebidas y Licores',       'bebidas',           'Wine',           2),
  ('Lácteos y Embutidos',     'lacteos-embutidos', 'Milk',           3),
  ('Abarrotes',               'abarrotes',         'ShoppingBasket', 4),
  ('Snacks y Golosinas',      'snacks',            'Cookie',         5),
  ('Frutas y Verduras',       'frutas-verduras',   'Apple',          6),
  ('Carnes y Congelados',     'carnes-congelados', 'Beef',           7),
  ('Aseo y Hogar',            'aseo-hogar',        'Sparkles',       8),
  ('Higiene Personal',        'higiene-personal',  'Bath',           9),
  ('Cigarros',                'cigarros',          'Cigarette',     10),
  ('Farmacia',                'farmacia',          'Pill',          11),
  ('Otros',                   'otros',             'Package',       12)
on conflict (slug) do update set name=excluded.name, icon=excluded.icon, position=excluded.position;

-- Settings iniciales
insert into public.settings (key, value) values
  ('store', '{
    "name": "Minimarket Bellavista",
    "tagline": "A la entrada del camping",
    "address": "Camino a Paraguay km 10,5 · Cercano a Saltos del Laja",
    "whatsapp": "+56974984220",
    "hours_open": 9,
    "hours_close": 20
  }'::jsonb)
on conflict (key) do nothing;

-- =========================================================================
-- STORAGE BUCKET para fotos de productos
-- =========================================================================
-- Crear bucket público 'product-images'
insert into storage.buckets (id, name, public)
values ('product-images', 'product-images', true)
on conflict (id) do nothing;

-- Público puede VER las imágenes
drop policy if exists "product-images public read" on storage.objects;
create policy "product-images public read" on storage.objects
  for select using (bucket_id = 'product-images');

-- Solo admin autenticado puede SUBIR
drop policy if exists "product-images auth insert" on storage.objects;
create policy "product-images auth insert" on storage.objects
  for insert with check (bucket_id = 'product-images' and auth.role() = 'authenticated');

-- Solo admin autenticado puede ACTUALIZAR/REEMPLAZAR
drop policy if exists "product-images auth update" on storage.objects;
create policy "product-images auth update" on storage.objects
  for update using (bucket_id = 'product-images' and auth.role() = 'authenticated');

-- Solo admin autenticado puede ELIMINAR
drop policy if exists "product-images auth delete" on storage.objects;
create policy "product-images auth delete" on storage.objects
  for delete using (bucket_id = 'product-images' and auth.role() = 'authenticated');
