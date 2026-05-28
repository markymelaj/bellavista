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
  SUPABASE_URL:  'https://wtqxyclosajruswjjcbm.supabase.co',
  SUPABASE_ANON: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Ind0cXh5Y2xvc2FqcnVzd2pqY2JtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzk3OTg2NTQsImV4cCI6MjA5NTM3NDY1NH0.wsy3gHEQ1Mu3_rXlNHG8rD6PYxTZxRDkkDJlYR53JM4',
  WHATSAPP:      '56974984220',
};

window.bv = window.supabase.createClient(
SUPABASE_URL:  'https://wtqxyclosajruswjjcbm.supabase.co',
  SUPABASE_ANON: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Ind0cXh5Y2xvc2FqcnVzd2pqY2JtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzk3OTg2NTQsImV4cCI6MjA5NTM3NDY1NH0.wsy3gHEQ1Mu3_rXlNHG8rD6PYxTZxRDkkDJlYR53JM4',
  WHATSAPP:      '56974984220',
  { auth: { persistSession: true, autoRefreshToken: true } }
);
