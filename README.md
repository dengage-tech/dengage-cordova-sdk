# Dengage Cordova SDK — Comprehensive Integration Guide

This guide analyzes the entire plugin, its native bindings, and the sample `dengage-cordova-example` project so even someone new to Dengage can integrate it step by step.

## 1. Repository anatomy (what you are reading)

| Path | Purpose |
| --- | --- |
| `plugin.xml` | Cordova wiring: maps `www/Dengage.js` to `DengageCR`, declares Android/iOS source files, and adds Firebase/Dengage dependencies plus the Swift helper plugin. |
| `www/Dengage.js` | JavaScript bridge. Every method calls `cordova.exec(success, error, 'DengageCR', action, args)`. The file exposes identity, push, commerce, inbox, in-app, navigation, and configuration helpers. |
| `src/android/` | Native bridge for Android: `DengageCR.java` (Cordova plugin), `DengageCRCoordinator.java` (SDK init + lifecycle watchers), `InAppInlineHostView.java`, `StoriesListHostView.java`. |
| `src/ios/` | Native bridge for iOS: `DengageCR.swift` (Js-to-native proxy), `DengageCRCoordinator.swift`, and overlay views (`DengageInlineOverlayView`, `DengageAppStoryOverlayView`). |
| `www/` (in the plugin) | Exposed JS. |
| `dengage-cordova-example/` | Opinionated working Cordova app showing how to initialize the SDK (`www/js/dengage-init.js`), hook navigation, and exercise every feature. |
| `USAGE_GUIDE.md` | Quick-start snippets that you can copy into your app. |

## 2. Getting ready

- Install Cordova CLI: `npm install -g cordova`
- Have a Firebase project for Android (you need `google-services.json`).
- Have Apple Push Notification credentials plus an APNs key/certificate if you want iOS push.
- (Optional) If you target Huawei devices, get `agconnect-services.json` and the HMS SDK keys.

## 3. Plugin install & verification

```bash
cordova plugin add cordova-plugin-dengage
```

or, to iterate on the SDK locally:

```bash
cordova plugin add /absolute/path/to/dengage-cordova-sdk
```

Verify the plugin is registered:

```bash
cordova plugin list
```

It should report `cordova-plugin-dengage`.

## 4. Default Dengage API endpoints (customize if Dengage Support gave you region-specific URLs)

| Meta-data / Info.plist key | Default value | Description |
| --- | --- | --- |
| `den_event_api_url` | `https://event.dengage.com` | Event ingestion endpoint. |
| `den_push_api_url` | `https://push.dengage.com` | Push notification endpoint. |
| `den_device_id_api_url` | `https://device.dengage.com` | Device identity endpoint used for contact tracking. |
| `den_in_app_api_url` | `https://inapp.dengage.com` (add manually if required) | In-app message rendering endpoint. |
| `den_geofence_api_url` | `https://geofence.dengage.com` (add with geofence module) | Geofence triggers. |
| `fetch_real_time_in_app_api_url` | `https://realtime.dengage.com` (if provided) | Real-time in-app polling. |

If your team already has datacenter URLs from the Dengage dashboard, merge them into `config.xml` (Android `<config-file>` pointing at `AndroidManifest.xml` and iOS `<edit-config>` to the `*-Info.plist`).

### 4.1 Platform-specific endpoint keys

- **Android** wires the endpoint URLs via `<meta-data>` entries named `den_event_api_url`, `den_push_api_url`, `den_device_id_api_url`, etc. These values get merged into the generated `AndroidManifest.xml` and are read by the native Dengage SDK when it initializes.
- **iOS** uses property-list keys such as `DengageEventApiUrl`, `DengagePushApiUrl`, `DengageDeviceIdApiUrl`, `DengageInAppApiUrl`, `DengageGeofenceApiUrl`, and `fetchRealTimeINAPPURL`. Add these with `<edit-config>` entries so Cordova keeps them synced with `Info.plist`.
- Example configuration:

```xml
<platform name="android">
    <config-file parent="./application" target="AndroidManifest.xml">
        <meta-data android:name="den_event_api_url" android:value="https://event.dengage.com"/>
        <meta-data android:name="den_push_api_url" android:value="https://push.dengage.com"/>
        <meta-data android:name="den_device_id_api_url" android:value="https://device.dengage.com"/>
        <meta-data android:name="den_in_app_api_url" android:value="https://inapp.dengage.com"/>
        <meta-data android:name="den_geofence_api_url" android:value="https://geofence.dengage.com"/>
        <meta-data android:name="fetch_real_time_in_app_api_url" android:value="https://realtime.dengage.com"/>
    </config-file>
</platform>
<platform name="ios">
    <edit-config file="*-Info.plist" mode="merge" target="DengageEventApiUrl">
        <string>https://event.dengage.com</string>
    </edit-config>
    <edit-config file="*-Info.plist" mode="merge" target="DengagePushApiUrl">
        <string>https://push.dengage.com</string>
    </edit-config>
    <edit-config file="*-Info.plist" mode="merge" target="DengageDeviceIdApiUrl">
        <string>https://device.dengage.com</string>
    </edit-config>
    <edit-config file="*-Info.plist" mode="merge" target="DengageInAppApiUrl">
        <string>https://inapp.dengage.com</string>
    </edit-config>
    <edit-config file="*-Info.plist" mode="merge" target="DengageGeofenceApiUrl">
        <string>https://geofence.dengage.com</string>
    </edit-config>
    <edit-config file="*-Info.plist" mode="merge" target="fetchRealTimeINAPPURL">
        <string>https://realtime.dengage.com</string>
    </edit-config>
</platform>
```

