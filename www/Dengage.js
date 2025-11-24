var exec = require('cordova/exec');

var DengageCR = {
    setContactKey: function (contactKey, success, error) {
        exec(success, error, 'DengageCR', 'setContactKey', [contactKey])
    },
    setLogStatus: function (logStatus, success, error) {
        exec(success, error, 'DengageCR', 'setLogStatus', [logStatus])
    },
    registerNotification: function (success, error) {
        exec(success, error, 'DengageCR', 'registerNotification', [])
    },
    setPermission: function (permission, success, error) {
        exec(success, error, 'DengageCR', 'setPermission', [permission])
    },
    setMobilePushToken: function (token, success, error) {
        exec(success, error, 'DengageCR', 'setMobilePushToken', [token])
    },
    getMobilePushToken: function (success, error) {
        exec(success, error, 'DengageCR', 'getMobilePushToken', [])
    },
    getContactKey: function (success, error) {
        exec(success, error, 'DengageCR', 'getContactKey', [])
    },
    getPermission: function (success, error) {
        exec(success, error, 'DengageCR', 'getPermission', [])
    },
    getSubscription: function (success, error) {
        exec(success, error, 'DengageCR', 'getSubscription', [])
    },
    pageView: function (data, success, error) {
        exec(success, error, 'DengageCR', 'pageView', [data])
    },
    addToCart: function (data, success, error) {
        exec(success, error, 'DengageCR', 'addToCart', [data])
    },
    removeFromCart: function (data, success, error) {
        exec(success, error, 'DengageCR', 'removeFromCart', [data])
    },
    viewCart: function (data, success, error) {
        exec(success, error, 'DengageCR', 'viewCart', [data])
    },
    beginCheckout: function (data, success, error) {
        exec(success, error, 'DengageCR', 'beginCheckout', [data])
    },
    placeOrder: function (data, success, error) {
        exec(success, error, 'DengageCR', 'placeOrder', [data])
    },
    cancelOrder: function (data, success, error) {
        exec(success, error, 'DengageCR', 'cancelOrder', [data])
    },
    addToWishList: function (data, success, error) {
        exec(success, error, 'DengageCR', 'addToWishList', [data])
    },
    removeFromWishList: function (data, success, error) {
        exec(success, error, 'DengageCR', 'removeFromWishList', [data])
    },
    search: function (data, success, error) {
        exec(success, error, 'DengageCR', 'search', [data])
    },
    setTags: function (data, success, error) {
        exec(success, error, 'DengageCR', 'setTags', [data])
    },
    sendDeviceEvent: function (tableName, data, success, error) {
        exec(success, error, 'DengageCR', 'sendDeviceEvent', [tableName, data])
    },
    getInboxMessages: function (offset, limit, success, error) {
        exec(success, error, 'DengageCR', 'getInboxMessages', [offset, limit])
    },
    deleteInboxMessage: function (id, success, error) {
        exec(success, error, 'DengageCR', 'deleteInboxMessage', [id])
    },
    setInboxMessageAsClicked: function (id, success, error) {
        exec(success, error, 'DengageCR', 'setInboxMessageAsClicked', [id])
    },
    promptForPushNotifications: function (success, error) {
        exec(success, error, 'DengageCR', 'promptForPushNotifications', [])
    },
    promptForPushNotificationsWithCallback: function (success, error) {
        exec(success, error, 'DengageCR', 'promptForPushNotificationsWithCallback', [])
    },
    setNavigation: function (success, error) {
        exec(success, error, 'DengageCR', 'setNavigation', [])
    },
    setNavigationWithName: function (screenName, success, error) {
        exec(success, error, 'DengageCR', 'setNavigationWithName', [screenName])
    },
    setNavigationWithNameAndData: function (screenName, screenData, success, error) {
        exec(success, error, 'DengageCR', 'setNavigationWithNameAndData', [screenName, screenData])
    },
    setCategoryPath: function (path,  success, error) {
        exec(success, error, 'DengageCR', 'setCategoryPath', [path])
    },
    setCartItemCount: function (itemCount,  success, error) {
        exec(success, error, 'DengageCR', 'setCartItemCount', [itemCount])
    },
    setCartAmount: function (amount,  success, error) {
        exec(success, error, 'DengageCR', 'setCartAmount', [amount])
    },
    setState: function (state,  success, error) {
        exec(success, error, 'DengageCR', 'setState', [state])
    },
    setCity: function (city,  success, error) {
        exec(success, error, 'DengageCR', 'setCity', [city])
    },
    showRealTimeInApp: function (screenName, data,  success, error) {
        exec(success, error, 'DengageCR', 'showRealTimeInApp', [screenName,data])
    },
    setPartnerDeviceId: function (adid,  success, error) {
        exec(success, error, 'DengageCR', 'setPartnerDeviceId', [adid])
    },
    getLastPushPayload: function (success, error) {
        exec(success, error, 'DengageCR', 'getLastPushPayload', [])
    },
    setInAppLinkConfiguration: function (deeplink, success, error) {
        exec(success, error, 'DengageCR', 'setInAppLinkConfiguration', [deeplink])
    },
    registerInAppLinkReceiver: function (success, error) {
        exec(success, error, 'DengageCR', 'registerInAppLinkReceiver', [])
    },
    
    // New methods matching React Native SDK
    sendCustomEvent: function (eventTable, key, parameters, success, error) {
        exec(success, error, 'DengageCR', 'sendCustomEvent', [eventTable, key, parameters])
    },
    
    setCart: function (cart, success, error) {
        exec(success, error, 'DengageCR', 'setCart', [cart])
    },
    
    getCart: function (success, error) {
        exec(success, error, 'DengageCR', 'getCart', [])
    },
    
    getSdkParameters: function (success, error) {
        exec(success, error, 'DengageCR', 'getSdkParameters', [])
    },
    
    setInAppDeviceInfo: function (key, value, success, error) {
        exec(success, error, 'DengageCR', 'setInAppDeviceInfo', [key, value])
    },
    
    clearInAppDeviceInfo: function (success, error) {
        exec(success, error, 'DengageCR', 'clearInAppDeviceInfo', [])
    },
    
    getInAppDeviceInfo: function (success, error) {
        exec(success, error, 'DengageCR', 'getInAppDeviceInfo', [])
    },
    
    deleteAllInboxMessages: function (success, error) {
        exec(success, error, 'DengageCR', 'deleteAllInboxMessages', [])
    },
    
    setAllInboxMessageAsClicked: function (success, error) {
        exec(success, error, 'DengageCR', 'setAllInboxMessageAsClicked', [])
    },
    
    getDeviceId: function (success, error) {
        exec(success, error, 'DengageCR', 'getDeviceId', [])
    },
    
    setDeviceId: function (deviceId, success, error) {
        exec(success, error, 'DengageCR', 'setDeviceId', [deviceId])
    },
    
    setLanguage: function (language, success, error) {
        exec(success, error, 'DengageCR', 'setLanguage', [language])
    },
    
    setDevelopmentStatus: function (isDebug, success, error) {
        exec(success, error, 'DengageCR', 'setDevelopmentStatus', [isDebug])
    },
    
    getSdkVersion: function (success, error) {
        exec(success, error, 'DengageCR', 'getSdkVersion', [])
    },
    
    requestLocationPermissions: function (success, error) {
        exec(success, error, 'DengageCR', 'requestLocationPermissions', [])
    },
    
    getIntegrationKey: function (success, error) {
        exec(success, error, 'DengageCR', 'getIntegrationKey', [])
    },
    
    getUserPermission: function (success, error) {
        exec(success, error, 'DengageCR', 'getUserPermission', [])
    },
    
    resetAppBadge: function (success, error) {
        exec(success, error, 'DengageCR', 'resetAppBadge', [])
    },
    
    setNavigationWithNameAndData: function (screenName, screenData, success, error) {
        exec(success, error, 'DengageCR', 'setNavigationWithNameAndData', [screenName, screenData])
    },
    
};

module.exports = DengageCR