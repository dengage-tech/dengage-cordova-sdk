var exec = require('cordova/exec');

var Dengage = {
    setupDengage: function (logStatus, firebaseKey, huaweiKey, success, error) {
        exec(success, error, 'Dengage', 'setupDengage', [logStatus, firebaseKey, huaweiKey]);
    },

};

module.exports = Dengage
