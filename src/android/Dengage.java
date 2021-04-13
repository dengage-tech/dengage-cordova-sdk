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
}