Cordova merges these entries during `cordova prepare`, so you don’t edit the generated manifest/Info.plist manually.

## 5. Android integration (native + Cordova)

1. **Manifest / Gradle prep**
   - Drop `google-services.json` into `platforms/android/app/`.
   - Apply the Firebase Gradle plugin:
     ```gradle
     // project-level build.gradle
     dependencies { classpath 'com.google.gms:google-services:4.3.15' }
     
     // app-level build.gradle
     apply plugin: 'com.google.gms.google-services'
     ```
   - Add the Firebase service declaration inside `<application>`:
     ```xml
     <service android:name="com.dengage.sdk.push.FcmMessagingService" android:exported="false">
         <intent-filter>
             <action android:name="com.google.firebase.MESSAGING_EVENT" />
         </intent-filter>
     </service>
     ```
   - Add any Dengage meta-data (copy values from the table above) via `config.xml` so Cordova injects them into `AndroidManifest.xml` during build.

2. **Native initialization (MainActivity / Application)**
   - Import and call `DengageCRCoordinator.getInstance().setupDengage(...)` before `loadUrl(launchUrl)` in `MainActivity`:
     ```java
     DeviceConfigurationPreference deviceConfig = DeviceConfigurationPreference.Google;
     DengageCRCoordinator.getInstance().setupDengage(
         "YOUR_FIREBASE_KEY",
         null, // HMS key if you also build for Huawei
         getApplicationContext(),
         null, // optional IDengageHmsManager
         deviceConfig,
         false, // disable open web urls when push clicked
         true,  // log enabled (turn off in production)
         false, // enable geofence
         false  // development status
     );
     ```
   - `DengageCRCoordinator` ensures:
     * `Firebase key` is not null (throws if it is).
     * `DengageLifecycleTracker` is registered via `Application.registerActivityLifecycleCallbacks`.
     * `Dengage.INSTANCE.init(…)` is invoked (falling back to Kotlin-style defaults).
     * Logging and `developmentStatus` are applied.
     * `inAppLinkConfiguration("www.chaitanyamunje.com")` is registered here, but you can override it via JS `setInAppLinkConfiguration`.
     * If `enableGeoFence` is true, it tries to load `com.dengage.geofence.DengageGeofence.startGeofence()` via reflection (include `sdk-geofence` in Gradle for this to succeed).

3. **In-app / stories host views**
   - `DengageCR.java` keeps singletons (`inlineHostView`, `storyHostView`). When JS calls `showInAppInline` or `showAppStory`, it:
     * Reads `propertyId`, `screenName`, optional `customParams`, and `bounds` from the JSON payload.
     * Runs on the UI thread, inflates `InAppInlineHostView` or `StoriesListHostView`, inserts it into the root view (`android.R.id.content`) with elevation to stay on top, and calls `Dengage.INSTANCE.showInlineInApp` or `showStoriesList`.
     * The layout bounds are computed via `buildLayoutParams`, which respects the container `left`, `top`, `width`, `height` (converted from dips).
     * Each host view sets `hasRendered` so the same container is not re-used until `hideInAppInline` / `hideAppStory` removes it from the view hierarchy.

4. **Geofence and permissions**
   - Set `enableGeoFence` to `true` in `setupDengage` when you include `sdk-geofence`. The coordinator tries to load the class; if the JAR is missing, you will see a warning in Logcat.
   - From JavaScript you can call `DengageCR.requestLocationPermissions(success, error)` to prompt Android 13+ runtime notification permission (and location if required).

5. **Huawei (optional)**
   - Add `sdk-hms` and set up `agconnect-services.json` + `com.huawei.agconnect` plugin as described in `USAGE_GUIDE.md`.
   - Pass `DengageHmsManager` (implements `IDengageHmsManager`) and your Huawei integration key into `setupDengage`. The coordinator forwards it to `Dengage.INSTANCE.init`.

## 6. iOS integration (native steps)

1. **CocoaPods**
   - Navigate to `platforms/ios` and run `pod install` so CocoaPods fetches the `Dengage` SDK specified in `plugin.xml` (`pod 'Dengage', '~> 5.85'`).

