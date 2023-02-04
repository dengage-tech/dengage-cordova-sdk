

import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;

import com.dengage.sdk.Dengage;
import com.dengage.sdk.DengageManager;
import com.dengage.sdk.callback.DengageCallback;
import com.dengage.sdk.callback.DengageError;
import com.dengage.sdk.domain.push.model.Message;
import com.dengage.sdk.domain.tag.model.TagItem;
import com.dengage.sdk.push.NotificationReceiver;
import com.google.gson.Gson;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.google.gson.internal.LinkedTreeMap;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CordovaWebView;
import org.apache.cordova.PluginResult;
import org.jetbrains.annotations.NotNull;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

/**
 * This class Dengage functions called from JavaScript.
 */
public class DengageCR extends CordovaPlugin {

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

            this.setupDengage(logStatus, firebaseKey, huaweiKey,context,callbackContext);
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

        if (action.equals("setTags")) {
            JSONArray data = new JSONArray(args.getString(0));
            this.setTags(data, callbackContext);
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
            JSONObject data = new JSONObject(args.getString(0));
            this.pageView(data, callbackContext);

            return true;
        }

        if (action.equals("addToCart")) {
            JSONObject data = new JSONObject(args.getString(0));
            this.addToCart(data, callbackContext);
            return true;
        }

        if (action.equals("removeFromCart")) {
            JSONObject data = new JSONObject(args.getString(0));
            this.removeFromCart(data, callbackContext);
            return true;
        }

        if (action.equals("viewCart")) {
            JSONObject data = new JSONObject(args.getString(0));
            this.viewCart(data, callbackContext);
            return true;
        }

        if (action.equals("beginCheckout")) {
            JSONObject data = new JSONObject(args.getString(0));
            this.beginCheckout(data, callbackContext);
            return true;
        }

        if (action.equals("placeOrder")) {
            JSONObject data = new JSONObject(args.getString(0));
            this.placeOrder(data, callbackContext);
            return true;
        }

        if (action.equals("cancelOrder")) {
            JSONObject data = new JSONObject(args.getString(0));
            this.cancelOrder(data, callbackContext);
            return true;
        }

        if (action.equals("addToWishList")) {
            JSONObject data = new JSONObject(args.getString(0));
            this.addToWishList(data, callbackContext);
            return true;
        }

        if (action.equals("removeFromWishList")) {
            JSONObject data = new JSONObject(args.getString(0));
            this.removeFromWishList(data, callbackContext);
            return true;
        }

        if (action.equals("search")) {
            JSONObject data = new JSONObject(args.getString(0));
            this.search(data, callbackContext);
            return true;
        }

        if (action.equals("sendDeviceEvent")) {
            String tableName = args.getString(0);
            JSONObject data = new JSONObject(args.getString(1));
            this.sendDeviceEvent(tableName, data, callbackContext);
            return true;
        }

        if (action.equals("getInboxMessages")) {
            int offset = args.getInt(0);
            int limit = args.getInt(1);
            this.getInboxMessages(offset, limit, callbackContext);
            return true;
        }

        if (action.equals("deleteInboxMessage")) {
            String id = args.getString(0);
            this.deleteInboxMessage(id, callbackContext);
            return true;
        }

        if (action.equals("setInboxMessageAsClicked")) {
            String id = args.getString(0);
            this.setInboxMessageAsClicked(id, callbackContext);
            return true;
        }

        if (action.equals("setNavigation")) {
            this.setNavigation(callbackContext);
            return true;
        }

        if (action.equals("setNavigationWithName")) {
            String name = args.getString(0);
            this.setNavigationWithName(name, callbackContext);
            return true;
        }

        if (action.equals("registerNotification")) {
            this.registerNotification(callbackContext);
            return true;
        }


        if (action.equals("showRealTimeInApp")) {
            String screenName = args.getString(0);
            JSONObject data = new JSONObject(args.getString(1));

            this.showRealTimeInApp(screenName,data,callbackContext);
            return true;
        }


        if (action.equals("setCity")) {
            String city = args.getString(0);

            this.setCity(city,callbackContext);
            return true;
        }


        if (action.equals("setState")) {
            String state = args.getString(0);

            this.setState(state,callbackContext);
            return true;
        }


