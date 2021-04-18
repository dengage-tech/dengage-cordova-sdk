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
  -Need to be write....
</details>

<details>
  <summary> android Specific Extra Steps </summary>

### Firebase SDK Setup (Follow these steps only if you're using firebase for push, for Huawei [follow these steps](#huawei-sdk-setup))<a name="firebase-sdk-setup" />

#### Requirements

- Google Firebase App Configuration
- Android Studio
- Android Device or Emulator

D·engage Android SDK provides an interface which handles push notification messages easily. Optionally, It also gives to
send event functionality such as open and subscription to dEngage Platform.

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

You can change subscription api endpoint by adding following metadata tag in `YourProject/config.xml`

  ```
  <meta-data
    android:name="den_event_api_url"
    android:value="https://your_event_api_endpoint" />
  ```

Note: Please see API Endpoints By Datacenter to set your subscription end point.

### Changing Event Api Endpoint

similar to subscription endpoints, you can change event api endpoints by setting following metadata tag
in `YourProject/config.xml`

  ```
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

```Javascript
Dengage.setupDengage(logStatus, firebaseKey, huaweiKey, successCallbackFunc, errorCallbackFunc)
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

### Subscription
****Subscription is a process which is triggered by sending subscription event to D·engage. It contains necessary informations about application to send push notifications to clients.****

Subscriptions are self managed by D·engage SDK and subcription cycle starts with Prompting user permission. SDK will automaticlly send subscription events under following circumstances:

- Initialization
- Setting Contact key
- Setting Token
- Setting User Permission (if you have manual management of permission)

### Asking User Permission for Notification
> Note: Android doesn't require to ask for push notifications explicitly. Therefore, you can only ask for push notification's permissions on iOS.

IOS uses shared `UNUserNotificationCenter` by itself while asking user to send notification. D·engage SDK manager uses `UNUserNotificationCenter` to ask permission as well. [Apple Doc Reference](https://developer.apple.com/documentation/usernotifications/asking_permission_to_use_notifications)

If in your application, you want to get UserNotification permissions explicitly, you can do by calling one of the following methods:

```Javascript
// will update docs when starting on cordova dengage sdk for ios
```

### Setting Contact Key
***Contact Key represents user id in your system. There are two types of devices. Anonymous Devices and Contact Devices. Contact Devices contains Contact Key.***

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
If you need to get current token or if you are managing token subscription process manually, you can use setToken and getToken functions.

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
If you manage your own user permission states on your application you may send user permission by using setUserPermission method.

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

#### Get User Permission

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