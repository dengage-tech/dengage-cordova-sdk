var exec = require('cordova/exec');

var Dengage = {
    setupDengage: function (logStatus, firebaseKey, huaweiKey, success, error) {
        exec(success, error, 'Dengage', 'setupDengage', [logStatus, firebaseKey, huaweiKey]);
    },
    setHuaweiIntegrationKey: function (key, success, error) {
        exec(success, error, 'Dengage', 'setHuaweiIntegrationKey', [key])
    },
    setFirebaseIntegrationKey: function (key, success, error) {
        exec(success, error, 'Dengage', 'setFirebaseIntegrationKey', [key])
    },
    setContactKey: function (contactKey, success, error) {
        exec(success, error, 'Dengage', 'setContactKey', [contactKey])
    },
    setLogStatus: function (logStatus, success, error) {
        exec(success, error, 'Dengage', 'setLogStatus', [logStatus])
    },
    setPermission: function (permission, success, error) {
        exec(success, error, 'Dengage', 'setPermission', [permission])
    },
    setMobilePushToken: function (token, success, error) {
        exec(success, error, 'Dengage', 'getMobilePushToken', [token])
    },
    getMobilePushToken: function (success, error) {
        exec(success, error, 'Dengage', 'getMobilePushToken', [])
    },
    getContactKey: function (success, error) {
        exec(success, error, 'Dengage', 'getContactKey', [])
    },
    getPermission: function (success, error) {
        exec(success, error, 'Dengage', 'getPermission', [])
    },
    getSubscription: function (success, error) {
        exec(success, error, 'Dengage', 'getSubscription', [])
    },
    pageView: function (data, success, error) {
        exec(success, error, 'Dengage', 'pageView', [data])
    },
    addToCart: function (data, success, error) {
        exec(success, error, 'Dengage', 'addToCart', [data])
    },
    removeFromCart: function (data, success, error) {
        exec(success, error, 'Dengage', 'removeFromCart', [data])
    },
    viewCart: function (data, success, error) {
        exec(success, error, 'Dengage', 'viewCart', [data])
    },
    beginCheckout: function (data, success, error) {
        exec(success, error, 'Dengage', 'beginCheckout', [data])
    },
    placeOrder: function (data, success, error) {
        exec(success, error, 'Dengage', 'placeOrder', [data])
    },
    cancelOrder: function (data, success, error) {
        exec(success, error, 'Dengage', 'cancelOrder', [data])
    },
    addToWishList: function (data, success, error) {
        exec(success, error, 'Dengage', 'addToWishList', [data])
    },
    removeFromWishList: function (data, success, error) {
        exec(success, error, 'Dengage', 'removeFromWishList', [data])
    },
    search: function (data, success, error) {
        exec(success, error, 'Dengage', 'search', [data])
    },
    sendDeviceEvent: function (tableName, data, success, error) {
        exec(success, error, 'Dengage', 'sendDeviceEvent', [tableName, data])
    },
    getInboxMessages: function (offset, limit, success, error) {
        exec(success, error, 'Dengage', 'getInboxMessages', [offset, limit])
    },
    deleteInboxMessage: function (id, success, error) {
        exec(success, error, 'Dengage', 'deleteInboxMessage', [id])
    },
    setInboxMessageAsClicked: function (id, success, error) {
        exec(success, error, 'Dengage', 'setInboxMessageAsClicked', [id])
    }
};

module.exports = Dengage
