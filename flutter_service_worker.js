'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "assets/AssetManifest.json": "32ea56288a445a0fad50541e3a25b881",
"assets/assets/fonts/Montserrat-Black.ttf": "27e3649bab7c62fa21b8837c4842e40e",
"assets/assets/fonts/Montserrat-BlackItalic.ttf": "d9b6ba595b059fc5d48e8f52c30f73b3",
"assets/assets/fonts/Montserrat-Bold.ttf": "ade91f473255991f410f61857696434b",
"assets/assets/fonts/Montserrat-BoldItalic.ttf": "1b38414956c666bd1df78fe5b9c84756",
"assets/assets/fonts/Montserrat-ExtraBold.ttf": "19ba7aa52a78c3896558ac1c0a5fb4c7",
"assets/assets/fonts/Montserrat-ExtraBoldItalic.ttf": "52a50ca037f2f96fa567404dc3c5bdfb",
"assets/assets/fonts/Montserrat-ExtraLight.ttf": "570a244cacd3d78b8c75ac5dd622f537",
"assets/assets/fonts/Montserrat-ExtraLightItalic.ttf": "1170df5548b7e238df5fa14b6f1a753e",
"assets/assets/fonts/Montserrat-Italic.ttf": "a7063e0c0f0cb546ad45e9e24b27bd3b",
"assets/assets/fonts/Montserrat-Light.ttf": "409c7f79a42e56c785f50ed37535f0be",
"assets/assets/fonts/Montserrat-LightItalic.ttf": "01c4560c9c15069b6700ce7ad2e49a9c",
"assets/assets/fonts/Montserrat-Medium.ttf": "c8b6e083af3f94009801989c3739425e",
"assets/assets/fonts/Montserrat-MediumItalic.ttf": "40a74702035bf9ef19053c84ce9a58b9",
"assets/assets/fonts/Montserrat-Regular.ttf": "ee6539921d713482b8ccd4d0d23961bb",
"assets/assets/fonts/Montserrat-SemiBold.ttf": "c641dbee1d75892e4d88bdc31560c91b",
"assets/assets/fonts/Montserrat-SemiBoldItalic.ttf": "83c1ec1f1db9a6416791f7d9d29536f2",
"assets/assets/fonts/Montserrat-Thin.ttf": "43dd5b7a3d277362d5e801e5353e3a01",
"assets/assets/fonts/Montserrat-ThinItalic.ttf": "3c2b290f95cd5b33c3ead2911064a2ab",
"assets/assets/icons/award.svg": "956a086e2c9f00d38f52e63ca0a0d5d4",
"assets/assets/icons/bank.svg": "607c03316b4b818ccbf4e7b0299015e2",
"assets/assets/icons/bank_2.svg": "dec653a246eb6dc79660db5a2c24ad42",
"assets/assets/icons/bills.svg": "890db374284a85d204c0f2b0020cf052",
"assets/assets/icons/bills_2.svg": "032b94d499c77c79516b444ed1895304",
"assets/assets/icons/box.svg": "20df5d5061184ac2b4f72293bce7f698",
"assets/assets/icons/bus.svg": "57b7a97e7de1d47d3fe84d35298a40be",
"assets/assets/icons/business.svg": "1a5d197a35e4b56e4ef7e26dd19c722a",
"assets/assets/icons/business_2.svg": "9d30eccc70b3809010c6123258796395",
"assets/assets/icons/business_3.svg": "723fbf3fb73fd47ecb8a37c8289c9968",
"assets/assets/icons/bus_2.svg": "dd715600ba5464af4cb3243eeee08470",
"assets/assets/icons/card.svg": "709c806465e141e31a383a4b85655a74",
"assets/assets/icons/debt.svg": "0cddd1ee1639f8336110adaf5f6203fa",
"assets/assets/icons/debt_collection.svg": "a911c1b75573a0cb7570fa4659f32e7d",
"assets/assets/icons/donation.svg": "0a138eaa7e04060400572b4865c6b0bc",
"assets/assets/icons/education.svg": "59e5bf153468f5feb28abc6f4e433107",
"assets/assets/icons/family.svg": "328a4628d47d4dff81346b6278c0de4d",
"assets/assets/icons/film.svg": "ddc4d458eb1ab4571923c25f9832628d",
"assets/assets/icons/fitness.svg": "8be2eb47195bd9554394b8604d6951e0",
"assets/assets/icons/food.svg": "1a027b45c4b9669a91c13023cac89ed2",
"assets/assets/icons/gift.svg": "33de0d3352438196332492a6463f0f94",
"assets/assets/icons/gift_money.svg": "b775d8609ff571367a023da8248334c7",
"assets/assets/icons/health.svg": "9d560c35b18d94e06acb436631fc0566",
"assets/assets/icons/health_2.svg": "3f5f04493b987ae05965a4fdcc30e4f9",
"assets/assets/icons/hotdog.svg": "154be798303455624933d003e530d501",
"assets/assets/icons/insurance.svg": "43a73e5f545cfac6ca5da7ab97c3271b",
"assets/assets/icons/investment.svg": "1cff9e6dd7d23ae34066aea3e22d24f0",
"assets/assets/icons/investment_2.svg": "4d4b0f0c4c4364c8a81a015e88b2b870",
"assets/assets/icons/investment_3.svg": "240b3f3bba16c35e3788e20d277a9f83",
"assets/assets/icons/loan.svg": "f3c597e8fe7309ff60fdca355e260f66",
"assets/assets/icons/love.svg": "3b9508a270b30bd66103d445a052e73a",
"assets/assets/icons/money_in.svg": "ce803e5104b423327fa8a0e23004cc92",
"assets/assets/icons/music.svg": "5d9093d11327d8374177ceee10d0e095",
"assets/assets/icons/other.svg": "317da781c1ea0300fa23542f9e15fdf8",
"assets/assets/icons/repayment.svg": "c729a1fa0786181584fe822eb5c8b057",
"assets/assets/icons/salary.svg": "f4baae410ffa440c716a8080cf40f762",
"assets/assets/icons/school_bus.svg": "6f8e4fff108db3f4e06faa4f4f9bf07c",
"assets/assets/icons/selling.svg": "5ae0062564329880161864606dbe927a",
"assets/assets/icons/shopping.svg": "1bf654afe369562a60dfaea51d4c50ad",
"assets/assets/icons/shopping_2.svg": "f84ecaea84f14a45bb03f5ab8712640e",
"assets/assets/icons/transportation.svg": "a5a4b5cb6de627d67719c418943fa29a",
"assets/assets/icons/transportation_2.svg": "ec257700cde0abc477869b01eae83e76",
"assets/assets/icons/travel.svg": "06a651f010ee0c2310276e21fb2f9eee",
"assets/assets/icons/travel_2.svg": "755a3fad5ce8969feeb266ec9e1faf6b",
"assets/assets/icons/wallet.svg": "61e8a71bd4d1ba2394923cc7cb6702bb",
"assets/assets/icons/wallet_2.svg": "a13bd6e4d005616e88460af63a2e6aff",
"assets/assets/icons/wallet_3.svg": "e43461f7497ea0132fa0beb37ea8778c",
"assets/assets/icons/wallet_4.svg": "4f69924b4c778a0799ef9ac61ed53e2d",
"assets/assets/icons/water.svg": "a639bd60316689904e71001ed80b4c17",
"assets/assets/icons/wine.svg": "545c93ca826ba66752a388df00aceb39",
"assets/assets/images/1.jpg": "a26e9a52e1619f52262734e891ab7d67",
"assets/assets/images/2.jpg": "615c4c6f84e662ac3541d3f4c9079037",
"assets/assets/images/3.jpg": "7ad7c773f0d72088e1eb30d29b75a502",
"assets/assets/images/4.jpg": "707f23340ab7b9ada0f89b61192ef2a6",
"assets/assets/images/alert.svg": "ab2e968295b82abf2ec435dc24bd487d",
"assets/assets/images/apple.jpg": "fb7ce08ebbbd83d866cb2f3bb80cbd8f",
"assets/assets/images/apple.svg": "955ab9b764c2a72e377b86ed5c7c1d00",
"assets/assets/images/carousel/carousel_1.svg": "1e143814463dfc9c001a7d5e6967204e",
"assets/assets/images/carousel/carousel_2.svg": "92fd29a4858c2f4170b501fdc9953d46",
"assets/assets/images/carousel/carousel_3.svg": "bdaf706ae463ab1e12575f0641e4c6c8",
"assets/assets/images/coin.svg": "248e9aad7daba4cf289ad053a89e1409",
"assets/assets/images/email.svg": "919b95b37cb52fcf6e2db8576ffa843b",
"assets/assets/images/error.svg": "b2138751ec3c40bb5c24fcea41aaff9d",
"assets/assets/images/facebook.jpg": "dc9a3d95c6ac484f448cb37e46c13cbe",
"assets/assets/images/facebook.svg": "ce66318428f95add7075773f4b3378c6",
"assets/assets/images/forgot.png": "9f9068503b7b2833a07ad75b3581f9e7",
"assets/assets/images/forgotPass.jpg": "acadd2ebf8838b1102b4c05dc861f36b",
"assets/assets/images/google.jpg": "bbe3a3e5c45e1c97d3653cdabcce8367",
"assets/assets/images/google.svg": "5f29703e6e1efc72919323bffaea66bd",
"assets/assets/images/Login_bg.png": "c34a8cf3a8fe13e91d035868f79dc99b",
"assets/assets/images/LogoAP.png": "c988201ce2816f15c9ce55d3e822f6b8",
"assets/assets/images/logoApple.png": "8610400fce9109bd20b9782409dbf426",
"assets/assets/images/logoEmail.png": "cc997802c2a14cba494bb6bed707391d",
"assets/assets/images/logoFB.png": "95243a1ce347fd2582580879e5d210c8",
"assets/assets/images/logoGG.png": "c8bf7c087ca9793d094042845707ffac",
"assets/assets/images/money_man.svg": "1e143814463dfc9c001a7d5e6967204e",
"assets/assets/images/success.svg": "d29f1779664178a55ed87236fd97c302",
"assets/assets/images/time.svg": "7d60907433a640d0033f155393c295ae",
"assets/FontManifest.json": "d552170c3c5a91471c70b65731bea1c7",
"assets/fonts/MaterialIcons-Regular.otf": "4e6447691c9509f7acdbf8a931a85ca1",
"assets/NOTICES": "3863c76ccc6d5372cec3cd7c09509248",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "6d342eb68f170c97609e9da345464e5e",
"assets/packages/flutter_iconpicker/fonts/fa-brands-400.ttf": "51d23d1c30deda6f34673e0d5600fd38",
"assets/packages/flutter_iconpicker/fonts/fa-regular-400.ttf": "d51b09f7b8345b41dd3b2201f653c62b",
"assets/packages/flutter_iconpicker/fonts/fa-solid-900.ttf": "0ea892e09437fcaa050b2b15c53173b7",
"assets/packages/flutter_iconpicker/fonts/LineAwesome.ttf": "bcc78af7963d22efd760444145073cd3",
"assets/packages/font_awesome_flutter/lib/fonts/fa-brands-400.ttf": "00bb2b684be61e89d1bc7d75dee30b58",
"assets/packages/font_awesome_flutter/lib/fonts/fa-regular-400.ttf": "4b6a9b7c20913279a3ad3dd9c96e155b",
"assets/packages/font_awesome_flutter/lib/fonts/fa-solid-900.ttf": "dffd9504fcb1894620fa41c700172994",
"assets/packages/rflutter_alert/assets/images/2.0x/close.png": "abaa692ee4fa94f76ad099a7a437bd4f",
"assets/packages/rflutter_alert/assets/images/2.0x/icon_error.png": "2da9704815c606109493d8af19999a65",
"assets/packages/rflutter_alert/assets/images/2.0x/icon_info.png": "612ea65413e042e3df408a8548cefe71",
"assets/packages/rflutter_alert/assets/images/2.0x/icon_success.png": "7d6abdd1b85e78df76b2837996749a43",
"assets/packages/rflutter_alert/assets/images/2.0x/icon_warning.png": "e4606e6910d7c48132912eb818e3a55f",
"assets/packages/rflutter_alert/assets/images/3.0x/close.png": "98d2de9ca72dc92b1c9a2835a7464a8c",
"assets/packages/rflutter_alert/assets/images/3.0x/icon_error.png": "15ca57e31f94cadd75d8e2b2098239bd",
"assets/packages/rflutter_alert/assets/images/3.0x/icon_info.png": "e68e8527c1eb78949351a6582469fe55",
"assets/packages/rflutter_alert/assets/images/3.0x/icon_success.png": "1c04416085cc343b99d1544a723c7e62",
"assets/packages/rflutter_alert/assets/images/3.0x/icon_warning.png": "e5f369189faa13e7586459afbe4ffab9",
"assets/packages/rflutter_alert/assets/images/close.png": "13c168d8841fcaba94ee91e8adc3617f",
"assets/packages/rflutter_alert/assets/images/icon_error.png": "f2b71a724964b51ac26239413e73f787",
"assets/packages/rflutter_alert/assets/images/icon_info.png": "3f71f68cae4d420cecbf996f37b0763c",
"assets/packages/rflutter_alert/assets/images/icon_success.png": "8bb472ce3c765f567aa3f28915c1a8f4",
"assets/packages/rflutter_alert/assets/images/icon_warning.png": "ccfc1396d29de3ac730da38a8ab20098",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"index.html": "2ff7867f99a9be66fb54c24e2a0e9e4c",
"/": "2ff7867f99a9be66fb54c24e2a0e9e4c",
"main.dart.js": "155df354ef3e6faef036606deed39b0e",
"manifest.json": "450b98e8dd5a5818f187265cf0396c94",
"version.json": "480395351c1d0dfdf75b89a9d92bb12f"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "/",
"main.dart.js",
"index.html",
"assets/NOTICES",
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
        // lazily populate the cache.
        return response || fetch(event.request).then((response) => {
          cache.put(event.request, response.clone());
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
