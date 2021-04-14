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
            this.setContactKey(logStatus, callbackContext);
            return true;
        }

        if (action.equals("setPermission")) {
            boolean permission = Boolean.parseBoolean(args.getString(0));
            this.setContactKey(permission, callbackContext);
            return true;
        }

        if (action.equals("setHuaweiIntegrationKey")) {
            String key = args.getString(0);
            this.setHuaweiIntegrationKey(permission, callbackContext);
            return true;
        }

        if (action.equals("setFirebaseIntegrationKey")) {
            String key = args.getString(0);
            this.setFirebaseIntegrationKey(key, callbackContext);
            return true;
        }

        if (action.equals("getMobilePushToken")) {
            this.getMobilePushToken(callbackContext);
            return true;
        }

        return false;
    }

    private void setupDengage(boolean logStatus, String firebaseKey, String huaweiKey, CallbackContext callbackContext) {
        try {
            if (firebaseKey == null && huaweiKey == null) {
                callbackContext.error("Both firebase key and huawei key can't be null at the same time.");
                return;
            }

            if (firebaseKey != null) {
                 this.manager
                    .setLogStatus(logStatus)
                    .setFirebaseIntegrationKey(firebaseKey)
                    .init();
            } else if (huaweiKey != null) {
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

            callbackContext.success("Dengage Setup Successfully");
        } catch (Exception e) {
            callbackContext.error(e.getMessage());
        }
    }

    private void setContactKey(String contactKey, CallbackContext callbackContext) {
        try {
            this.manager.setContactKey(contactKey);
            callbackContext.success("Setting Contact Key Successfully");
        }  catch (Exception e) {
           callbackContext.error(e.getMessage());
         }
    }

    private void setLogStatus(boolean logStatus, CallbackContext callbackContext) {
        try {
            this.manager.setLogStatus(logStatus);
            callbackContext.success("Set Log Status " + logStatus);
        }  catch (Exception e) {
           callbackContext.error(e.getMessage());
         }
    }

    private void setPermission(boolean permission, CallbackContext callbackContext) {
        try {
            this.manager.setPermission(permission);
            callbackContext.success("Set Log Status " + logStatus);
        }  catch (Exception e) {
           callbackContext.error(e.getMessage());
         }
    }

    private void setFirebaseIntegrationKey(String key, CallbackContext callbackContext) {
            try {
                this.manager.setFirebaseIntegrationKey(key);
                callbackContext.success("Setting Firebase Integration Key " + token);
            }  catch (Exception e) {
               callbackContext.error(e.getMessage());
             }
    }

    private void setHuaweiIntegrationKey(String key, CallbackContext callbackContext) {
            try {
                this.manager.setHuaweiIntegrationKey(key);
                callbackContext.success("Setting Huawei Integration Key " + token);
            }  catch (Exception e) {
               callbackContext.error(e.getMessage());
             }
    }

    private void getMobilePushToken(CallbackContext callbackContext) {
            try {
                const token = this.manager.getSubscription().token;
                if (token) {
                    callbackContext.success(token);
                    return;
                }

                throw Exception("unable to get token.");
            }  catch (Exception e) {
               callbackContext.error(e.getMessage());
             }
    }
}
