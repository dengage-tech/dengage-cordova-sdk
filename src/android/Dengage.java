package Dengage;

import android.content.Context;

import com.dengage.sdk.DengageManager;
import com.dengage.sdk.DengageEvent;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CordovaWebView;
import org.json.JSONArray;

import com.google.gson.*;

import org.json.JSONException;

import com.fasterxml.jackson.databind.ObjectMapper;

import java.util.Map;

/**
 * This class Dengage functions called from JavaScript.
 */
public class Dengage extends CordovaPlugin {
    DengageManager manager = null;
    Context context = null;

    @Override
    public void initialize(CordovaInterface cordova, CordovaWebView webView) {
        super.initialize(cordova, webView);
        this.context = this.cordova.getActivity().getApplicationContext();
        this.manager = DengageManager.getInstance(this.context);
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

        if (action.equals("getPermission")) {
            this.getPermission(callbackContext);
            return true;
        }

        if (action.equals("getSubscription")) {
            this.getSubscription(callbackContext);
            return true;
        }

        if (action.equals("pageView")) {
            Object data = args.get(0);
            this.pageView(data, callbackContext);
            return true;
        }

        if (action.equals("addToCart")) {
            Object data = args.get(0);
            this.addToCart(data, callbackContext);
            return true;
        }

        if (action.equals("removeFromCart")) {
            Object data = args.get(0);
            this.removeFromCart(data, callbackContext);
            return true;
        }

        if (action.equals("viewCart")) {
            Object data = args.get(0);
            this.viewCart(data, callbackContext);
            return true;
        }

        if (action.equals("beginCheckout")) {
            Object data = args.get(0);
            this.beginCheckout(data, callbackContext);
            return true;
        }

        if (action.equals("placeOrder")) {
            Object data = args.get(0);
            this.placeOrder(data, callbackContext);
            return true;
        }

        if (action.equals("cancelOrder")) {
            Object data = args.get(0);
            this.cancelOrder(data, callbackContext);
            return true;
        }

        if (action.equals("addToWishList")) {
            Object data = args.get(0);
            this.addToWishList(data, callbackContext);
            return true;
        }

        if (action.equals("removeFromWishList")) {
            Object data = args.get(0);
            this.removeFromWishList(data, callbackContext);
            return true;
        }

        if (action.equals("search")) {
            Object data = args.get(0);
            this.search(data, callbackContext);
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
        } catch (Exception e) {
            callbackContext.error(e.getMessage());
        }
    }

    private void setLogStatus(boolean logStatus, CallbackContext callbackContext) {
        try {
            this.manager.setLogStatus(logStatus);
            callbackContext.success();
        } catch (Exception e) {
            callbackContext.error(e.getMessage());
        }
    }

    private void setPermission(boolean permission, CallbackContext callbackContext) {
        try {
            this.manager.setPermission(permission);
            callbackContext.success();
        } catch (Exception e) {
            callbackContext.error(e.getMessage());
        }
    }

    private void setFirebaseIntegrationKey(String key, CallbackContext callbackContext) {
        try {
            this.manager.setFirebaseIntegrationKey(key);
            callbackContext.success(key);
        } catch (Exception e) {
            callbackContext.error(e.getMessage());
        }
    }

    private void setHuaweiIntegrationKey(String key, CallbackContext callbackContext) {
        try {
            this.manager.setHuaweiIntegrationKey(key);
            callbackContext.success(key);
        } catch (Exception e) {
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
        } catch (Exception e) {
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
        } catch (Exception e) {
            callbackContext.error(e.getMessage());
        }
    }

    private void getContactKey(CallbackContext callbackContext) {
        try {
            String key = this.manager.getSubscription().getContactKey();
            callbackContext.success(key);
        } catch (Exception e) {
            callbackContext.error(e.getMessage());
        }
    }

    private void getPermission(CallbackContext callbackContext) {
        try {
            boolean permission = this.manager.getSubscription().getPermission();
            callbackContext.success(Boolean.toString(permission));
        } catch (Exception e) {
            callbackContext.error(e.getMessage());
        }
    }