2. **Capabilities & entitlements**
   - In Xcode, enable **Push Notifications** and under **Background Modes** check **Remote notifications**.

3. **AppDelegate wiring**
   - Import and call `DengageCRCoordinator.staticInstance.setupDengage(...)` from `application(_:didFinishLaunchingWithOptions:)`:
     ```swift
     DengageCRCoordinator.staticInstance.setupDengage(
         key: "YOUR_IOS_INTEGRATION_KEY",
         appGroupsKey: "group.your.app",           // optional
         launchOptions: launchOptions as NSDictionary?,
         application: application,
         askNotificationPermission: true,           // prompt user automatically
         enableGeoFence: false,                     // enable if you include the geofence pod
         disableOpenURL: false,
         badgeCountReset: true,
         logVisible: true
     )
     ```
   - Forward APNs callbacks:
     * `didRegisterForRemoteNotificationsWithDeviceToken`: call `DengageCRCoordinator.staticInstance.registerForPushToken(deviceToken:)`.
     * `userNotificationCenter(_:didReceive:withCompletionHandler:)` and `application(_:didReceiveRemoteNotification:)`: forward to the coordinator to let Dengage handle deep links and analytics.

4. **Swift / view components**
   - `DengageCR.swift` mirrors the JS API and hands off to `DengageCRCoordinator.swift`, which calls the Swift Dengage SDK for in-app, inbox, real-time, etc.
   - Inline overlays are rendered via `DengageInlineOverlayView` and stories use `DengageAppStoryOverlayView`. The plugin automatically adds them when JS requests inline/story content; you only need to pass `propertyId`, `screenName`, and bounds from the web UI.

5. **Swift version support**
   - The plugin depends on `cordova-plugin-add-swift-support` and sets `UseSwiftLanguageVersion` to `5`. No manual bridging headers are necessary.

## 7. JavaScript runtime & API catalog (`www/Dengage.js`)

- Wait for `deviceready` before calling Dengage APIs (see `dengage-cordova-example/www/js/index.js`). Cordova’s bridge relies on native modules being initialized first.
- Always provide both `success` and `error` callbacks; the native calls are asynchronous and nursing the callbacks lets you display logs, update UI, or surface problems.

### 7.1 Identity and device helpers

- `setContactKey(key)` / `getContactKey()` — tie the device to your user identity; call early, especially if you already have a login/token. If you need cross-platform IDs, `setDeviceId(deviceId)` lets you force a specific identifier while `getDeviceId()` lets you read what Dengage has generated.
- `setPartnerDeviceId(adid)` — keep Dengage in sync with any partner tracking ID (for example, an external attribution SDK’s advertising ID).
- Locale enrichers: `setLanguage`, `setCountry`, `setCity`, `setState`, `setDevelopmentStatus` set contextual metadata that Dengage templates and targeting rules can reference.
- `getSdkVersion()` / `getIntegrationKey()` / `getSdkParameters()` allow debugging: print the values to confirm the SDK version, integration key, or the event mapping table returned from the backend.

### 7.2 Push, permissions, and payloads

- `registerNotification()` should be invoked once at startup. It registers the broadcast receiver on Android and re-subscribes iOS devices after every launch.
- `promptForPushNotifications()` and `promptForPushNotificationsWithCallback()` (iOS only) trigger the APNs permission dialog and let you track the user’s decision.
- `setPermission(true/false)` / `getPermission()` allow manual toggles (for example, when the user controls their own notification switch inside your app).
- `getMobilePushToken()` / `setMobilePushToken(token)` let you sync the Firebase token manually (useful if you have your own push infrastructure or migration scenario).
- `getLastPushPayload()` surfaces the payload of the last received notification for custom handling.
- `resetAppBadge()` clears the Android badge when the user opens the app manually.
- `getUserPermission()` reads the current permissions state for display in settings screens.

### 7.3 Commerce and event logging

- `pageView({ screenName })` / `viewCart(...)` / `addToCart(data)` / `removeFromCart(data)` / `beginCheckout(...)` / `placeOrder(data)` / `cancelOrder(data)` / `setCart(cart)` / `getCart()` / `setCartItemCount()` / `setCartAmount()` / `setCategoryPath()` — each writes a pre-defined event table to Dengage so you can trigger campaigns based on real e-commerce activity. Use the helper screens under `www/js/screens/cart.js` as a blueprint for the data shape.
- `search(data)` captures search terms for personalization.
- `sendDeviceEvent(table, data)` / `sendCustomEvent(table, key, params)` let you send arbitrary event names and payloads, giving you flexibility beyond the prebuilt commerce tables.
- `setTags(tagArray)` lets you annotate the device with custom metadata (e.g., loyalty tier). The SDK will merge the tags before every sync automatically.

### 7.4 In-app experiences (navigation, inline, stories, realtime)

