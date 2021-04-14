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
    getMobilePushToken: function (success, error) {
        exec(success, error, 'Dengage', 'getMobilePushToken', [])
    },
};

module.exports = Dengage
