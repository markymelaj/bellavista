/* Góndola 5.2 RC2 · service worker de red.
   Se mantiene activo para que Android permita instalar la aplicación, pero no guarda
   HTML, credenciales ni resultados. La Góndola requiere internet para hablar con la
   caja; servir una copia antigua sin red sería engañoso y riesgoso. */
self.addEventListener('install', function(){ self.skipWaiting(); });
self.addEventListener('activate', function(event){
  event.waitUntil((async function(){
    var keys=await caches.keys();
    await Promise.all(keys.map(function(key){return caches.delete(key);}));
    await self.clients.claim();
  })());
});
self.addEventListener('fetch', function(event){
  if(event.request.method!=='GET')return;
  var url=new URL(event.request.url);
  if(url.origin!==self.location.origin)return;
  event.respondWith(fetch(event.request,{cache:event.request.mode==='navigate'?'no-store':'default'}));
});