- `setNavigation()`, `setNavigationWithName(screenName)`, `setNavigationWithNameAndData(screenName, data)` inform Dengage about the current screen so campaigns can fire for that view. Always call this before showing in-app content.
- `showRealTimeInApp(screenName, params)` asks the Dengage server for the next eligible in-app for the current screen. Combine it with `setCity`, `setState`, `setCartItemCount`, and `setCartAmount` to send richer context; the RTS example screen uses these calls.
- Inline overlays: build a payload `{ propertyId, screenName, customParams?, bounds }` and call `showInAppInline(payload)` to render a native inline widget at the computed DOM bounds. `hideInAppInline()` removes it when you are done.
- App stories: `showAppStory(payload)` and `hideAppStory()` work similarly but use the story host view for side-scrolling creative.
- `setInAppDeviceInfo(key, value)` pushes small key/value pairs to whatever in-app template is currently shown. The inline HTML can read these values via the `dnInAppDeviceInfo` object, allowing templates to personalize content without reloading the app.
- `clearInAppDeviceInfo()` and `getInAppDeviceInfo()` help you manage/reset these values when you leave the screen or reveal a new campaign.

### 7.5 Inbox, deeplinks, and helpers

- `getInboxMessages(offset, limit)` / `deleteInboxMessage(id)` / `deleteAllInboxMessages()` / `setInboxMessageAsClicked(id)` / `setAllInboxMessageAsClicked()` provide a full inbox management surface. The inbox screen in `www/js/screens/inbox-messages.js` demonstrates pagination, removable entries, and clicked state rendering.
- `setInAppLinkConfiguration(url)` overrides the default `inAppLinkConfiguration` provided by `DengageCRCoordinator`. Use it when your app uses universal links or custom URL handling.
- `registerInAppLinkReceiver()` listens for native callbacks triggered by in-app or push deep links and supplies them to JavaScript.
- `getSdkParameters()` returns the `DengageSDKParameter` mapping so you can see which tables and keys are available server-side when building analytics features.
- `getDeviceId()` / `getIntegrationKey()` provide the identifiers you can send to your backend or CRM for cross-referencing.

### 7.6 Location & geofence

- Include the optional geofence dependency (`sdk-geofence`) and pass `enableGeoFence: true` to `setupDengage`. The coordinator uses reflection to call `DengageGeofence.startGeofence()`.
- `requestLocationPermissions()` pops up the run-time permission dialog (needed on Android 13+ when background location is required by geofence campaigns).
- After permissions are granted, Dengage can trigger geofence campaigns purely from the native SDK; no extra JavaScript call is needed beyond enabling the module.

### 7.7 Custom payload handling

- Use `registerNotification` callback to listen for `PUSH_RECEIVE` and `PUSH_OPEN` events on the JavaScript side and inspect the payload for custom data, links, or analytics.
- `getLastPushPayload()` is helpful when you want to show an in-app banner containing the last notification that arrived during the current session.

### 7.8 Function-by-function reference

Each of the functions exposed by `www/Dengage.js` proxies to `cordova.exec`. Call patterns usually look like `DengageCR.method(args, success, error)`. The examples below align with the screens inside `dengage-cordova-example/www/js/screens/` so you can cross-reference them inside the sample app; copy the snippet that matches your use case and adjust the payload for your own data.

#### setContactKey(contactKey, success, error)

Bind the device to your customer ID before sending events. Include a success and error callback to confirm the call completed:

```javascript
DengageCR.setContactKey('user-123', () => console.log('contact key saved'), console.error);
```

#### setLogStatus(logStatus, success, error)

Enable or disable verbose SDK logs on the current device.

```javascript
DengageCR.setLogStatus(true, () => console.log('logging on'), console.error);
```

#### registerNotification(success, error)

Registers push notification listeners (Android receiver + iOS re-subscribe). Use the success callback to receive every `PUSH_RECEIVE`/`PUSH_OPEN` payload.

```javascript
DengageCR.registerNotification(payload => console.log('payload', JSON.stringify(payload, null, 2)), console.error);
```

#### setPermission(permission, success, error)

Manually toggle whether the SDK should treat the device as opted-in.

```javascript
DengageCR.setPermission(true, () => console.log('permission enabled'), console.error);
```

#### setMobilePushToken(token, success, error)

Push a Firebase token computed outside the SDK (migration or custom push service).

```javascript
DengageCR.setMobilePushToken('firebase-token-xyz', () => console.log('token set'), console.error);
```

#### getMobilePushToken(success, error)

Retrieve the token Dengage currently uses for push.

```javascript
DengageCR.getMobilePushToken(token => console.log('token =', token), console.error);
```

#### getContactKey(success, error)

Read back the contact key already stored for this device.

```javascript
DengageCR.getContactKey(key => console.log('current user', key), console.error);
```

#### getPermission(success, error)

