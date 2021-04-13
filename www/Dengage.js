var exec = require('cordova/exec');

var Dengage = {
    coolMethod: function (arg0, success, error) {
        exec(success, error, 'Dengage', 'coolMethod', [arg0]);
    }
};

module.exports = Dengage
