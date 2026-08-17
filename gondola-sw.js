/* Góndola 5.2 RC1 — este service worker se retira a propósito.
   La versión anterior guardaba la página y seguía mostrándola aunque el sitio ya
   estuviera actualizado. Este borra todo lo guardado, se da de baja y deja que la
   góndola cargue siempre desde la red (que es lo correcto: sin señal no sirve igual,
   porque necesita hablar con la caja). */
self.addEventListener('install', function(e){ self.skipWaiting(); });
self.addEventListener('activate', function(e){
  e.waitUntil((async function(){
    var keys = await caches.keys();
    await Promise.all(keys.map(function(k){ return caches.delete(k); }));
    await self.registration.unregister();
    var cs = await self.clients.matchAll({type:'window'});
    cs.forEach(function(c){ c.navigate(c.url); });
  })());
});