Check whether Dengage thinks notifications are enabled.

```javascript
DengageCR.getPermission(permission => console.log('permission:', permission), console.error);
```

#### getSubscription(success, error)

Retrieve raw subscription metadata (integration key, tokens, device IDs, etc.).

```javascript
DengageCR.getSubscription(sub => console.log('subscription', sub), console.error);
```

#### pageView(data, success, error)

Log a page view event to Dengage with arbitrary metadata (screen name, category).

```javascript
DengageCR.pageView({ screenName: 'home' }, console.log, console.error);
```

#### addToCart(data, success, error)

Send a cart-item insertion event. Provide at least `productId`, `quantity`, and `price`.

```javascript
DengageCR.addToCart({ productId: 'sku-1', quantity: 1, price: 450 }, console.log, console.error);
```

#### removeFromCart(data, success, error)

Remove an item or decrement quantity in Dengage’s cart tracking.

```javascript
DengageCR.removeFromCart({ productId: 'sku-1', quantity: 1 }, console.log, console.error);
```

#### viewCart(data, success, error)

Trigger a cart view event so Dengage knows the current cart size/total.

```javascript
DengageCR.viewCart({ items: 2, value: 900 }, console.log, console.error);
```

#### beginCheckout(data, success, error)

Mark the start of a checkout flow; include currency, channel, or other campaign data.

```javascript
DengageCR.beginCheckout({ orderId: 'ord-1', value: 900 }, console.log, console.error);
```

#### placeOrder(data, success, error)

Send complete order data after a successful payment.

```javascript
DengageCR.placeOrder({ orderId: 'ord-1', subtotal: 900, discount: 100 }, console.log, console.error);
```

#### cancelOrder(data, success, error)

Report canceled transactions to keep analytics accurate.

```javascript
DengageCR.cancelOrder({ orderId: 'ord-1', reason: 'user-request' }, console.log, console.error);
```

#### addToWishList(data, success, error)

Track wishlist adds for personalization.

```javascript
DengageCR.addToWishList({ productId: 'sku-1', name: 'Sneaker' }, console.log, console.error);
```

#### removeFromWishList(data, success, error)

Remove an item from the wishlist tracking table.

```javascript
DengageCR.removeFromWishList({ productId: 'sku-1' }, console.log, console.error);
```

#### search(data, success, error)

Log search terms to trigger search-related automations.

```javascript
DengageCR.search({ keyword: 'leather boots' }, console.log, console.error);
```

#### setTags(data, success, error)

Attach tagged metadata (arrays of `{ tagName, tagValue }`) to the device.

```javascript
DengageCR.setTags([{ tagName: 'tier', tagValue: 'gold' }], console.log, console.error);
```

#### sendDeviceEvent(tableName, data, success, error)

Write a custom event to your Dengage-defined table.

```javascript
DengageCR.sendDeviceEvent('purchase_history', { sku: 'sku-1' }, console.log, console.error);
```

#### getInboxMessages(offset, limit, success, error)

Paginate stored inbox messages that Dengage saves when “Save to Inbox” is enabled.

```javascript
DengageCR.getInboxMessages(0, 20, messages => console.log(messages), console.error);
```

#### deleteInboxMessage(id, success, error)

Remove a single inbox entry.

```javascript
DengageCR.deleteInboxMessage('msg-123', () => console.log('deleted'), console.error);
```

#### setInboxMessageAsClicked(id, success, error)

Mark a message as read/clicked.

```javascript
DengageCR.setInboxMessageAsClicked('msg-123', () => console.log('clicked'), console.error);
```

#### promptForPushNotifications(success, error)

Show the native iOS permission dialog (iOS-only).

```javascript
DengageCR.promptForPushNotifications(() => console.log('prompt shown'), console.error);
```

#### promptForPushNotificationsWithCallback(success, error)

Same as above but keeps the callback to inform the app when the user responds.

```javascript
DengageCR.promptForPushNotificationsWithCallback(result => console.log(result), console.error);
```

#### setNavigation(success, error)

Notify the SDK that navigation was handled (default uses current screen).

```javascript
DengageCR.setNavigation(() => console.log('navigation recorded'), console.error);
```

#### setNavigationWithName(screenName, success, error)

Explicitly provide a screen identifier so Dengage can tie campaigns to it.

```javascript
DengageCR.setNavigationWithName('product-detail', () => console.log('screen set'), console.error);
```

#### setNavigationWithNameAndData(screenName, screenData, success, error)

Pass extra context (e.g., product ID) right alongside the screen name.

```javascript
DengageCR.setNavigationWithNameAndData('product-detail', { productId: 'sku-1' }, () => console.log('nav+data'), console.error);
```

#### setCategoryPath(path, success, error)

Tell Dengage which category the user is browsing.

```javascript
DengageCR.setCategoryPath('men/shoes', () => console.log('category set'), console.error);
```

