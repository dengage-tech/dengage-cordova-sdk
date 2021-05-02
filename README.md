# cordova-plugin-dengage

**D·engage Customer Driven Marketing Platform (CDMP)** serves as a customer data platform (CDP) with built-in
omnichannel marketing features. It replaces your marketing automation and cross-channel campaign management. For further
details about D·engage please [visit here](https://dev.dengage.com).

This package makes it easy to integrate, D·engage, with your React-Native iOS and/or Android apps. Following are
instructions for installation of react-native-dengage SDK to your react-native applications.

## Installation

```sh
cordova plugin add cordova-plugin-dengage
```

## Platform Specific Extra Steps

Following extra steps after the installation of the react-native-dengage SDK are required for it to work properly.

<details>
  <summary> iOS Specific Extra steps </summary>

### End Point Configuration

For initial setup, if you have given URL addresses by Dengage Support team, you need to setup url address by using Plist
file. Otherwise you don’t need to add anything to Plist file. For that you can add following code
in `YourProject/config.xml`. It will add endpoints to your `info.plist` file.

```xml
<platform name="ios">
    <edit-config file="*-Info.plist" mode="merge" target="DengageApiUrl">
        <string>https://push.dengage.com</string>
    </edit-config>
    <edit-config file="*-Info.plist" mode="merge" target="DengageEventApiUrl">
        <string>https://event.dengage.com</string>
    </edit-config>
</platform>
```

</details>

<details>
  <summary> android Specific Extra Steps </summary>

### Firebase SDK Setup (Follow these steps only if you're using firebase for push, for Huawei [follow these steps](#huawei-sdk-setup))<a name="firebase-sdk-setup" />

#### Requirements

- Google Firebase App Configuration
- Android Studio
- Android Device or Emulator

D·engage Android SDK provides an interface which handles push notification messages easily. Optionally, It also gives to
send event functionality such as open and subscription to Dengage Platform.

Supports Android API level 4.1.x or higher.

For detailed steps for firebase SDK setup and it's integeration with
D·engage, [click here](https://dev.dengage.com/mobile-sdk/android/firebase)

### Huawei SDK Setup (Note: use these steps only if you're using HUAWEI Messaging Service for push, if using firebase, [follow these steps](#firebase-sdk-setup))<a name="huawei-sdk-setup" />

#### Requirements

- Huawei Developer Account
- Java JDK installation package
- Android SDK package
- Android Studio 3.X
- HMS Core (APK) 4.X or later
- Huawei Device or Huawei Cloud Debugging

Supports Android API level 4.4 or higher. (Note that Huawei AdID service requires min target SDK version 19)

**D·engage Huawei SDK** provides an interface which handles push notification messages that delivered
by `Huawei Messaging Service (HMS)`. It is similar to Firebase but has a bit different configuration process that
contains [steps mentioned here.](https://dev.dengage.com/mobile-sdk/android/huawei)

### Change Subscription Api Endpoint

You can change subscription api endpoint by adding following metadata tag in `YourProject/config.xml`. It will then
automatically update your `andoridManifest.xml` file with subscription api endpoint.

  ```xml
  <meta-data
    android:name="den_event_api_url"
    android:value="https://your_event_api_endpoint" />
  ```

Note: Please see API Endpoints By Datacenter to set your subscription end point.

### Changing Event Api Endpoint

similar to subscription endpoints, you can change event api endpoints by setting following metadata tag
in `YourProject/config.xml`

  ```xml
  <meta-data
    android:name="den_push_api_url"
    android:value="https://your_push_api_endpoint" />
  ```

Note: Please see API Endpoints By Datacenter to set your event end point.

Following is the sample code as an example for `Subscription/Event Api Endpoint`

```xml
<config-file parent="./application" target="AndroidManifest.xml">
    <meta-data
            android:name="den_event_api_url"
            android:value="https://event.dengage.com"/>
    <meta-data
            android:name="den_push_api_url"
            android:value="https://push.dengage.com"/>
</config-file>
```

</details>

## Supported Versions

<details>
  <summary> iOS </summary>

D·engage Mobile SDK for IOS supports version IOS 10 and later.
</details>

<details>
  <summary> android </summary>

D·engage Mobile SDK for Android supports version 4.4 (API Level 19) and later.

  <summary> Huawei </summary>

D·engage Mobile SDK for Huawei supports all new versions.
</details>

## Usage

### Init Setup Dengage

- Using Callback Approach

`Android Example:`

```Javascript
Dengage.setupDengage(logStatus, firebaseKey, huaweiKey, successCallbackFunc, errorCallbackFunc)
```

`ios Example:`

```Javascript
Dengage.setupDengage(logStatus, integerationKey, lanuchOptions, successCallbackFunc, errorCallbackFunc)
```

- Using Promise Approach

Regarding promise implementation, first need to define a `Promisify` function that take `Dengage Function`
and `Dengage Function Parameters` as an argument, It will return a promise that has two possible states, one is resolved
and other is rejected. Following is an example of `Promisify` function.

```Javascript
const promisify = (f) => (...a) => new Promise((res, rej) => f(...(a || {}), res, rej))
```

and call dengage function as follows:

```Javascript
promisify(Dengage.setupDengage)(true, null, null)
    .then(() => 'Successfully Setup Dengage Code Here')
    .catch((err) => 'Error Handling Here')
```

> Note: Android and Ios accept same number of parameters in `setupDenage` function but they have different value for that like `android accept` <b>logstatus</b>, <b>logstatus</b> && <b>firebaseKey</b>, <b>huaweiKey</b>, <b>successCallback</b>, <b>errorCallback</b> and `ios accept` <b>logstatus</b>, <b>integerationKey</b>, <b>launchOptions</b>, <b>successCallback</b>, <b>errorCallback</b>

### Subscription

****Subscription is a process which is triggered by sending subscription event to D·engage. It contains necessary
informations about application to send push notifications to clients.****

Subscriptions are self managed by D·engage SDK and subcription cycle starts with Prompting user permission. SDK will
automaticlly send subscription events under following circumstances:

- Initialization
- Setting Contact key
- Setting Token
- Setting User Permission (if you have manual management of permission)

### Asking User Permission for Notification

> Note: Android doesn't require to ask for push notifications explicitly. Therefore, you can only ask for push notification's permissions on iOS.

IOS uses shared `UNUserNotificationCenter` by itself while asking user to send notification. D·engage SDK manager
uses `UNUserNotificationCenter` to ask permission as
well. [Apple Doc Reference](https://developer.apple.com/documentation/usernotifications/asking_permission_to_use_notifications)

If in your application, you want to get UserNotification permissions explicitly, you can do by calling one of the
following methods:

- Using Callback Approach

```Javascript
Dengage.promptForPushNotifications(successCallback, errorCallback)
```

- Using Promise Approach

```Javascript
promisify(Dengage.promptForPushNotifications)()
    .then(() => 'Successfully promptForPushNotifications Code Here')
    .catch((err) => 'Error Handling Here')
```

You can use following method to `promptForPushNotification` and get the value in `callback` or in `then` function of
promise.

```Javascript
Dengage.promptForPushNotificationsWitCallback(function (hasPermission: Boolean) {
    // do somthing with hasPermission flag.
    // Note: hasPermission provides information if user enabled or disabled notification permission from iOS Settings > Notifications.
}, function (error) {
})
```

```Javascript
promisify(Dengage.promptForPushNotificationsWitCallback)()
    .then(hasPermission => 'hasPermission value is updated')
    .catch(err => 'Error Handling Here')
```

### Setting Contact Key

***Contact Key represents user id in your system. There are two types of devices. Anonymous Devices and Contact Devices.
Contact Devices contains Contact Key.***

To track devices by their contacts you need to set contact key on SDK.

> Note: It is recommended to call this method, if you have user information. You should call in every app open and on login, logout pages.

- Using Callback Approach

```Javascript 
Dengage.setContactKey(contactKey, successCallbackFunc, errorCallbackFunc)
```

- Using Promise Approach

```Javascript
promisify(Dengage.setContactKey)(contactKey)
    .then(() => 'Successfully Setting Contact Key Code Here')
    .catch((err) => 'Error Handling Here')
```

**Note: Promisify function is defined above in `Initial Setup Dengage`**

### Getting Contact Key

This method is to get the current user information from SDK getContactKey method can be used.

- Using Callback Approach

```Javascript 
Dengage.getContactKey(successCallbackFunc, errorCallbackFunc)
```

- Using Promise Approach

```Javascript
promisify(Dengage.getContactKey)()
    .then(() => 'Successfully Getting Contact Key Code Here')
    .catch((err) => 'Error Handling Here')
```

### Manual Management of Tokens

If you need to get current token or if you are managing token subscription process manually, you can use setToken and
getToken functions.

#### Get Push Token

- Using Callback Approach

```Javascript 
Dengage.getMobilePushToken(successCallbackFunc, errorCallbackFunc)
```

- Using Promise Approach

```Javascript
promisify(Dengage.getMobilePushToken)()
    .then(() => 'Successfully Getting Token Code Here')
    .catch((err) => 'Error Handling Here')
```

#### Set Push Token

- Using Callback Approach

```Javascript 
Dengage.setMobilePushToken(successCallbackFunc, errorCallbackFunc)
```

- Using Promise Approach

```Javascript
promisify(Dengage.setMobilePushToken)(token)
    .then(() => 'Successfully Setting Token Code Here')
    .catch((err) => 'Error Handling Here')
```

### Logging

SDK can provide logs for debuging. It displays queries and payloads which are sent to REST API’s.

To validate your inputs you can enable SDK’s log by a method

- Using Callback Approach

```Javascript 
Dengage.setLogStatus(logStatus, successCallbackFunc, errorCallbackFunc)
```

- Using Promise Approach

```Javascript
promisify(Dengage.setLogStatus)(logStatus)
    .then(() => 'Successfully Setting Log Status Code Here')
    .catch((err) => 'Error Handling Here')
```

### User Permission Management (optional)

If you manage your own user permission states on your application you may send user permission by using
`setPermission` method.

#### Set User Permission

- Using Callback Approach

```Javascript 
Dengage.setPermission(permission, successCallbackFunc, errorCallbackFunc)
```

- Using Promise Approach

```Javascript
promisify(Dengage.setPermission)(permission)
    .then(() => 'Successfully Setting Permission Code Here')
    .catch((err) => 'Error Handling Here')
```

#### Get User Permission (Android)

- Using Callback Approach

```Javascript 
Dengage.getPermission(successCallbackFunc, errorCallbackFunc)
```

- Using Promise Approach

```Javascript
promisify(Dengage.getPermission)
    .then(() => 'Successfully Getting Permission Code Here')
    .catch((err) => 'Error Handling Here')
```

### Handling Notification Action Callback

SDK provides a method if you want to get and parse payload manually for custom parameters or etc.

- Using Callback Approach

```javascript
    Dengage.handleNotificationActionBlock(successCallbackFunc, errorCallbackFunc)
```

- Using Promise Approach

```javascript
promisify(Dengage.handleNotificationActionBlock)
    .then((notificationResponse) => 'Successfully notificatoin response Code Here')
    .catch((err) => 'Error Handling Here')

```

### DeepLinking

SDK supports URL schema deeplink. If target url has a valid link, it will redirect to the related link. Please see
related links below about deeplinking.

<details>
  <summary> iOS Specific Links</summary>

[Apple Url Scheme Links](https://developer.apple.com/documentation/xcode/allowing_apps_and_websites_to_link_to_your_content/defining_a_custom_url_scheme_for_your_app)

[Apple Universal Link](https://developer.apple.com/documentation/xcode/allowing_apps_and_websites_to_link_to_your_content)

</details>


<details>
  <summary> Android Specific Links </summary>


[Create a deep link for a destination](https://developer.android.com/guide/navigation/navigation-deep-link)

[Create Deep Links to App Content](https://developer.android.com/training/app-links/deep-linking)
</details>

### Rich Notifications <a name="rich_push" />

Rich Notifications is a notification type which supports image, gif, video content. D·engage SDK supports varieties of
contents and handles notification. Rich Notifications supports following media types:

- Image
- Video
- Gif

For further details about rich notification and its setup on iOS side please
follow [this link](https://dev.dengage.com/mobile-sdk/ios/richnotification)

> Note: on Android there is no special setup required for rich notifications.

### Carousel Push <a name="carousel_push" />

Carousel Push is a notification type which has a different UI than Rich Notification. SDK will handle notification
payload and displays UI if it’s a carousel push. Carousel Push functionality allows you to show your notification with a
slideshow.

<details>
  <summary> iOS </summary>

### Requirements

- iOS 10 or higher
- Notification Service Extension
- Notification Content Extension
- Dengage.Framework.Extensions

to setup Carousel Push on iOS you can follow [this link](https://dev.dengage.com/mobile-sdk/ios/carousel-push)
</details>

<details>
  <summary> android </summary>

### Requirements

- Android SDK 2.0.0+

to setup Carousel Push on android you can follow [this link](https://dev.dengage.com/mobile-sdk/android/carousel-push)
</details>

### Action Buttons <a name="action_buttons" />

Android SDK allows you to put clickable buttons under the notification. Action buttons are supported in Android SDK
2.0.0+. For further setup of Action Buttons,
follow [this link](https://dev.dengage.com/mobile-sdk/android/action-buttons).

### Event Collection <a name="event_collection" />

In order to collect android mobile events and use that data to create behavioral segments in D·engage you have to
determine the type of events and data that needs to collected. Once you have determined that, you will need to create a
“Big Data” table in D·engage. Collected events will be stored in this table. Multiple tables can be defined depending on
your specific need.

Any type of event can be collected. The content and the structure of the events are completely flexible and can be
changed according to unique business requirements. You will just need to define a table for events.

Once defined, all you have to do is to send the event data to these tables. D·engage SDK has only two functions for
sending events: `sendDeviceEvent` and `sendCustomEvent`. Most of the time you will just need the `sendDeviceEvent`
function.

### 1. Login / Logout Action

If the user loggs in or you have user information, this means you have contact_key for that user. You can set
contact_key in order to match user with the browser. There are two functions for getting and setting contact_key.

### 1.a setContactKey

If user logged in set user id. This is important for identifying your users. You can put this function call in every
page. It will not send unnecessary events.
[code example is here](#setting-contact-key)

### 1.b getContactKey

to get the current user information from SDK getContactKey method can be used.

```Javascript
// in the code, where user information required
promisify(Dengage.getContactKey)()
    .then(contactKey => 'ContactKey info here')
```

### 2. Event Collection

If your D·engage account is an ecommerce account, you should use standard ecommerce events in the SDK. If you need some
custom events or your account is not standard ecommerce account, you should use custom event functions.

### 2.1 Events for Ecommerce Accounts

There are standard ecommerce events in D·engage SDK.

- [**Page View Events**](#page-view-events-details)
    - Home page view
    - Product page view
    - Category page view
    - Promotion page view

- [**Shopping Cart Events**](#shopping-cart-events)
    - Add to cart
    - Remove from cart
    - View Cart
    - Begin Checkout

- [**Order Events**](#order-events)
    - Order
    - Cancel order

- [**Wishlist Events**](#wishlist-events)
    - Add to wishlist
    - Remove from wishlist

- [**Search Event**](#search-event)

For these event there are related tables in your account. Following are the details and sample codes for each of above
events.

**Page View Events** <a name="page-view-events-details" />
Page view events will be sent to `page_view_events` table. If you add new columns to this table. You can send these in
the event data.

```Javascript
// Home page view
Dengage.pageView({
    "page_type": "home"
    // ... extra columns in page_view_events table, can be added here
})

// Category page view
Dengage.pageView({
    "page_type": "category",
    "category_id": "1"
    // ... extra columns in page_view_events table, can be added here
})

// Product page view
Dengage.pageView({
    "page_type": "product",
    "product_id": "1"
    // ... extra columns in page_view_events table, can be added here
})

//promotion page view
Dengage.pageView({
    "page_type": "promotion",
    "promotion_id": "1"
    // ... extra columns in page_view_events table, can be added here
})

//custom page view
Dengage.pageView({
    "page_type": "custom"
    // ... extra columns in page_view_events table, can be added here
})

// For other pages you can send anything as page_type
```

### Shopping Cart Events <a name="shopping-cart-events" />

These events will be stored in `shopping_cart_events` and `shopping_cart_events_detail`. There are 4 shopping cart event
functions. `addToCart`, `removeFromCart`, `viewCart`, `beginCheckout` Every shopping cart event function needs all items
in cart as an array. You must send last version of the shopping cart.

For example: If there is one item in cart and item id is 5. And after that, an add to cart action is happened with the
item id 10. You have to send 10 as `product_id` in event parameters and you must send current version of cart items.
Meaning [5, 10]

```Javascript
// All items currently exists in shopping cart must be added to an array
const cartItem = {} // cartItem will be an object with key:value types as String:Any

cartItem["product_id"] = 1
cartItem["product_variant_id"] = 1
cartItem["quantity"] = 1
cartItem["unit_price"] = 10.00
cartItem["discounted_price"] = 9.99
// ... extra columns in shopping_cart_events_detail table, can be added in cartItem

let cartItems = []
cartItems.push(cartItem)
cartItems.push(cartItem2)


// Add to cart action
const addParams = {
    "product_id": 1,
    "product_variant_id": 1,
    "quantity": 1,
    "unit_price": 10.00,
    "discounted_price": 9.99,
    // ... extra columns in shopping_cart_events table, can be added here
    "cartItems": cartItems // all items in cart
}
Dengage.addToCart(addParams)

// ....
// Remove from cart action
const removeParams = {
    "product_id": 1,
    "product_variant_id": 1,
    "quantity": 1,
    "unit_price": 10.00,
    "discounted_price": 9.99,
    // ... extra columns in shopping_cart_events table, can be added here
    "cartItems": cartItems // all items in cart
}
Dengage.removeFromCart(removeParams)

// view cart action
const viewParams = {
    // ... extra columns in shopping_cart_events table, can be added here
    "cartItems": cartItems
}
Dengage.viewCart(viewParams)

// begin checkout action
var checkoutParams = {
    // ... extra columns in shopping_cart_events table, can be added here
    "cartItems": cartItems
}
Dengage.beginCheckout(checkoutParams)
```

### Order Events <a name="order-events" />

Orders events will be sent to order_events and order_events_detail tables.

```Javascript
// Ordered items or canceled items must be added to an array
const cartItem = {}

cartItem["product_id"] = 1
cartItem["product_variant_id"] = 1
cartItem["quantity"] = 1
cartItem["unit_price"] = 10.00
cartItem["discounted_price"] = 9.99
// ... extra columns in order_events_detail table, can be added in cartItem

const cartItems = []
cartItems.push(cartItem)
cartItems.push(cartItem2)
// ... ordered or canceled items must be added


// Place order action
const placeOrderParams = {
    "order_id": 1,
    "item_count": 1, // total ordered item count
    "total_amount": 1, // total price
    "discounted_price": 9.99, // use total price if there is no discount
    "payment_method": "card",
    "shipping": 5,
    "coupon_code": "",
    // ... extra columns in order_events table, can be added here
    "cartItems": cartItems //ordered items
}
Dengage.placeOrder(placeOrderParams)

// Cancel order action
const cancelParams = {
    "order_id": 1, // canceled order id
    "item_count": 1, // canceled total item count
    "total_amount": 1, // canceled item's total price
    "discounted_price": 9.99, // use total price if there is no discount
    // ... extra columns in order_events table, can be added here
    "cartItems": cartItems // // canceled items 
}
Dengage.cancelOrder(cancelParams)
```

### Wishlist Event <a name="wishlist-events" />

These events will be stored in `wishlist_events` and `wishlist_events_detail`. There are 2 wishlist event
functions. `addToWishlist`, `removeFromWishlist`. In every event call, you can send all items in wishlist. It makes it
easy to track current items in wishlist.

```Javascript
// Current items in wishlist
const wishListItem = {}
wishListItem["product_id"] = 1

const wishListItems = []
wishListItems.push(wishListItem)


// Add to wishlist action
const params = {
    "product_id": 1,
    // ... extra columns in wishlist_events table, can be added here
    "items": wishlistItems // current items
}
Dengage.addToWishList(params)

// Remove from wishlist action
const removeParams = {
  "product_id": 1,
  // ... extra columns in wishlist_events table, can be added here
  "items": wishlistItems // current items
}
Dengage.removeFromWishList(removeParams)
```

### Search Event <a name="search-event"/>

Search events will be stored in `search_events` table.

```Javascript
  const params = {
    "keywords": "some product name", // text in the searchbox
    "result_count": 12,
    "filters": "" //you can send extra filters selected by user here. Formating is not specified
    // ... extra columns in search_events table, can be added here
}
Dengage.search(params)
```

### 2.1 Custom Events

#### Send device specific events

You can use `sendDeviceEvent` function for sending events for the device. Events are sent to a big data table defined in
your D·engage account. That table must have relation to the `master_device` table. If you set `contact_key` for that
device. Collected events will be associated for that user.

```Javascript
// for example if you have a table named "events"
// and events table has "key", "event_date", "event_name", "product_id" columns
// you just have to send the columns except "key" and "event_date", because those columns sent by the SDK
// methodSignature => dengage(‘sendDeviceEvent’, tableName: String, dataObject, callback);
const params = {
    "event_name": "page_view",
    "product_id": "1234",
}
Dengage.SendDeviceEvent(toEventTable
:
'events', andWithEventDetails
:
params, (err, res) => {
    // handle error or success response.
}
)
```

### App Inbox

App Inbox is a screen within a mobile app that stores persistent messages. It’s kind of like an email inbox, but it
lives inside the app itself. App Inbox differs from other mobile channels such as push notifications or in-app messages.
For both push and in-app messages, they’re gone once you open them.

In other words, D·engage admin panel lets you keep selected messages on the platform and Mobile SDK may retreive and
display these messages when needed.

In order to save messages into App Inbox, you need to select “Save to Inbox” option when sending messages in D·engage
admin panel by assigning an expire date to it.

Inbox messages are kept in the memory storage of the phone until app is completely closed or for a while and D·engage
SDK provides functions for getting and managing these messages.

#### Requirements

- *Android*: D·engage SDK 3.2.3+
- *iOS*: D·engage SDK 2.5.21+

#### Methods

There are 3 methods to manage App Inbox Messages

- To get app inbox messages from the server
  ```
    const inboxMessages = await Dengage.getInboxMessages(offset, limit).catch(err => err)
    // where offset: Int, limit: Int = 20
    // inboxMessages now either have array of Inbox messages or an error.
  ```
- To delete a specific message from the inbox.
  ```
    const delMsgResponse = await Dengage.deleteInboxMessage(id).catch(err => err)
    // where id: String
    // delMsgResponse now either have {success: true, id: "id-of-msg-deleted"} or an error
  ```

- to mark a specific message as clicked.
  ```
    const msgSetAsClicked = await Dengage.setInboxMessageAsClicked(id).catch(err => err)
    // where id: String &
    // msgSetAsClicked now either have {success: true, id: "id-of-msg-deleted"} or an error
  ```

### In-App Messaging

In-app message is a type of mobile message where the notification is displayed within the app. It is not sent in a
specific time but it is show to user when user are using the app. Examples include popups, yes/no prompts, banners, and
more. In order to show in-app messages, there is no permission requirement.

#### Requirements

- iOS: D·engage SDK 3.2.3+
- android: D·engage SDK 3.2.3+

#### Methods

> These function need to be check and test. It will not properly available right now.

Created messages will be stored in D·engage backend and will be served to mobile SDKs. If you integrated mobile SDK
correctly for push messages, for using in-app features you just have to add setNavigtion function to every page
navigation. If you want to use screen name filter, you should send screen name to setNavigation function in every page
navigation.

#### Simple In App Messaging

  ```
  Dengage.setNavigation()
  ```

#### In App Messaging with Screen Name

  ```
  Dengage.setNavigation('cart')
  ```

#### In App Messaging with Screen Name and Page Data

  ```
  //
  // (Coming soon)
  // Scheduled: April 2021
  // if you have extra information 
  // you can send them to use screen data filters.
  const screenData = {productId: "~hs7674", price: 1200}
  Dengage.setNavigation('product', screenData)
  ```

## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

MIT