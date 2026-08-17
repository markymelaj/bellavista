// Configuración del sitio Bellavista.
// DOS números, DOS usos — no se mezclan:
//   WHATSAPP_MINIMARKET : minimarket y pedidos online  (+56 9 2063 0698)
//   WHATSAPP            : camping / Alejandra          (+56 9 7498 4220) — lo usan
//                         las demás páginas del sitio, igual que hasta ahora.
window.BELLAVISTA_CONFIG = {
  SUPABASE_URL:  'https://wtqxyclosajruswjjcbm.supabase.co',
  SUPABASE_ANON: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Ind0cXh5Y2xvc2FqcnVzd2pqY2JtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzk3OTg2NTQsImV4cCI6MjA5NTM3NDY1NH0.wsy3gHEQ1Mu3_rXlNHG8rD6PYxTZxRDkkDJlYR53JM4',
  WHATSAPP_MINIMARKET: '56920630698',
  WHATSAPP:            '56974984220',
};
window.bv = window.supabase.createClient(
  window.BELLAVISTA_CONFIG.SUPABASE_URL,
  window.BELLAVISTA_CONFIG.SUPABASE_ANON,
  { auth: { persistSession: true, autoRefreshToken: true } }
);