#### setCartItemCount(itemCount, success, error)

Update the cart item counter to help real-time campaigns target busy carts.

```javascript
DengageCR.setCartItemCount(3, () => console.log('cart count 3'), console.error);
```

#### setCartAmount(amount, success, error)

Report total cart value for threshold-based campaigns.

```javascript
DengageCR.setCartAmount(1250, () => console.log('cart amount tracked'), console.error);
```

#### setState(state, success, error)

Flag the user’s current state for location-based personalization.

```javascript
DengageCR.setState('Texas', () => console.log('state set'), console.error);
```

#### setCity(city, success, error)

Flag city-level context.

```javascript
DengageCR.setCity('Austin', () => console.log('city set'), console.error);
```

#### showRealTimeInApp(screenName, data, success, error)

Ask Dengage for an immediate real-time inline. `data` typically mirrors `setCity`, `setState`, `setCategoryPath`, etc.

```javascript
DengageCR.showRealTimeInApp('homepage', { categoryPath: 'men/shoes' }, console.log, console.error);
```

#### showInAppInline(payload, success, error)

Render an inline overlay inside a native container. Provide `propertyId`, `screenName`, optional `customParams`, and `bounds`.

```javascript
DengageCR.showInAppInline({
  propertyId: '1',
  screenName: 'home-inline',
  bounds: { left: 10, top: 100, width: 300, height: 160 }
}, console.log, console.error);
```

#### hideInAppInline(success, error)

Remove the inline overlay so you can show a different campaign later.

```javascript
DengageCR.hideInAppInline(() => console.log('inline hidden'), console.error);
```

#### showAppStory(payload, success, error)

Play an app story overlay; similar payload expectations as inline.

```javascript
DengageCR.showAppStory({
  propertyId: '1',
  screenName: 'story-screen',
  customParams: { theme: 'seasonal' }
}, console.log, console.error);
```

#### hideAppStory(success, error)

Hide the currently visible story.

```javascript
DengageCR.hideAppStory(() => console.log('story hidden'), console.error);
```

#### setPartnerDeviceId(adid, success, error)

Keep Dengage aware of third-party device identifiers.

```javascript
DengageCR.setPartnerDeviceId('partner-abc', () => console.log('partner id saved'), console.error);
```

#### getLastPushPayload(success, error)

Read the raw payload of the last notification the SDK received.

```javascript
DengageCR.getLastPushPayload(payload => console.log(payload), console.error);
```

#### setInAppLinkConfiguration(deeplink, success, error)

Override the default deep-link host used when in-app/inbox messages open URLs.

```javascript
DengageCR.setInAppLinkConfiguration('myapp://handle', console.log, console.error);
```

#### registerInAppLinkReceiver(success, error)

Listen for deep-link callbacks from the native side; the success callback receives the URL string.

```javascript
DengageCR.registerInAppLinkReceiver(url => console.log('deep link', url), console.error);
```

#### sendCustomEvent(eventTable, key, parameters, success, error)

Write to a Dengage custom big data table with structured payload.

```javascript
DengageCR.sendCustomEvent('custom_table', 'click', { label: 'cta' }, console.log, console.error);
```

#### setCart(cart, success, error)

Upload a full cart with `items` array and `summary`.

```javascript
DengageCR.setCart({ items: [], summary: { subtotal: 0 } }, console.log, console.error);
```

#### getCart(success, error)

Retrieve the cart that Dengage currently tracks.

```javascript
DengageCR.getCart(cart => console.log(cart), console.error);
```

#### getSdkParameters(success, error)

Fetch event tables / key mappings that Dengage returns for diagnostics.

```javascript
DengageCR.getSdkParameters(params => console.log(params), console.error);
```

#### setInAppDeviceInfo(key, value, success, error)

Share small key/value metadata for templates.

```javascript
DengageCR.setInAppDeviceInfo('loyaltyLevel', 'gold', console.log, console.error);
```

#### clearInAppDeviceInfo(success, error)

Remove every in-app device info entry.

```javascript
DengageCR.clearInAppDeviceInfo(() => console.log('cleared'), console.error);
```

#### getInAppDeviceInfo(success, error)

Inspect the key/value pairs currently stored on the client.

```javascript
DengageCR.getInAppDeviceInfo(info => console.log(info), console.error);
```

#### deleteAllInboxMessages(success, error)

Wipe every stored inbox message (for debugging or logout scenarios).

```javascript
DengageCR.deleteAllInboxMessages(() => console.log('inbox cleared'), console.error);
```

#### setAllInboxMessageAsClicked(success, error)

Mark every stored message as clicked.

```javascript
DengageCR.setAllInboxMessageAsClicked(() => console.log('all marked read'), console.error);
```

#### getDeviceId(success, error)

Read the device ID Dengage uses internally.

```javascript
DengageCR.getDeviceId(id => console.log('device id', id), console.error);
```

