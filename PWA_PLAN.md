# PWA Plan for Seasoning

## Current state

- Viewport meta tag: present
- `apple-touch-icon.png` and `apple-touch-icon-precomposed.png`: present in `public/` but both files are empty (0 bytes)
- `favicon.ico`: present
- Logo: SVG at `app/assets/images/logo_with_name.svg`
- Web app manifest: missing
- Service worker: missing
- Theme color meta tag: missing
- PWA-specific meta tags: missing
- Manifest link tag: missing
- Turbo Rails: present (gives SPA-like navigation feel)
- HTTPS on Heroku: present
- Responsive Tailwind layout: present

The app is not installable as a PWA and has no offline capability.

---

## Low hanging fruit

These are small, high-impact changes that can be done quickly.

### 1. Generate real app icons

The existing apple-touch-icon files are empty. The app has an SVG logo at
`app/assets/images/logo_with_name.svg`. Generate real PNG icons from it:

- `public/icon-192.png` — 192x192, used by Android Chrome
- `public/icon-512.png` — 512x512, used by Android Chrome (also for splash)
- `public/icon-maskable-192.png` — 192x192 with safe zone padding, for maskable
- `public/apple-touch-icon.png` — 180x180, for iOS home screen

Tools: ImageMagick (`convert`), Inkscape CLI, or any SVG-to-PNG converter.

Note: the logo SVG includes the text "Seasoning". You may want a standalone icon
(just the symbol/mark) for small sizes. If there is no standalone mark yet, now
is the time to create one.

### 2. Add a web app manifest

Rails 8 has a built-in pattern for this. Create:

- `app/views/pwa/manifest.json.erb` — the manifest template
- `app/controllers/pwa_controller.rb` — serves manifest and service worker
- Routes: `get "/manifest.json", to: "pwa#manifest"` and `get "/service-worker.js", to: "pwa#service_worker"`

The manifest should include:

```json
{
  "name": "Seasoning",
  "short_name": "Seasoning",
  "description": "Track your TV show viewing progress",
  "start_url": "/",
  "display": "standalone",
  "orientation": "portrait",
  "theme_color": "#ea580c",
  "background_color": "#f6f6f7",
  "icons": [
    { "src": "/icon-192.png", "sizes": "192x192", "type": "image/png" },
    { "src": "/icon-512.png", "sizes": "512x512", "type": "image/png" },
    {
      "src": "/icon-maskable-192.png",
      "sizes": "192x192",
      "type": "image/png",
      "purpose": "maskable"
    }
  ]
}
```

The theme color `#ea580c` matches Tailwind's `orange-600` which is the brand color.
The background color matches the `rgb(246, 246, 247)` body background.

### 3. Add meta tags and manifest link to the layout

In `app/views/layouts/application.html.erb`, add to `<head>`:

```erb
<link rel="manifest" href="/manifest.json">
<meta name="theme-color" content="#ea580c">
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-status-bar-style" content="default">
<meta name="apple-mobile-web-app-title" content="Seasoning">
<link rel="apple-touch-icon" href="/apple-touch-icon.png">
```

### 4. Add a minimal service worker

A service worker is required for the install prompt to appear on most browsers.
Even a do-nothing service worker satisfies the requirement. Create:

`app/views/pwa/service-worker.js.erb`:

```js
// Minimal service worker — enables PWA installability
self.addEventListener("install", () => self.skipWaiting());
self.addEventListener("activate", (event) => {
  event.waitUntil(clients.claim());
});
```

Register it in `app/javascript/application.js`:

```js
if ("serviceWorker" in navigator) {
  navigator.serviceWorker.register("/service-worker.js");
}
```

Note: the service worker must be served at `/service-worker.js` (not a fingerprinted
asset path) because its scope is determined by its URL path.

### 5. Handle standalone display in the nav

When the app is running in standalone mode (installed on home screen), iOS hides
the URL bar but doesn't add safe area padding. The sticky nav may overlap the
notch/status bar area. Fix by adding to the layout:

```html
<meta
  name="viewport"
  content="width=device-width,initial-scale=1,viewport-fit=cover"
/>
```

And in CSS:

```css
/* Pad the sticky nav for notch/dynamic island when installed as PWA */
@media (display-mode: standalone) {
  .sticky.top-0 {
    padding-top: env(safe-area-inset-top);
  }
}
```

---

## Medium-term improvements

These take more work but meaningfully improve the mobile experience.

### 6. Bottom navigation bar for mobile

The current nav is at the top and includes links that are hard to reach with one
hand on a phone. For a mobile-native feel, consider a bottom tab bar when in
standalone mode or on small screens. Candidate tabs:

- Your shows (home/main screen)
- Search
- Your profile
- Notifications (returning/debuting show alerts)

This is a significant UI change. Implement carefully to not break the desktop layout.
The `@media (display-mode: standalone)` and `@media (max-width: ...)` CSS queries
can help target only the relevant contexts.

### 7. Improve offline experience

Right now, if the user has no network, they see a browser error page. Better:

**App shell caching:** Cache the HTML layout, CSS, JS, and images so the app shell
loads instantly even offline. Use a cache-first strategy for static assets.

**Graceful offline page:** Serve a friendly "You're offline" page from the service
worker cache when the network is unavailable.

**Show list caching:** Cache the user's shows list so it's readable offline.
Episode marking would need to queue and sync when back online (see background sync
below).

Implementation: expand the service worker to use the Cache API with a workbox-style
strategy, or add Workbox directly via npm.

### 8. Touch target audit

Go through the UI and ensure all interactive elements meet the 44x44px minimum
touch target size recommended by Apple (48x48dp by Google). Common offenders:

- The "×" dismiss buttons on notifications (currently just a character with no padding)
- Episode watch/unwatch toggles
- The search bar icon
- Footer links

### 9. Add to home screen prompt

Browsers show their own install UI, but you can also add an in-app "Install app"
button or banner. Intercept the `beforeinstallprompt` event and show a contextual
prompt (e.g., in settings, or as a one-time banner for logged-in users).

---

## Longer-term / advanced

These are more involved features that build on the PWA foundation.

### 10. Push notifications

The app already has server-side notification infrastructure
(`ReturningShowNotification`, `DebutingShowNotification`). Push notifications
would let users know when a show is back without opening the app.

This requires:

- Web Push API on the frontend (subscribe user, send subscription to server)
- A push notification sending library on the backend (e.g., `webpush` gem)
- A new database column on Human to store push subscriptions
- Opt-in UI in Settings
- Service worker `push` event handler to display notifications

### 11. Background sync for episode watches

Let users mark episodes as watched even when offline. The watch action queues in
IndexedDB, and the service worker's `sync` event replays it when back online.

This requires the Background Sync API, which has decent but not universal browser
support. Feature-detect it and fall back to a simple error message if unavailable.

### 12. Web Share API integration

On show and season pages, add a native share button that uses the Web Share API
(`navigator.share()`). This lets users share shows via their native share sheet
(Messages, Notes, etc.) on iOS/Android. Feature-detect and only show the button
when the API is available.

### 13. Splash screens for iOS

When an installed PWA launches on iOS, it shows a white flash before rendering.
You can suppress this by adding `<link rel="apple-touch-startup-image">` tags for
each device screen size. This is tedious to maintain manually but tools like
`pwa-asset-generator` can automate it from a single source image.

---

## Recommended order of work

1. Generate real icons (prerequisite for everything else)
2. Add manifest + meta tags + service worker (items 2, 3, 4 together — makes app installable)
3. Fix viewport/safe area for standalone mode (item 5 — quick CSS fix)
4. Touch target audit (item 8 — UX polish)
5. Offline experience / service worker caching (item 7)
6. Add to home screen prompt (item 9)
7. Bottom nav for mobile (item 6 — bigger UI change)
8. Push notifications (item 10 — most backend work)
9. Background sync (item 11)
10. Web Share API (item 12 — small, nice-to-have)
11. iOS splash screens (item 13 — polish)
