import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CordovaWebView;
import org.apache.cordova.LOG;
import com.dengage.sdk.DengageManager;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.content.Context;

/**
 * This class Dengage functions called from JavaScript.
 */
public class Dengage extends CordovaPlugin {
    DengageManager manager = null;

    @Override
    public void initialize(CordovaInterface cordova, CordovaWebView webView) {
    	super.initialize(cordova, webView);
        Context context = this.cordova.getActivity().getApplicationContext();
        this.manager = DengageManager.getInstance(context);
    }


    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        if (action.equals("setupDengage")) {
            boolean logStatus = Boolean.parseBoolean(args.getString(0));
            String firebaseKey = args.getString(1);
            String huaweiKey = args.getString(2);

            this.setupDengage(logStatus, firebaseKey, huaweiKey, callbackContext);
            return true;
        }

        if (action.equals("setContactKey")) {
            String contactKey = args.getString(0);
            this.setContactKey(contactKey, callbackContext);
            return true;
        }

        if (action.equals("setLogStatus")) {
            boolean logStatus = Boolean.parseBoolean(args.getString(0));
            this.setLogStatus(logStatus, callbackContext);
            return true;
        }

        if (action.equals("setPermission")) {
            boolean permission = Boolean.parseBoolean(args.getString(0));
            this.setPermission(permission, callbackContext);
            return true;
        }

        if (action.equals("setHuaweiIntegrationKey")) {
            String key = args.getString(0);
            this.setHuaweiIntegrationKey(key, callbackContext);
            return true;
        }

        if (action.equals("setFirebaseIntegrationKey")) {
            String key = args.getString(0);
            this.setFirebaseIntegrationKey(key, callbackContext);
            return true;
        }

        if (action.equals("setMobilePushToken")) {
            String token = args.getString(0);
            this.setMobilePushToken(token, callbackContext);
            return true;
        }

        if (action.equals("getMobilePushToken")) {
            this.getMobilePushToken(callbackContext);
            return true;
        }

        if (action.equals("getContactKey")) {
            this.getContactKey(callbackContext);
            return true;
        }

        if (action.equals("getUserPermission")) {
            this.getPermission(callbackContext);
            return true;
        }

        return false;
    }

    private void setupDengage(boolean logStatus, String firebaseKey, String huaweiKey, CallbackContext callbackContext) {
        try {
            if (this.isEmptyOrNull(firebaseKey) && this.isEmptyOrNull(huaweiKey)) {
                callbackContext.error("Both firebase key and huawei key can't be null at the same time.");
                return;
            }

            if (!this.isEmptyOrNull(firebaseKey)) {
                 this.manager
                    .setLogStatus(logStatus)
                    .setFirebaseIntegrationKey(firebaseKey)
                    .init();
            } else if (!this.isEmptyOrNull(huaweiKey)) {
                this.manager
                    .setLogStatus(logStatus)
                    .setHuaweiIntegrationKey(huaweiKey)
                    .init();
            } else {
                this.manager
                    .setLogStatus(logStatus)
                    .setHuaweiIntegrationKey(huaweiKey)
                    .setFirebaseIntegrationKey(firebaseKey)
                    .init();
            }

            callbackContext.success();
        } catch (Exception e) {
            callbackContext.error(e.getMessage());
        }
    }

    private void setContactKey(String contactKey, CallbackContext callbackContext) {
        try {
            this.manager.setContactKey(contactKey);
            callbackContext.success(contactKey);
        }  catch (Exception e) {
           callbackContext.error(e.getMessage());
         }
    }

    private void setLogStatus(boolean logStatus, CallbackContext callbackContext) {
        try {
            this.manager.setLogStatus(logStatus);
            callbackContext.success();
        }  catch (Exception e) {
           callbackContext.error(e.getMessage());
         }
    }

    private void setPermission(boolean permission, CallbackContext callbackContext) {
        try {
            this.manager.setPermission(permission);
            callbackContext.success();
        }  catch (Exception e) {
           callbackContext.error(e.getMessage());
         }
    }

    private void setFirebaseIntegrationKey(String key, CallbackContext callbackContext) {
            try {
                this.manager.setFirebaseIntegrationKey(key);
                callbackContext.success(key);
            }  catch (Exception e) {
               callbackContext.error(e.getMessage());
             }
    }

    private void setHuaweiIntegrationKey(String key, CallbackContext callbackContext) {
            try {
                this.manager.setHuaweiIntegrationKey(key);
                callbackContext.success(key);
            }  catch (Exception e) {
               callbackContext.error(e.getMessage());
             }
    }

    private void getMobilePushToken(CallbackContext callbackContext) {
            try {
                String token = this.manager.getSubscription().getToken();
                if (!this.isEmptyOrNull(token)) {
                    callbackContext.success(token);
                    return;
                }

                callbackContext.error("unable to get token.");
            }  catch (Exception e) {
               callbackContext.error(e.getMessage());
             }
    }

    private void setMobilePushToken(String token, CallbackContext callbackContext) {
            try {
                if (this.isEmptyOrNull(token)) {
                   callbackContext.error("Token is required");
                   return;
                }

                this.manager.getSubscription().setToken(token);
                callbackContext.success(token);
            }  catch (Exception e) {
               callbackContext.error(e.getMessage());
             }
    }

    private void getContactKey(CallbackContext callbackContext) {
            try {
                String key = this.manager.getSubscription().getContactKey();
                callbackContext.success(key);
            }  catch (Exception e) {
               callbackContext.error(e.getMessage());
             }
    }

    private void getPermission(CallbackContext callbackContext) {
            try {
                boolean permission = this.manager.getSubscription().getPermission();
                callbackContext.success();
            }  catch (Exception e) {
               callbackContext.error(e.getMessage());
             }
    }

    private boolean isEmptyOrNull (String value) {
        if (value == null || value == "null" )  {
               return true;
        }

        if (value.length() == 0 || value.trim().length() == 0) {
            return true;
        }

        return false;
    }
}