#### setDeviceId(deviceId, success, error)

Force a specific device ID (use with caution).

```javascript
DengageCR.setDeviceId('device-123', () => console.log('device id forced'), console.error);
```

#### setLanguage(language, success, error)

Set the device’s language context for message targeting.

```javascript
DengageCR.setLanguage('en-US', () => console.log('language set'), console.error);
```

#### setDevelopmentStatus(isDebug, success, error)

Mark the SDK as running in development mode so it behaves differently (logs, geofence). Pass `true` / `false`.

```javascript
DengageCR.setDevelopmentStatus(true, () => console.log('dev mode on'), console.error);
```

#### requestLocationPermissions(success, error)

Android 13+ permission prompt helper for geofence campaigns.

```javascript
DengageCR.requestLocationPermissions(() => console.log('location prompt'), console.error);
```

#### getIntegrationKey(success, error)

Retrieve the integration key for debugging or backend sync.

```javascript
DengageCR.getIntegrationKey(key => console.log('integration key', key), console.error);
```

#### getUserPermission(success, error)

Read the latest user permission state (similar to `getPermission` but always returns an explicit boolean).

```javascript
DengageCR.getUserPermission(permission => console.log('user permission', permission), console.error);
```

#### resetAppBadge(success, error)

Clear Android badges when you manually open the app.

```javascript
DengageCR.resetAppBadge(() => console.log('badge reset'), console.error);
```

#### getSdkVersion(success, error)

Check the version of the native Dengage SDK that is running.

```javascript
DengageCR.getSdkVersion(version => console.log('SDK version', version), console.error);
```

### 7.9 Inline overlays & App Story usage

Inline overlays and app stories are native containers that require a payload before being shown. The sample screens (`www/js/screens/in-app-inline.js` and `www/js/screens/app-story.js`) demonstrate the full workflow.

- **Inline overlay steps**
  1. Capture the DOM container bounds with `element.getBoundingClientRect()` and convert to `{ left, top, width, height }`.
  2. Build the inline payload: `{ propertyId, screenName, customParams?, bounds }`.
  3. Call `DengageCR.showInAppInline(payload, success, error)`; the native host view uses the bounds (converted to density-independent pixels on Android) so the overlay matches the target region.
  4. When you no longer need the inline experience, run `DengageCR.hideInAppInline(() => console.log('inline hidden'), console.error)` to remove it.

- **App Story steps**
  1. Prepare `{ propertyId, screenName, customParams? }` without bounds because the story floats above the UI.
  2. Call `DengageCR.showAppStory(payload, success, error)` to present the story overlay.
  3. Dismiss with `DengageCR.hideAppStory(() => console.log('story hidden'), console.error)` when the story should exit.

The inline and story helpers both log successes/errors to help you debug placement; adjust the payload values to match the campaigns you created in your Dengage dashboard. Use the `customParams` field for personalization data, and remember to call `setNavigationWithName` before invoking an inline or story so the SDK knows which screen is active.

## 8. In-app stories & inline overlays

- `showInAppInline`/`showAppStory` inject native overlays via `InAppInlineHostView` and `StoriesListHostView`.
- The payload MUST include `propertyId` and `screenName`; `customParams` and `bounds` are optional but recommended.
- The example screens show how to gather `bounds` using `element.getBoundingClientRect()` and pass stringified JSON to the plugin.
- `hideInAppInline` / `hideAppStory` removes the host view so you can refresh the experience.

## 9. App Inbox

If messages are sent with “Save to Inbox” in the Dengage dashboard, they are captured locally and accessible via:

- `getInboxMessages(offset, limit, ...)`
- `deleteInboxMessage(id, ...)`
- `deleteAllInboxMessages(...)`
- `setInboxMessageAsClicked(id, ...)`
- `setAllInboxMessageAsClicked(...)`

The example `screens/inbox-messages.js` shows how to populate a list, delete entries, and mark items as read.

## 10. Push messaging & permissions

- Android registers the `FcmMessagingService`, iOS uses the AppDelegate helper.
- Always call `registerNotification` on startup (it re-subscribes the device on iOS).
- Use `promptForPushNotifications` / `promptForPushNotificationsWithCallback` to request user permission on iOS; `setPermission` / `getPermission` are there if you manage permission toggles yourself.
- `getMobilePushToken` / `setMobilePushToken` let you sync tokens with Dengage manually.
- For Android 13+ you can `requestLocationPermissions` (the plugin uses `Dengage.INSTANCE.requestLocationPermission`).
- `resetAppBadge` clears the badge count on Android. iOS badge reset is handled via `badgeCountReset` parameter during `setupDengage`.

## 11. Geofence & location triggers

- Include `sdk-geofence` (via Gradle or CocoaPods) and set the `enableGeoFence` flag to true while initializing.
- The coordinator automatically tries to load `com.dengage.geofence.DengageGeofence.startGeofence()`.
- Use `DengageCR.requestLocationPermissions` to satisfy the runtime permission request if your app triggers location-based campaigns.

