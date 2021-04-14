# cordova-plugin-dengage

**D·engage Customer Driven Marketing Platform (CDMP)** serves as a customer data platform (CDP) with built-in omnichannel marketing features. It replaces your marketing automation and cross-channel campaign management.
For further details about D·engage please [visit here](https://dev.dengage.com).

This package makes it easy to integrate, D·engage, with your React-Native iOS and/or Android apps. Following are instructions for installation of react-native-dengage SDK to your react-native applications.

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

D·engage Android SDK provides an interface which handles push notification messages easily. Optionally, It also gives to send event functionality such as open and subscription to dEngage Platform.

Supports Android API level 4.1.x or higher.

For detailed steps for firebase SDK setup and it's integeration with D·engage, [click here](https://dev.dengage.com/mobile-sdk/android/firebase)

### Huawei SDK Setup (Note: use these steps only if you're using HUAWEI Messaging Service for push, if using firebase, [follow these steps](#firebase-sdk-setup))<a name="huawei-sdk-setup" />

#### Requirements

- Huawei Developer Account
- Java JDK installation package
- Android SDK package
- Android Studio 3.X
- HMS Core (APK) 4.X or later
- Huawei Device or Huawei Cloud Debugging

Supports Android API level 4.4 or higher. (Note that Huawei AdID service requires min target SDK version 19)

**D·engage Huawei SDK** provides an interface which handles push notification messages that delivered by `Huawei Messaging Service (HMS)`. It is similar to Firebase but has a bit different configuration process that contains [steps mentioned here.](https://dev.dengage.com/mobile-sdk/android/huawei)
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

```Javascript
Dengage.setupDengage(logStatus, firebaseKey, huaweiKey, successCallback, errorCallback)
```
### Change Subscription Api Endpoint
You can change subscription api endpoint by adding following metadata tag in `YourProject/plugin.xml`

  ```
  <meta-data
    android:name="den_event_api_url"
    android:value="https://your_event_api_endpoint" />
  ```

Note: Please see API Endpoints By Datacenter to set your subscription end point.

### Changing Event Api Endpoint
similar to subscription endpoints, you can change event api endpoints by setting following metadata tag in `YourProject/plugin.xml`
  ```
  <meta-data
    android:name="den_push_api_url"
    android:value="https://your_push_api_endpoint" />
  ```

Note: Please see API Endpoints By Datacenter to set your event end point.

Now you can setContactKey like mentioned [here](#setting-contact-key)