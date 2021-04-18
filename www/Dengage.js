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
};

module.exports = Dengage
