# Bellavista — Cercano a Saltos del Laja

Plataforma web para Camping y Minimarket Bellavista.
Hub QR → camping / minimarket → pedidos por WhatsApp.

**URL de producción:** https://bellavista-topaz.vercel.app

---

## Estructura de archivos

```
/
├── index.html         → Hub QR (página raíz)
├── camping.html       → Sitio del Camping
├── minimarket.html    → Catálogo + pedidos por WhatsApp (lee de Supabase)
├── qr.html            → QR imprimible
├── admin.html         → Panel admin (productos, categorías, pedidos, settings)
├── admin-login.html   → Login del admin
├── migrate.html       → Herramienta one-shot para subir Excel a Supabase
├── config.js          → Configuración Supabase compartida
├── supabase-schema.sql→ SQL de tablas y RLS (correr una vez)
├── vercel.json        → Config Vercel
└── README.md
```

> **Sin build step.** Vanilla HTML + JS + Supabase JS desde CDN. Vercel lo despliega tal cual.

---

## Setup inicial (una sola vez)

### Paso 1 — Crear proyecto Supabase

1. Andate a https://supabase.com/dashboard → **New Project**
2. Nombre: `bellavista-minimarket` · Región: **South America (São Paulo)** · Plan: **Free**
3. Esperá ~2 min hasta que esté listo

### Paso 2 — Crear el schema

1. En Supabase: menú lateral → **SQL Editor** → **New query**
2. Pegá todo el contenido de [`supabase-schema.sql`](./supabase-schema.sql)
3. Click **Run** (verde, abajo a la derecha)
4. Verificás en **Table Editor** que están las tablas: `categories`, `products`, `orders`, `order_items`, `settings`
5. La tabla `categories` ya viene poblada con las 12 categorías de Bellavista

### Paso 3 — Crear tu usuario admin

1. En Supabase: **Authentication → Users → Add user → Create new user**
2. Email: tu email · Contraseña: la que vas a usar · **Auto Confirm User: ON**
3. Click **Create user**

### Paso 4 — Copiar las keys a config.js

1. En Supabase: **Project Settings → API**
2. Copiás:
   - `Project URL` → reemplazás `YOUR-PROJECT` en `config.js`
   - `anon public` → reemplazás `YOUR-ANON-KEY-HERE` en `config.js`
3. Editás `config.js`:
   ```js
   window.BELLAVISTA_CONFIG = {
     SUPABASE_URL:  'https://xxxxx.supabase.co',
     SUPABASE_ANON: 'eyJhbGc...',
     WHATSAPP:      '56974984220',
   };
   ```
4. Commit + push → Vercel autodeploya

### Paso 5 — Migrar el Excel de productos

1. Andá a `https://bellavista-topaz.vercel.app/migrate`
2. Pegás la **service_role** key (Supabase → Settings → API → service_role → Reveal)
3. Subís el archivo `minimarket_bellavista_limpio.xlsx` (lo tenés del proyecto)
4. Subís el `image_results.csv` (opcional, agrega 194 imágenes)
5. Click **Iniciar migración** → 30-60 segundos
6. Verificás en Supabase → Table Editor → **products** que tiene los 1939 productos

### Paso 6 — Listo

| URL | Qué hace |
|-----|----------|
| `/` | Hub QR |
| `/camping` | Sitio del camping |
| `/minimarket` | Catálogo público (lee Supabase) |
| `/admin-login` | Login admin |
| `/admin` | Panel admin (requiere login) |
| `/migrate` | Migración Excel (no compartas esta URL) |

---

## Cómo funciona

### Frontend público

`minimarket.html` carga productos y categorías desde Supabase al boot. El cliente arma el pedido en localStorage, lo envía: se guarda en la tabla `orders` y se abre WhatsApp con el mensaje formateado.

### Admin

`admin.html` es un SPA simple con hash routing (`#dashboard`, `#productos`, etc.). Todas las operaciones de DB usan el cliente Supabase autenticado. Si no estás logueado, redirige a `/admin-login`.

### Seguridad (RLS)

Las políticas en `supabase-schema.sql`:
- Público puede **leer** categorías y productos activos
- Público puede **insertar** orders y order_items (para crear pedidos)
- Solo usuarios autenticados pueden hacer cualquier otra operación (editar productos, ver todos los pedidos, etc.)

La `anon` key es pública por diseño. La `service_role` solo se usa una vez en `/migrate` y nunca se guarda en código.

---

## Editar productos diariamente

1. `/admin-login` con tu usuario
2. `/admin#productos` → buscás, editás precio/stock directo en la tabla (blur para guardar), o click "Editar" para modal completo
3. Los cambios son inmediatos en `/minimarket`

## Recibir pedidos

`/admin#pedidos` muestra todos los pedidos. Cambiás estado con el dropdown (nuevo → en preparación → listo → entregado).

---

## QR físico

El QR de `qr.html` apunta a la raíz. Sin cambios.

---

*Luminart SpA — Región del Biobío, Chile*
