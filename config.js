/**
 * Bellavista — Supabase configuration
 *
 * SETUP (una sola vez):
 *   1. Crear proyecto en https://supabase.com/dashboard (region: South America)
 *   2. Project Settings → API
 *   3. Copiar "Project URL"     → reemplazar SUPABASE_URL
 *   4. Copiar "anon public" key → reemplazar SUPABASE_ANON
 *   5. git push (Vercel autodeploya)
 *
 * Las dos llaves son PÚBLICAS por diseño. Identifican el proyecto, no autorizan.
 * La protección real viene de las RLS policies (en supabase-schema.sql).
 */
window.BELLAVISTA_CONFIG = {
  SUPABASE_URL:  'https://YOUR-PROJECT.supabase.co',
  SUPABASE_ANON: 'YOUR-ANON-KEY-HERE',
  WHATSAPP:      '56974984220',
};

window.bv = window.supabase.createClient(
SUPABASE_URL:  'https://YOUR-PROJECT.supabase.co',
  SUPABASE_ANON: 'YOUR-ANON-KEY-HERE',
  { auth: { persistSession: true, autoRefreshToken: true } }
);