        if (action.equals("setCartAmount")) {
            String amount = args.getString(0);

            this.setCartAmount(amount,callbackContext);
            return true;
        }


        if (action.equals("setCartItemCount")) {
            String itemCount = args.getString(0);

            this.setCartItemCount(itemCount,callbackContext);
            return true;
        }

        if (action.equals("setCategoryPath")) {
            String path = args.getString(0);

            this.setCategoryPath(path,callbackContext);
            return true;
        }

        if (action.equals("setPartnerDeviceId")) {
            String adid = args.getString(0);

            this.setPartnerDeviceId(adid,callbackContext);
            return true;
        }

        return false;
    }

        public void setupDengage(boolean logStatus, String firebaseKey, String huaweiKey, Context context, CallbackContext callbackContext) {
        try {
            this.context = context;
            this.manager = DengageManager.getInstance(this.context);


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

    private void setTags(JSONArray data, CallbackContext callbackContext) {
        try {

            List<LinkedTreeMap<String, String>> tagList = new Gson().fromJson(data.toString(), List.class);
            List<TagItem> finalTags = new ArrayList<TagItem>();

            for (LinkedTreeMap<String, String> tagItem : tagList) {
                if (tagItem.get("tagName") != null && tagItem.get("tagValue") != null) {
                    if (tagItem.get("changeTime") != null && tagItem.get("changeValue") != null && tagItem.get("removeTime") != null) {
                        Date changeTime = null;
                        if (tagItem.get("changeTime") != null) {
                            changeTime = new Date(tagItem.get("changeTime"));
                        }
                        Date removeTime = null;
                        if (tagItem.get("changeTime") != null) {
                            removeTime = new Date(tagItem.get("changeTime"));
                        }

                        finalTags.add(new TagItem(tagItem.get("tagName"), tagItem.get("tagValue"), changeTime, tagItem.get("changeValue"), removeTime));
                    } else {
                        finalTags.add(new TagItem(tagItem.get("tagName"), tagItem.get("tagValue")));
                    }
                } else {
                    callbackContext.error("required argument 'tagName' Or 'tagValue' is missing.");
                    return;
                }
            }

            this.manager.setTags(finalTags);

            callbackContext.success(finalTags.size());
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

    private void pageView(JSONObject data, CallbackContext callbackContext) {
        try {
            HashMap<String, Object> map = new Gson().fromJson(data.toString(), HashMap.class);

            com.dengage.sdk.Dengage.INSTANCE.pageView(map,context);

            callbackContext.success();
        } catch (Exception e) {
            callbackContext.error(e.getMessage());
        }
    }

    private void addToCart(JSONObject data, CallbackContext callbackContext) {
        try {
            HashMap<String, Object> map = new Gson().fromJson(data.toString(), HashMap.class);

            com.dengage.sdk.Dengage.INSTANCE.addToCart(map,context);

            callbackContext.success();
        } catch (Exception e) {
            callbackContext.error(e.getMessage());
        }
    }

    private void removeFromCart(JSONObject data, CallbackContext callbackContext) {
        try {
            HashMap<String, Object> map = new Gson().fromJson(data.toString(), HashMap.class);

            com.dengage.sdk.Dengage.INSTANCE.removeFromCart(map,context);

            callbackContext.success();
        } catch (Exception e) {
            callbackContext.error(e.getMessage());
        }
    }

    private void viewCart(JSONObject data, CallbackContext callbackContext) {
        try {
            HashMap<String, Object> map = new Gson().fromJson(data.toString(), HashMap.class);

            com.dengage.sdk.Dengage.INSTANCE.viewCart(map,context);

            callbackContext.success();
        } catch (Exception e) {
            callbackContext.error(e.getMessage());
        }
    }

    private void beginCheckout(JSONObject data, CallbackContext callbackContext) {
        try {
            HashMap<String, Object> map = new Gson().fromJson(data.toString(), HashMap.class);

            com.dengage.sdk.Dengage.INSTANCE.beginCheckout(map,context);

            callbackContext.success();
        } catch (Exception e) {
            callbackContext.error(e.getMessage());
        }
    }

    private void placeOrder(JSONObject data, CallbackContext callbackContext) {
        try {
            HashMap<String, Object> map = new Gson().fromJson(data.toString(), HashMap.class);

            com.dengage.sdk.Dengage.INSTANCE.order(map,context);

            callbackContext.success();
        } catch (Exception e) {
            callbackContext.error(e.getMessage());
        }
    }

    private void cancelOrder(JSONObject data, CallbackContext callbackContext) {
        try {
            HashMap<String, Object> map = new Gson().fromJson(data.toString(), HashMap.class);

            com.dengage.sdk.Dengage.INSTANCE.cancelOrder(map,context);

            callbackContext.success();
        } catch (Exception e) {
            callbackContext.error(e.getMessage());
        }
    }

    private void addToWishList(JSONObject data, CallbackContext callbackContext) {
        try {
            HashMap<String, Object> map = new Gson().fromJson(data.toString(), HashMap.class);

            com.dengage.sdk.Dengage.INSTANCE.addToWishList(map,context);

            callbackContext.success();
        } catch (Exception e) {
            callbackContext.error(e.getMessage());
        }
    }

    private void removeFromWishList(JSONObject data, CallbackContext callbackContext) {
        try {
            HashMap<String, Object> map = new Gson().fromJson(data.toString(), HashMap.class);

            com.dengage.sdk.Dengage.INSTANCE.removeFromWishList(map,context);

            callbackContext.success();
        } catch (Exception e) {
            callbackContext.error(e.getMessage());
        }
    }

    private void search(JSONObject data, CallbackContext callbackContext) {
        try {
            HashMap<String, Object> map = new Gson().fromJson(data.toString(), HashMap.class);

            com.dengage.sdk.Dengage.INSTANCE.search(map,context);

            callbackContext.success();
        } catch (Exception e) {
            callbackContext.error(e.getMessage());
        }
    }

    private void sendDeviceEvent(String tableName, JSONObject data, CallbackContext callbackContext) {
        try {
            HashMap<String, Object> map = new Gson().fromJson(data.toString(), HashMap.class);

            com.dengage.sdk.Dengage.INSTANCE.sendDeviceEvent(tableName, map,context);

            callbackContext.success();
        } catch (Exception e) {
            callbackContext.error(e.getMessage());
        }
    }

    private void getInboxMessages(int offset, int limit, CallbackContext callbackContext) {
        try {
            DengageCallback callback = new DengageCallback() {
                @Override
                public void onResult(Object result) {
                    callbackContext.success(new Gson().toJson(result));
                }

                @Override
                public void onError(@NotNull DengageError dengageError) {
                    callbackContext.error(dengageError.getErrorMessage());
                }
            };

            this.manager.getInboxMessages(offset, limit, callback);
        } catch (Exception e) {
            callbackContext.error(e.getMessage());
        }
    }

    private void deleteInboxMessage(String id, CallbackContext callbackContext) {
        try {
            this.manager.deleteInboxMessage(id);
            JSONObject obj = new JSONObject();
            obj.put("success", true);
            obj.put("id", id);

            callbackContext.success(obj);
        } catch (Exception e) {
            callbackContext.error(e.getMessage());
        }
    }

    private void setInboxMessageAsClicked(String id, CallbackContext callbackContext) {
        try {
            this.manager.setInboxMessageAsClicked(id);
            JSONObject obj = new JSONObject();
            obj.put("success", true);
            obj.put("id", id);

            callbackContext.success(obj);
        } catch (Exception e) {
            callbackContext.error(e.getMessage());
        }
    }

    private void setNavigation(CallbackContext callbackContext) {
        try {
            this.manager.setNavigation(this.cordova.getActivity());

            callbackContext.success();
        } catch (Exception e) {
            callbackContext.error(e.getMessage());
        }
    }

    private void setNavigationWithName(String name, CallbackContext callbackContext) {
        try {
            if (isEmptyOrNull(name)) {
                this.manager.setNavigation(this.cordova.getActivity());
            } else {
                this.manager.setNavigation(this.cordova.getActivity(), name);
            }

            callbackContext.success();
        } catch (Exception e) {
            callbackContext.error(e.getMessage());
        }
    }

    private void registerNotification(CallbackContext callbackContext) {
        try {
            IntentFilter filter = new IntentFilter();
            filter.addAction("com.dengage.push.intent.RECEIVE");
            filter.addAction("com.dengage.push.intent.OPEN");

            NotifReciever notifReciever = new NotifReciever(callbackContext);
            context.registerReceiver(notifReciever, filter);
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
    private void  setPartnerDeviceId(String adid ,CallbackContext callbackContext)
    {
        try {
            Dengage.INSTANCE.setPartnerDeviceId(adid);
            callbackContext.success();
        }
        catch (Exception e)
        {
            callbackContext.error(e.getMessage());
        }
    }

    /**
     * Set category path for using in real time in app comparisons
     */
    private void setCategoryPath(String path,CallbackContext callbackContext) {
        try {
            Dengage.INSTANCE.setCategoryPath(path);
            callbackContext.success();
        }
        catch (Exception e)
        {
            callbackContext.error(e.getMessage());
        }
    }

    /**
     * Set cart item count for using in real time in app comparisons
     */
    private void setCartItemCount( String count,CallbackContext callbackContext) {
        try {
            Dengage.INSTANCE.setCartItemCount(count);
            callbackContext.success();
        }
        catch (Exception e)
        {
            callbackContext.error(e.getMessage());
        }
    }

    /**
     * Set cart amount for using in real time in app comparisons
     */
    private void setCartAmount(String amount,CallbackContext callbackContext) {
        try {
            Dengage.INSTANCE.setCartAmount(amount);
            callbackContext.success();
        }
        catch (Exception e)
        {
            callbackContext.error(e.getMessage());
        }
    }

    /**
     * Set state for using in real time in app comparisons
     */
    private void setState(String state,CallbackContext callbackContext) {
        try {
            Dengage.INSTANCE.setState(state);
            callbackContext.success();
        }
        catch (Exception e)
        {
            callbackContext.error(e.getMessage());
        }
    }

    /**
     * Set city for using in real time in app comparisons
     */
    private void setCity(String city,CallbackContext callbackContext) {
        try {
            Dengage.INSTANCE.setCity(city);
            callbackContext.success();
        }
        catch (Exception e)
        {
            callbackContext.error(e.getMessage());
        }
    }

    private void showRealTimeInApp(

            String screenName,
            JSONObject data,CallbackContext callbackContext
    ) {
        try {
            HashMap<String, String> map = new Gson().fromJson(data.toString(), HashMap.class);

            Dengage.INSTANCE.showRealTimeInApp(this.cordova.getActivity(), screenName, map, -1);
            callbackContext.success();
        }
        catch (Exception e)
        {
            callbackContext.error(e.getMessage());
        }
    }
}

class NotifReciever extends NotificationReceiver {
    CallbackContext notifyCallbackContext = null;

    NotifReciever(CallbackContext notifyCallbackContext) {
        this.notifyCallbackContext = notifyCallbackContext;
    }

    @Override
    public void onReceive(Context context, Intent intent) {
        String intentAction = intent.getAction();
        if (intentAction != null && notifyCallbackContext != null) {
            switch (intentAction.hashCode()) {
                case -825236177:
                    if (intentAction.equals("com.dengage.push.intent.RECEIVE")) {
                        Bundle val = intent.getExtras();
                        Message message = val != null ? Message.Companion.createFromIntent(val) : null;
                        String json = new Gson().toJson(message);
                        JsonParser parser = new JsonParser();
                        JsonElement jsonElement = parser.parse(json);
                        JsonObject jsonObject = jsonElement.getAsJsonObject();
                        jsonObject.addProperty("eventType", "PUSH_RECEIVE");


                        PluginResult result = new PluginResult(PluginResult.Status.OK, jsonObject.toString());
                        result.setKeepCallback(true);
                        notifyCallbackContext.sendPluginResult(result);
                    }
                    break;
                case -520704162:
                    if (intentAction.equals("com.dengage.push.intent.OPEN")) {
                        Bundle val = intent.getExtras();
                        Message message = val != null ? Message.Companion.createFromIntent(val) : null;
                        String json = new Gson().toJson(message);
                        JsonParser parser = new JsonParser();
                        JsonElement jsonElement = parser.parse(json);
                        JsonObject jsonObject = jsonElement.getAsJsonObject();
                        jsonObject.addProperty("eventType", "PUSH_OPEN");

                        PluginResult result = new PluginResult(PluginResult.Status.OK, jsonObject.toString());
                        result.setKeepCallback(true);
                        notifyCallbackContext.sendPluginResult(result);
                    }
                    break;
            }
        }
    }


}