## 12. deeplinks & URLs

- By default the Android coordinator calls `Dengage.INSTANCE.inAppLinkConfiguration("www.chaitanyamunje.com")`. Override it from JS with:
  ```javascript
  DengageCR.setInAppLinkConfiguration('https://your.app.link');
  ```
- Call `registerInAppLinkReceiver()` to let the plugin listen for native deep link callbacks. When a push/in-app message opens a URL, the payload is forwarded to JS so you can navigate inside the WebView.
- `setNavigationWithNameAndData(screenName, data, ...)` is helpful when your nav system needs extra context (the example uses it to tell Dengage which product the user is viewing).

## 13. Example app breakdown (`dengage-cordova-example`)

| Feature | Files & notes |
| --- | --- |
| App bootstrap | `www/js/index.js` → waits for `deviceready`, initializes navigation and calls `initializeDengage()` (see `www/js/dengage-init.js`). |
| Contact management | `www/js/screens/contact-key.js`: reads/saves contact key, toggles notification permission. |
| Device info | `www/js/screens/device-info.js`: attempts `getSubscription`, falls back to `getContactKey`, `getMobilePushToken`, `getDeviceId`, `getIntegrationKey`, `getSdkVersion` so you can inspect what the SDK thinks about the device. |
| Event history | `www/js/screens/event-history.js`: reads `getSdkParameters()` (event mappings) and lets you send any custom event table via `sendDeviceEvent`. |
| Cart | `www/js/screens/cart.js`: demonstrates `getCart`, editing cart items, and submitting `setCart(...)` with summary data. |
| Geofence | `www/js/screens/geofence.js`: calls `requestLocationPermissions`. |
| In-app messaging | `www/js/screens/in-app-message.js`: manipulates `setInAppDeviceInfo`, `setNavigationWithName`, and `setNavigation`; also clears device info via `clearInAppDeviceInfo`. |
| Real-time in-app | `www/js/screens/rt-in-app-message.js`: sets cart state (`setCartItemCount/Amount`), `setCategoryPath`, `setCity`, `setState`, then calls `showRealTimeInApp`. |
| Inline messages | `www/js/screens/in-app-inline.js`: builds a payload with `propertyId`, `screenName`, `customParams`, and `bounds`, then calls `showInAppInline` / `hideInAppInline`. Boundaries are derived from the DOM container’s `getBoundingClientRect()`. |
| App stories | `www/js/screens/app-story.js`: similar to inline but calls `showAppStory` / `hideAppStory`. Adjusts container color to illustrate layout changes. |
| Inbox | `www/js/screens/inbox-messages.js`: fetches inbox messages, shows metadata (`isClicked`, `receiveDate`), deletes messages, and marks them as clicked. |
| Navigation | `www/js/navigation.js`: simple screen swapping logic that keeps the UI in sync with the SDK. |

### Running the sample project

1. Install dependencies inside the example: `cd ../dengage-cordova-example && npm install`.
2. Add platforms if needed: `cordova platform add android` / `cordova platform add ios`.
3. Build & run: `cordova run android` or `cordova run ios`. The example already includes `config.xml`, `platforms/`, and plugin wiring so you can even open it directly in Android Studio/Xcode.

## 14. Testing & troubleshooting

- Enable verbose logging on dev devices: `DengageCR.setLogStatus(true, console.log, console.error)` from JS. Disable before release.
- If push is not arriving:
  * Android: confirm `google-services.json` is in `platforms/android/app/` and the Firebase Server Key is configured in the Dengage dashboard.
  * iOS: check APNs certificates, that push capabilities are enabled, and that `didRegisterForRemoteNotificationsWithDeviceToken` forwards to the coordinator.
- Ensure contact keys are set before relying on event personalization. Use the example `screens/contact-key.js` to verify.
- Use `DengageCR.getSdkParameters` (see `screens/event-history.js`) to inspect the data returned from Dengage and match it against your dashboard’s event mappings.
- If in-app messages fail to appear, send the screen name via `setNavigationWithName` and verify that the same screen name is listed in your Dengage campaign targeting rules.
- Track inline/story behavior by inspecting the DOM container’s bounds (the example uses `getBoundingClientRect`). If the overlay appears off-screen, adjust the `bounds` before calling `showInAppInline` / `showAppStory`.
- When troubleshooting inbox, `getInboxMessages` returns message metadata (`receiveDate`, `title`, `message`, `isClicked`). Use `deleteInboxMessage` / `setInboxMessageAsClicked` to keep the list manageable.

## 15. Resources & links

- Sample app repository: [https://github.com/dengage-tech/dengage-cordova-sdk-sample](https://github.com/dengage-tech/dengage-cordova-sdk-sample)
</EOF