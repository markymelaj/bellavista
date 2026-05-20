# Bellavista — Salto del Laja

Plataforma web para Camping y Minimarket Bellavista.  
Hub QR → sitio del camping → minimarket con pedidos por WhatsApp.

**URL de producción:** https://campingbellavista.vercel.app

---

## Estructura de archivos

```
/
├── index.html        → Hub QR (página raíz, destino del código QR físico)
├── camping.html      → Sitio del Camping Bellavista (reconstruido)
├── minimarket.html   → Minimarket Bellavista (catálogo + pedidos WhatsApp)
├── qr.html           → Código QR imprimible / descargable
├── vercel.json       → Configuración Vercel (clean URLs + headers de seguridad)
└── README.md         → Este archivo
```

> **Sin build step.** Todo es HTML + CSS + JS vanilla. Vercel lo despliega directo.

---

## Deploy en Vercel (primera vez)

1. Sube este repositorio a GitHub
2. En [vercel.com](https://vercel.com) → **Add New Project** → importa el repo
3. En la configuración del proyecto:
   - **Framework Preset:** Other
   - **Build Command:** *(dejar vacío)*
   - **Output Directory:** *(dejar vacío / `.`)*
4. Clic en **Deploy**

Listo. Vercel detecta `vercel.json` y aplica clean URLs y headers automáticamente.

### Clean URLs habilitadas

Con `cleanUrls: true` en `vercel.json`, las páginas son accesibles sin `.html`:

| Archivo          | URL limpia                                        |
|------------------|---------------------------------------------------|
| `index.html`     | `campingbellavista.vercel.app`                   |
| `camping.html`   | `campingbellavista.vercel.app/camping`           |
| `minimarket.html`| `campingbellavista.vercel.app/minimarket`        |
| `qr.html`        | `campingbellavista.vercel.app/qr`                |

---

## Configuración post-deploy

| Qué configurar          | Dónde                           | Estado         |
|-------------------------|---------------------------------|----------------|
| WhatsApp camping        | `camping.html` — links WA       | ✅ +56974984220 |
| WhatsApp minimarket     | `minimarket.html` — `WA_NUMBER` | ✅ +56974984220 |
| Catálogo minimarket     | `minimarket.html` — array `PRODUCTS` | ⚙️ Expandir |
| Precios catálogo        | Agregar campo `price` en `PRODUCTS` | 🔜 Pendiente |
| URL en el QR físico     | `qr.html` — atributo `data=` en img src | ✅ Fija a producción |

---

## Supabase

**No se usa Supabase en esta versión.** Todo opera vía WhatsApp.

La arquitectura actual es completamente estática y no requiere base de datos.  
La integración con Eleventa (pedidos desde web → ticket en POS) es fase siguiente,  
evaluando si Eleventa expone API/webhook en el plan activo.

---

## QR físico

El código QR ya está generado en `qr.html`. Para imprimirlo:

1. Ir a `campingbellavista.vercel.app/qr`
2. Clic en **Imprimir** o **Descargar PNG (800px)**
3. El PNG descargado es de 800×800px — suficiente para imprimir hasta A4

El QR apunta a `https://campingbellavista.vercel.app` (la raíz).  
**No cambies el dominio una vez impreso el QR físico.**

---

## Agregar precios al minimarket

En `minimarket.html`, el array `PRODUCTS` acepta un campo `price`:

```js
{ id: 1, cat: 'panaderia', emoji: '🍞', name: 'Pan marraqueta', badge: 'Fresco', price: 200 },
```

Para mostrarlos, agrega en el template del `renderProducts()`:

```js
${p.price ? `<span class="product-price">$${p.price.toLocaleString('es-CL')}</span>` : ''}
```

---

## Próxima fase

- [ ] Integración Eleventa (API / webhook)
- [ ] Página "Próximamente" con contenido real (eventos, internet nativo, productos caseros)
- [ ] Dominio propio (actualizar QR impreso si se cambia)
- [ ] Precios en catálogo minimarket

---

*Luminart SpA — Región del Biobío, Chile*
