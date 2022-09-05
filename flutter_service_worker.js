'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "assets/AssetManifest.json": "574a69a20fcfd47380ba76a952d11bbf",
"assets/assets/images/hulk.png": "91a58925434e9b69c9106f5b4b430522",
"assets/assets/images/ironman.png": "31f12136ebcdbc9638ced1b5b7af6b93",
"assets/assets/images/star_empty.png": "62cef5102a00b10d9b424ff3df0abfbf",
"assets/assets/images/star_filled.png": "c3d6a06e46e6c419f52f4a1bb3ab5f7e",
"assets/assets/images/superman.png": "e92323ef638eda74d9c8a514d089bc8a",
"assets/assets/images/unknown.png": "e1e65d6dda867b68abaa3ab179c0e5c9",
"assets/FontManifest.json": "7b2a36307916a9721811788013e65289",
"assets/fonts/MaterialIcons-Regular.otf": "95db9098c58fd6db106f1116bae85a0b",
"assets/google_fonts/OpenSans-Bold.ttf": "5bc6b8360236a197d59e55f72b02d4bf",
"assets/google_fonts/OpenSans-BoldItalic.ttf": "c1817c8c96e3dca8b13f779ee339b1bc",
"assets/google_fonts/OpenSans-ExtraBold.ttf": "907d99fe588e4649680159671dfe74f4",
"assets/google_fonts/OpenSans-ExtraBoldItalic.ttf": "4991d99c8494b79917a682eac37d0555",
"assets/google_fonts/OpenSans-Italic.ttf": "07cd1acf656521af831f0a37e304c5bb",
"assets/google_fonts/OpenSans-Light.ttf": "3dd221ea976bc4c617c40d366580bfe8",
"assets/google_fonts/OpenSans-LightItalic.ttf": "bc84c22b39c8edfaaa7e821477ce9215",
"assets/google_fonts/OpenSans-Medium.ttf": "0cbcac22e73cab1d6dbf2cfcc269b942",
"assets/google_fonts/OpenSans-MediumItalic.ttf": "af8809ff3bd655a62950c8e21361695f",
"assets/google_fonts/OpenSans-Regular.ttf": "3eb5459d91a5743e0deaf2c7d7896b08",
"assets/google_fonts/OpenSans-SemiBold.ttf": "af0b2118d34dcaf6e671ee67cf4d5be2",
"assets/google_fonts/OpenSans-SemiBoldItalic.ttf": "ac6de8932b6838e3e7739115e2145a7e",
"assets/NOTICES": "c72d4004ac0316db5f561b8cd322c1ee",
"assets/shaders/ink_sparkle.frag": "ae6c1fd6f6ee6ee952cde379095a8f3f",
"canvaskit/canvaskit.js": "2bc454a691c631b07a9307ac4ca47797",
"canvaskit/canvaskit.wasm": "bf50631470eb967688cca13ee181af62",
"canvaskit/profiling/canvaskit.js": "38164e5a72bdad0faa4ce740c9b8e564",
"canvaskit/profiling/canvaskit.wasm": "95a45378b69e77af5ed2bc72b2209b94",
"favicon.png": "d32f5889090e9e84f00bf0ac41ba0676",
"flutter.js": "f85e6fb278b0fd20c349186fb46ae36d",
"icons/Icon-192.png": "8b8ea7dbe36d12ec45308eccb7f8e577",
"icons/Icon-512.png": "909090a4420fc42e2478b1855bd6648f",
"icons/Icon-maskable-192.png": "8b8ea7dbe36d12ec45308eccb7f8e577",
"icons/Icon-maskable-512.png": "909090a4420fc42e2478b1855bd6648f",
"index.html": "cfab94b1f5158d24ed5f243c8c469842",
"/": "cfab94b1f5158d24ed5f243c8c469842",
"main.dart.js": "1403c2c018837aa5ca173e798d626727",
"manifest.json": "0633522f46f5d553ad04fc877dc847b9",
"splash/img/dark-1x.png": "dfd1b8ff00c571ceb69e9fde529fa060",
"splash/img/dark-2x.png": "0ea43826d9b346e459a582325b5173b2",
"splash/img/dark-3x.png": "46b7a129e14574d5fe0b0cb42a111211",
"splash/img/dark-4x.png": "909090a4420fc42e2478b1855bd6648f",
"splash/img/light-1x.png": "dfd1b8ff00c571ceb69e9fde529fa060",
"splash/img/light-2x.png": "0ea43826d9b346e459a582325b5173b2",
"splash/img/light-3x.png": "46b7a129e14574d5fe0b0cb42a111211",
"splash/img/light-4x.png": "909090a4420fc42e2478b1855bd6648f",
"splash/splash.js": "d6c41ac4d1fdd6c1bbe210f325a84ad4",
"splash/style.css": "846e933c854e5d3d1eebe07ff4c5c14a",
"version.json": "2ec6216fb651b6d2cc70b85867b4bb13"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "main.dart.js",
"index.html",
"assets/AssetManifest.json",
"assets/FontManifest.json"];
// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});

// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});

// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});

self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});

// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}

// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