    private void getSubscription(CallbackContext callbackContext) {
        try {
            Gson gson = new Gson();
            String subscription = gson.toJson(this.manager.getSubscription());
            callbackContext.success(subscription);
        } catch (Exception e) {
            callbackContext.error(e.getMessage());
        }
    }

    private void pageView(Object data, CallbackContext callbackContext) {
        try {
            ObjectMapper oMapper = new ObjectMapper();
            Map<String, Object> map = oMapper.convertValue(data, Map.class);

            DengageEvent.getInstance(this.context).pageView(map);

            callbackContext.success();
        } catch (Exception e) {
            callbackContext.error(e.getMessage());
        }
    }

    private void addToCart(Object data, CallbackContext callbackContext) {
        try {
            ObjectMapper oMapper = new ObjectMapper();
            Map<String, Object> map = oMapper.convertValue(data, Map.class);

            DengageEvent.getInstance(this.context).addToCart(map);

            callbackContext.success();
        } catch (Exception e) {
            callbackContext.error(e.getMessage());
        }
    }

    private void removeFromCart(Object data, CallbackContext callbackContext) {
        try {
            ObjectMapper oMapper = new ObjectMapper();
            Map<String, Object> map = oMapper.convertValue(data, Map.class);

            DengageEvent.getInstance(this.context).removeFromCart(map);

            callbackContext.success();
        } catch (Exception e) {
            callbackContext.error(e.getMessage());
        }
    }

    private void viewCart(Object data, CallbackContext callbackContext) {
        try {
            ObjectMapper oMapper = new ObjectMapper();
            Map<String, Object> map = oMapper.convertValue(data, Map.class);

            DengageEvent.getInstance(this.context).viewCart(map);

            callbackContext.success();
        } catch (Exception e) {
            callbackContext.error(e.getMessage());
        }
    }

    private void beginCheckout(Object data, CallbackContext callbackContext) {
        try {
            ObjectMapper oMapper = new ObjectMapper();
            Map<String, Object> map = oMapper.convertValue(data, Map.class);

            DengageEvent.getInstance(this.context).beginCheckout(map);

            callbackContext.success();
        } catch (Exception e) {
            callbackContext.error(e.getMessage());
        }
    }

    private void placeOrder(Object data, CallbackContext callbackContext) {
        try {
            ObjectMapper oMapper = new ObjectMapper();
            Map<String, Object> map = oMapper.convertValue(data, Map.class);

            DengageEvent.getInstance(this.context).order(map);

            callbackContext.success();
        } catch (Exception e) {
            callbackContext.error(e.getMessage());
        }
    }

    private void cancelOrder(Object data, CallbackContext callbackContext) {
        try {
            ObjectMapper oMapper = new ObjectMapper();
            Map<String, Object> map = oMapper.convertValue(data, Map.class);

            DengageEvent.getInstance(this.context).cancelOrder(map);

            callbackContext.success();
        } catch (Exception e) {
            callbackContext.error(e.getMessage());
        }
    }

    private void addToWishList(Object data, CallbackContext callbackContext) {
        try {
            ObjectMapper oMapper = new ObjectMapper();
            Map<String, Object> map = oMapper.convertValue(data, Map.class);

            DengageEvent.getInstance(this.context).addToWishList(map);

            callbackContext.success();
        } catch (Exception e) {
            callbackContext.error(e.getMessage());
        }
    }

    private void removeFromWishList(Object data, CallbackContext callbackContext) {
        try {
            ObjectMapper oMapper = new ObjectMapper();
            Map<String, Object> map = oMapper.convertValue(data, Map.class);

            DengageEvent.getInstance(this.context).removeFromWishList(map);

            callbackContext.success();
        } catch (Exception e) {
            callbackContext.error(e.getMessage());
        }
    }

    private void search(Object data, CallbackContext callbackContext) {
        try {
            ObjectMapper oMapper = new ObjectMapper();
            Map<String, Object> map = oMapper.convertValue(data, Map.class);

            DengageEvent.getInstance(this.context).search(map);

            callbackContext.success();
        } catch (Exception e) {
            callbackContext.error(e.getMessage());
        }
    }

    private boolean isEmptyOrNull(String value) {
        if (value == null || value.equals("null")) {
            return true;
        }

        if (value.length() == 0 || value.trim().length() == 0) {
            return true;
        }

        return false;
    }
}
