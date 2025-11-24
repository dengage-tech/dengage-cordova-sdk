

import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;
import android.util.Log;

import com.dengage.sdk.Dengage;
import com.dengage.sdk.DengageManager;
import com.dengage.sdk.callback.DengageCallback;
import com.dengage.sdk.callback.DengageError;
import com.dengage.sdk.domain.push.model.Message;
import com.dengage.sdk.domain.tag.model.TagItem;
import com.dengage.sdk.inapp.InAppBroadcastReceiver;
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
import java.util.Map;

/**
 * This class Dengage functions called from JavaScript.
 */
public class DengageCR extends CordovaPlugin {

    Context context = null;
    DengageManager manager = null;

    @Override
    public void initialize(CordovaInterface cordova, CordovaWebView webView) {
        super.initialize(cordova, webView);
        this.context = this.cordova.getActivity().getApplicationContext();
        this.manager = DengageManager.getInstance(this.context);
    }


    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
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

        if (action.equals("getLastPushPayload")) {
            this.getLastPushPayload(callbackContext);
            return true;
        }

        if (action.equals("setInAppLinkConfiguration")) {
            String deeplink = args.getString(0);

            this.setInAppLinkConfiguration(deeplink,callbackContext);
            return true;
        }

        if (action.equals("registerInAppLinkReceiver")) {
            this.registerInAppLinkReceiver(callbackContext);
            return true;
        }

        if (action.equals("promptForPushNotifications")) {
            this.promptForPushNotifications(callbackContext);
            return true;
        }

        if (action.equals("setUserPermission")) {
            boolean permission = Boolean.parseBoolean(args.getString(0));
            this.setUserPermission(permission, callbackContext);
            return true;
        }

        if (action.equals("setInAppDeviceInfo")) {
            String key = args.getString(0);
            String value = args.getString(1);
            this.setInAppDeviceInfo(key, value, callbackContext);
            return true;
        }

        if (action.equals("clearInAppDeviceInfo")) {
            this.clearInAppDeviceInfo(callbackContext);
            return true;
        }

        if (action.equals("getInAppDeviceInfo")) {
            this.getInAppDeviceInfo(callbackContext);
            return true;
        }

        if (action.equals("deleteAllInboxMessages")) {
            this.deleteAllInboxMessages(callbackContext);
            return true;
        }

        if (action.equals("setAllInboxMessageAsClicked")) {
            this.setAllInboxMessageAsClicked(callbackContext);
            return true;
        }

        if (action.equals("getIntegrationKey")) {
            this.getIntegrationKey(callbackContext);
            return true;
        }

        if (action.equals("sendCustomEvent")) {
            String eventTable = args.getString(0);
            String key = args.getString(1);
            JSONObject parameters = new JSONObject(args.getString(2));
            this.sendCustomEvent(eventTable, key, parameters, callbackContext);
            return true;
        }

        if (action.equals("setCart")) {
            JSONObject cart = new JSONObject(args.getString(0));
            this.setCart(cart, callbackContext);
            return true;
        }

        if (action.equals("getCart")) {
            this.getCart(callbackContext);
            return true;
        }

        if (action.equals("getSdkParameters")) {
            this.getSdkParameters(callbackContext);
            return true;
        }

        if (action.equals("requestLocationPermissions")) {
            this.requestLocationPermissions(callbackContext);
            return true;
        }

        if (action.equals("getDeviceId")) {
            this.getDeviceId(callbackContext);
            return true;
        }

        if (action.equals("getSdkVersion")) {
            this.getSdkVersion(callbackContext);
            return true;
        }

        return false;
    }

    private void setContactKey(String contactKey, CallbackContext callbackContext) {
        try {
            Dengage.INSTANCE.setContactKey(contactKey);
            callbackContext.success(contactKey);
        } catch (Exception e) {
            callbackContext.error(e.getMessage());
        }
    }

    private void setLogStatus(boolean logStatus, CallbackContext callbackContext) {
        try {
            Dengage.INSTANCE.setLogStatus(logStatus);
            callbackContext.success();
        } catch (Exception e) {
            callbackContext.error(e.getMessage());
        }
    }

    private void setPermission(boolean permission, CallbackContext callbackContext) {
        try {
            Dengage.INSTANCE.setUserPermission(permission);
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

            Dengage.INSTANCE.setTags(finalTags, this.context);

            callbackContext.success(finalTags.size());
        } catch (Exception e) {
            callbackContext.error(e.getMessage());
        }
    }


    private void getMobilePushToken(CallbackContext callbackContext) {
        try {
            String token = Dengage.INSTANCE.getSubscription().getToken();
            Log.d("DengageCR", "getMobilePushToken called - Token: " + (token != null ? token : "null"));
            if (!this.isEmptyOrNull(token)) {
                callbackContext.success(token);
                return;
            }

            Log.w("DengageCR", "Unable to get mobile push token - token is null or empty");
            callbackContext.error("unable to get token.");
        } catch (Exception e) {
            Log.e("DengageCR", "Error getting mobile push token: " + e.getMessage(), e);
            callbackContext.error(e.getMessage());
        }
    }

    private void setMobilePushToken(String token, CallbackContext callbackContext) {
        try {
            if (this.isEmptyOrNull(token)) {
                callbackContext.error("Token is required");
                return;
            }

            Dengage.INSTANCE.getSubscription().setToken(token);
            callbackContext.success(token);
        } catch (Exception e) {
            callbackContext.error(e.getMessage());
        }
    }

    private void getContactKey(CallbackContext callbackContext) {
        try {
            String key = Dengage.INSTANCE.getSubscription().getContactKey();
            Log.d("DengageCR", "getContactKey called - Contact Key: " + (key != null ? key : "null"));
            callbackContext.success(key);
        } catch (Exception e) {
            Log.e("DengageCR", "Error getting contact key: " + e.getMessage(), e);
            callbackContext.error(e.getMessage());
        }
    }

    private void getPermission(CallbackContext callbackContext) {
        try {
            boolean permission = Dengage.INSTANCE.getSubscription().getPermission();
            Log.d("DengageCR", "getPermission called - Permission: " + permission);
            callbackContext.success(Boolean.toString(permission));
        } catch (Exception e) {
            Log.e("DengageCR", "Error getting permission: " + e.getMessage(), e);
            callbackContext.error(e.getMessage());
        }
    }

    private void getSubscription(CallbackContext callbackContext) {
        try {
            Gson gson = new Gson();
            String subscription = gson.toJson(Dengage.INSTANCE.getSubscription());
            
            // Log device info
            Log.d("DengageCR", "========== DEVICE INFO FETCHED ==========");
            Log.d("DengageCR", "Full Subscription JSON: " + subscription);
            
            // Parse and log individual fields
            try {
                JSONObject json = new JSONObject(subscription);
                Log.d("DengageCR", "Integration Key: " + json.optString("integrationKey", "N/A"));
                Log.d("DengageCR", "Device ID: " + json.optString("udid", "N/A"));
                Log.d("DengageCR", "Contact Key: " + json.optString("contactKey", "N/A"));
                Log.d("DengageCR", "Token: " + json.optString("token", "N/A"));
                Log.d("DengageCR", "Permission: " + json.optBoolean("permission", false));
                Log.d("DengageCR", "SDK Version: " + json.optString("sdkVersion", "N/A"));
                Log.d("DengageCR", "App Version: " + json.optString("appVersion", "N/A"));
                Log.d("DengageCR", "Token Type: " + json.optString("tokenType", "N/A"));
                Log.d("DengageCR", "Language: " + json.optString("language", "N/A"));
                Log.d("DengageCR", "Country: " + json.optString("country", "N/A"));
                Log.d("DengageCR", "Timezone: " + json.optString("timezone", "N/A"));
            } catch (Exception parseEx) {
                Log.e("DengageCR", "Error parsing subscription JSON: " + parseEx.getMessage());
            }
            
            Log.d("DengageCR", "==========================================");
            
            callbackContext.success(subscription);
        } catch (Exception e) {
            Log.e("DengageCR", "Error getting subscription: " + e.getMessage(), e);
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

            Dengage.INSTANCE.getInboxMessages(offset, limit, callback);
        } catch (Exception e) {
            callbackContext.error(e.getMessage());
        }
    }

    private void deleteInboxMessage(String id, CallbackContext callbackContext) {
        try {
            Dengage.INSTANCE.deleteInboxMessage(id);
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
            Dengage.INSTANCE.setInboxMessageAsClicked(id);
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

    private void getLastPushPayload(CallbackContext callbackContext) {
        try {
            String payload =  Dengage.INSTANCE.getLastPushPayload();
            if (!this.isEmptyOrNull(payload)) {
                callbackContext.success(payload);
                return;
            }

            callbackContext.error("unable to get payload.");
        } catch (Exception e) {
            callbackContext.error(e.getMessage());
        }
    }

    private void setInAppLinkConfiguration(String deeplink, CallbackContext callbackContext) {
        try {
            Dengage.INSTANCE.inAppLinkConfiguration(deeplink);
            callbackContext.success(deeplink);
        } catch (Exception e) {
            callbackContext.error(e.getMessage());
        }
    }

    private void registerInAppLinkReceiver(CallbackContext callbackContext) {
        try {
            IntentFilter filter = new IntentFilter();
            filter.addAction("com.dengage.inapp.LINK_RETRIEVAL");

            InAppReceiver inAppReceiver = new InAppReceiver(callbackContext);
            context.registerReceiver(inAppReceiver, filter);
        } catch (Exception e) {
            callbackContext.error(e.getMessage());
        }
    }

    private void promptForPushNotifications(CallbackContext callbackContext) {
        try {
            android.app.Activity activity = this.cordova.getActivity();
            if (activity != null) {
                Dengage.INSTANCE.requestNotificationPermission(activity);
                callbackContext.success();
            } else {
                callbackContext.error("Activity is null");
            }
        } catch (Exception e) {
            callbackContext.error(e.getMessage());
        }
    }

    private void setUserPermission(boolean permission, CallbackContext callbackContext) {
        try {
            Dengage.INSTANCE.setUserPermission(permission);
            callbackContext.success();
        } catch (Exception e) {
            callbackContext.error(e.getMessage());
        }
    }

    private void setInAppDeviceInfo(String key, String value, CallbackContext callbackContext) {
        try {
            Dengage.INSTANCE.setInAppDeviceInfo(key, value);
            callbackContext.success();
        } catch (Exception e) {
            callbackContext.error(e.getMessage());
        }
    }

    private void clearInAppDeviceInfo(CallbackContext callbackContext) {
        try {
            Dengage.INSTANCE.clearInAppDeviceInfo();
            callbackContext.success();
        } catch (Exception e) {
            callbackContext.error(e.getMessage());
        }
    }

    private void getInAppDeviceInfo(CallbackContext callbackContext) {
        try {
            java.util.Map<String, String> inAppDeviceInfo = Dengage.INSTANCE.getInAppDeviceInfo();
            JSONObject result = new JSONObject();
            for (String key : inAppDeviceInfo.keySet()) {
                result.put(key, inAppDeviceInfo.get(key));
            }
            callbackContext.success(result);
        } catch (Exception e) {
            callbackContext.error(e.getMessage());
        }
    }

    private void deleteAllInboxMessages(CallbackContext callbackContext) {
        try {
            Dengage.INSTANCE.deleteAllInboxMessages();
            callbackContext.success();
        } catch (Exception e) {
            callbackContext.error(e.getMessage());
        }
    }

    private void setAllInboxMessageAsClicked(CallbackContext callbackContext) {
        try {
            Dengage.INSTANCE.setAllInboxMessagesAsClicked();
            callbackContext.success();
        } catch (Exception e) {
            callbackContext.error(e.getMessage());
        }
    }

    private void getIntegrationKey(CallbackContext callbackContext) {
        try {
            String integrationKey = Dengage.INSTANCE.getSubscription() != null ? 
                Dengage.INSTANCE.getSubscription().getIntegrationKey() : "";
            Log.d("DengageCR", "getIntegrationKey called - Integration Key: " + (integrationKey != null && !integrationKey.isEmpty() ? integrationKey : "null/empty"));
            callbackContext.success(integrationKey);
        } catch (Exception e) {
            Log.e("DengageCR", "Error getting integration key: " + e.getMessage(), e);
            callbackContext.error(e.getMessage());
        }
    }

    private void sendCustomEvent(String eventTable, String key, JSONObject parameters, CallbackContext callbackContext) {
        try {
            HashMap<String, Object> paramsMap = new Gson().fromJson(parameters.toString(), HashMap.class);
            Dengage.INSTANCE.sendCustomEvent(eventTable, key, paramsMap, context);
            callbackContext.success();
        } catch (Exception e) {
            callbackContext.error(e.getMessage());
        }
    }

    private void setCart(JSONObject cart, CallbackContext callbackContext) {
        try {
            JSONArray itemsArray = cart.getJSONArray("items");
            List<com.dengage.sdk.domain.inappmessage.model.CartItem> cartItems = new ArrayList<>();
            
            for (int i = 0; i < itemsArray.length(); i++) {
                JSONObject itemObj = itemsArray.getJSONObject(i);
                
                String productId = itemObj.optString("productId", itemObj.optString("product_id", ""));
                String productVariantId = itemObj.optString("productVariantId", itemObj.optString("product_variant_id", ""));
                String categoryPath = itemObj.optString("categoryPath", itemObj.optString("category_path", ""));
                int price = itemObj.optInt("price", 0);
                int discountedPrice = itemObj.optInt("discountedPrice", itemObj.optInt("discounted_price", 0));
                boolean hasDiscount = itemObj.optBoolean("hasDiscount", itemObj.optBoolean("has_discount", false));
                boolean hasPromotion = itemObj.optBoolean("hasPromotion", itemObj.optBoolean("has_promotion", false));
                int quantity = itemObj.optInt("quantity", 0);
                
                HashMap<String, String> attributes = new HashMap<>();
                if (itemObj.has("attributes")) {
                    JSONObject attributesObj = itemObj.getJSONObject("attributes");
                    JSONArray keys = attributesObj.names();
                    if (keys != null) {
                        for (int j = 0; j < keys.length(); j++) {
                            String attrKey = keys.getString(j);
                            String attrValue = attributesObj.getString(attrKey);
                            attributes.put(attrKey, attrValue);
                        }
                    }
                }
                
                // Calculate computed fields
                int effectivePrice = hasDiscount ? discountedPrice : price;
                int lineTotal = price * quantity;
                int discountedLineTotal = discountedPrice * quantity;
                int effectiveLineTotal = effectivePrice * quantity;
                
                // Parse category path into segments
                List<String> categorySegments = new ArrayList<>();
                if (categoryPath != null && !categoryPath.isEmpty()) {
                    String[] segments = categoryPath.split("/");
                    for (String segment : segments) {
                        if (segment != null && !segment.trim().isEmpty()) {
                            categorySegments.add(segment.trim());
                        }
                    }
                }
                String categoryRoot = categorySegments.size() > 0 ? categorySegments.get(0) : "";
                
                com.dengage.sdk.domain.inappmessage.model.CartItem cartItem = 
                    new com.dengage.sdk.domain.inappmessage.model.CartItem(
                        productId, productVariantId, categoryPath, price, 
                        discountedPrice, hasDiscount, hasPromotion, quantity, attributes,
                        effectivePrice, lineTotal, discountedLineTotal, effectiveLineTotal,
                        categorySegments, categoryRoot
                    );
                cartItems.add(cartItem);
            }
            
            // Create CartSummary
            String currency = "USD"; // Default currency
            long updatedAt = System.currentTimeMillis();
            int linesCount = cartItems.size();
            int itemsCount = 0;
            int subtotal = 0;
            int discountedSubtotal = 0;
            int effectiveSubtotal = 0;
            boolean anyDiscounted = false;
            boolean allDiscounted = true;
            int minPrice = Integer.MAX_VALUE;
            int maxPrice = 0;
            int minEffectivePrice = Integer.MAX_VALUE;
            int maxEffectivePrice = 0;
            HashMap<String, Integer> categories = new HashMap<>();
            
            for (com.dengage.sdk.domain.inappmessage.model.CartItem item : cartItems) {
                itemsCount += item.getQuantity();
                subtotal += item.getPrice() * item.getQuantity();
                discountedSubtotal += item.getDiscountedPrice() * item.getQuantity();
                effectiveSubtotal += item.getEffectivePrice() * item.getQuantity();
                if (item.getHasDiscount()) {
                    anyDiscounted = true;
                } else {
                    allDiscounted = false;
                }
                minPrice = Math.min(minPrice, item.getPrice());
                maxPrice = Math.max(maxPrice, item.getPrice());
                minEffectivePrice = Math.min(minEffectivePrice, item.getEffectivePrice());
                maxEffectivePrice = Math.max(maxEffectivePrice, item.getEffectivePrice());
                
                // Count by category
                String catRoot = item.getCategoryRoot();
                if (catRoot != null && !catRoot.isEmpty()) {
                    Integer count = categories.get(catRoot);
                    categories.put(catRoot, (count == null ? 0 : count) + item.getQuantity());
                }
            }
            
            if (cartItems.isEmpty()) {
                minPrice = 0;
                minEffectivePrice = 0;
            }
            
            com.dengage.sdk.domain.inappmessage.model.CartSummary summary = 
                new com.dengage.sdk.domain.inappmessage.model.CartSummary(
                    currency, updatedAt, linesCount, itemsCount, subtotal,
                    discountedSubtotal, effectiveSubtotal, anyDiscounted, allDiscounted,
                    minPrice, maxPrice, minEffectivePrice, maxEffectivePrice, categories
                );
            
            com.dengage.sdk.domain.inappmessage.model.Cart cartObj = 
                new com.dengage.sdk.domain.inappmessage.model.Cart(cartItems, summary);
            Dengage.INSTANCE.setCart(cartObj);
            callbackContext.success();
        } catch (Exception e) {
            callbackContext.error(e.getMessage());
        }
    }

    private void getCart(CallbackContext callbackContext) {
        try {
            com.dengage.sdk.domain.inappmessage.model.Cart cart = Dengage.INSTANCE.getCart();
            JSONObject result = new JSONObject();
            JSONArray itemsArray = new JSONArray();
            
            for (com.dengage.sdk.domain.inappmessage.model.CartItem item : cart.getItems()) {
                JSONObject itemObj = new JSONObject();
                itemObj.put("productId", item.getProductId());
                itemObj.put("productVariantId", item.getProductVariantId());
                itemObj.put("categoryPath", item.getCategoryPath());
                itemObj.put("price", item.getPrice());
                itemObj.put("discountedPrice", item.getDiscountedPrice());
                itemObj.put("hasDiscount", item.getHasDiscount());
                itemObj.put("hasPromotion", item.getHasPromotion());
                itemObj.put("quantity", item.getQuantity());
                
                JSONObject attributesObj = new JSONObject();
                for (String key : item.getAttributes().keySet()) {
                    attributesObj.put(key, item.getAttributes().get(key));
                }
                itemObj.put("attributes", attributesObj);
                
                itemObj.put("effectivePrice", item.getEffectivePrice());
                itemObj.put("lineTotal", item.getLineTotal());
                itemObj.put("discountedLineTotal", item.getDiscountedLineTotal());
                itemObj.put("effectiveLineTotal", item.getEffectiveLineTotal());
                
                JSONArray segmentsArray = new JSONArray();
                for (String segment : item.getCategorySegments()) {
                    segmentsArray.put(segment);
                }
                itemObj.put("categorySegments", segmentsArray);
                itemObj.put("categoryRoot", item.getCategoryRoot());
                
                itemsArray.put(itemObj);
            }
            result.put("items", itemsArray);
            
            // Convert summary
            JSONObject summaryObj = new JSONObject();
            com.dengage.sdk.domain.inappmessage.model.CartSummary summary = cart.getSummary();
            summaryObj.put("currency", summary.getCurrency());
            summaryObj.put("updatedAt", summary.getUpdatedAt());
            summaryObj.put("linesCount", summary.getLinesCount());
            summaryObj.put("itemsCount", summary.getItemsCount());
            summaryObj.put("subtotal", summary.getSubtotal());
            summaryObj.put("discountedSubtotal", summary.getDiscountedSubtotal());
            summaryObj.put("effectiveSubtotal", summary.getEffectiveSubtotal());
            summaryObj.put("anyDiscounted", summary.getAnyDiscounted());
            summaryObj.put("allDiscounted", summary.getAllDiscounted());
            summaryObj.put("minPrice", summary.getMinPrice());
            summaryObj.put("maxPrice", summary.getMaxPrice());
            summaryObj.put("minEffectivePrice", summary.getMinEffectivePrice());
            summaryObj.put("maxEffectivePrice", summary.getMaxEffectivePrice());
            
            JSONObject categoriesObj = new JSONObject();
            for (String key : summary.getCategories().keySet()) {
                categoriesObj.put(key, summary.getCategories().get(key));
            }
            summaryObj.put("categories", categoriesObj);
            
            result.put("summary", summaryObj);
            callbackContext.success(result);
        } catch (Exception e) {
            callbackContext.error(e.getMessage());
        }
    }

    private void getSdkParameters(CallbackContext callbackContext) {
        try {
            Object sdkParams = Dengage.INSTANCE.getSdkParameters();
            if (sdkParams != null) {
                // Use reflection to access fields
                Class<?> sdkParamsClass = sdkParams.getClass();
                JSONObject result = new JSONObject();
                
                try {
                    java.lang.reflect.Method getAppId = sdkParamsClass.getMethod("getAppId");
                    result.put("appId", getAppId.invoke(sdkParams));
                } catch (Exception e) {}
                
                try {
                    java.lang.reflect.Method getAccountId = sdkParamsClass.getMethod("getAccountId");
                    Object accountId = getAccountId.invoke(sdkParams);
                    if (accountId != null) {
                        result.put("accountId", accountId);
                    }
                } catch (Exception e) {}
                
                try {
                    java.lang.reflect.Method getAccountName = sdkParamsClass.getMethod("getAccountName");
                    result.put("accountName", getAccountName.invoke(sdkParams));
                } catch (Exception e) {}
                
                try {
                    java.lang.reflect.Method getEventsEnabled = sdkParamsClass.getMethod("getEventsEnabled");
                    result.put("eventsEnabled", getEventsEnabled.invoke(sdkParams));
                } catch (Exception e) {}
                
                try {
                    java.lang.reflect.Method getInboxEnabled = sdkParamsClass.getMethod("getInboxEnabled");
                    Object inboxEnabled = getInboxEnabled.invoke(sdkParams);
                    result.put("inboxEnabled", inboxEnabled != null ? inboxEnabled : false);
                } catch (Exception e) {}
                
                try {
                    java.lang.reflect.Method getInAppEnabled = sdkParamsClass.getMethod("getInAppEnabled");
                    Object inAppEnabled = getInAppEnabled.invoke(sdkParams);
                    result.put("inAppEnabled", inAppEnabled != null ? inAppEnabled : false);
                } catch (Exception e) {}
                
                try {
                    java.lang.reflect.Method getSubscriptionEnabled = sdkParamsClass.getMethod("getSubscriptionEnabled");
                    Object subscriptionEnabled = getSubscriptionEnabled.invoke(sdkParams);
                    result.put("subscriptionEnabled", subscriptionEnabled != null ? subscriptionEnabled : false);
                } catch (Exception e) {}
                
                try {
                    java.lang.reflect.Method getInAppFetchIntervalInMin = sdkParamsClass.getMethod("getInAppFetchIntervalInMin");
                    Object interval = getInAppFetchIntervalInMin.invoke(sdkParams);
                    result.put("inAppFetchIntervalInMin", interval != null ? interval : 0);
                } catch (Exception e) {}
                
                try {
                    java.lang.reflect.Method getExpiredMessagesFetchIntervalInMin = sdkParamsClass.getMethod("getExpiredMessagesFetchIntervalInMin");
                    Object expiredInterval = getExpiredMessagesFetchIntervalInMin.invoke(sdkParams);
                    result.put("expiredMessagesFetchIntervalInMin", expiredInterval != null ? expiredInterval : 0);
                } catch (Exception e) {}
                
                try {
                    java.lang.reflect.Method getInAppMinSecBetweenMessages = sdkParamsClass.getMethod("getInAppMinSecBetweenMessages");
                    Object minSec = getInAppMinSecBetweenMessages.invoke(sdkParams);
                    result.put("inAppMinSecBetweenMessages", minSec != null ? minSec : 0);
                } catch (Exception e) {}
                
                try {
                    java.lang.reflect.Method getLastFetchTimeInMillis = sdkParamsClass.getMethod("getLastFetchTimeInMillis");
                    result.put("lastFetchTimeInMillis", getLastFetchTimeInMillis.invoke(sdkParams));
                } catch (Exception e) {}
                
                try {
                    java.lang.reflect.Method getAppTrackingEnabled = sdkParamsClass.getMethod("getAppTrackingEnabled");
                    result.put("appTrackingEnabled", getAppTrackingEnabled.invoke(sdkParams));
                } catch (Exception e) {}
                
                try {
                    java.lang.reflect.Method getRealTimeInAppEnabled = sdkParamsClass.getMethod("getRealTimeInAppEnabled");
                    Object realTimeEnabled = getRealTimeInAppEnabled.invoke(sdkParams);
                    result.put("realTimeInAppEnabled", realTimeEnabled != null ? realTimeEnabled : false);
                } catch (Exception e) {}
                
                try {
                    java.lang.reflect.Method getRealTimeInAppFetchIntervalInMinutes = sdkParamsClass.getMethod("getRealTimeInAppFetchIntervalInMinutes");
                    Object realTimeInterval = getRealTimeInAppFetchIntervalInMinutes.invoke(sdkParams);
                    result.put("realTimeInAppFetchIntervalInMinutes", realTimeInterval != null ? realTimeInterval : 0);
                } catch (Exception e) {}
                
                try {
                    java.lang.reflect.Method getRealTimeInAppSessionTimeoutMinutes = sdkParamsClass.getMethod("getRealTimeInAppSessionTimeoutMinutes");
                    Object sessionTimeout = getRealTimeInAppSessionTimeoutMinutes.invoke(sdkParams);
                    result.put("realTimeInAppSessionTimeoutMinutes", sessionTimeout != null ? sessionTimeout : 0);
                } catch (Exception e) {}
                
                try {
                    java.lang.reflect.Method getSurveyCheckEndpoint = sdkParamsClass.getMethod("getSurveyCheckEndpoint");
                    result.put("surveyCheckEndpoint", getSurveyCheckEndpoint.invoke(sdkParams));
                } catch (Exception e) {}
                
                try {
                    java.lang.reflect.Method getDebugDeviceIds = sdkParamsClass.getMethod("getDebugDeviceIds");
                    Object debugIds = getDebugDeviceIds.invoke(sdkParams);
                    if (debugIds != null && debugIds instanceof List) {
                        JSONArray debugIdsArray = new JSONArray();
                        for (Object id : (List<?>) debugIds) {
                            debugIdsArray.put(id.toString());
                        }
                        result.put("debugDeviceIds", debugIdsArray);
                    }
                } catch (Exception e) {}
                
                callbackContext.success(result);
            } else {
                callbackContext.success((String) null);
            }
        } catch (Exception e) {
            callbackContext.error(e.getMessage());
        }
    }

    private void getDeviceId(CallbackContext callbackContext) {
        try {
            String deviceId = Dengage.INSTANCE.getSubscription().getDeviceId();
            Log.d("DengageCR", "getDeviceId called - Device ID: " + (deviceId != null ? deviceId : "null"));
            if (deviceId != null && !deviceId.isEmpty()) {
                callbackContext.success(deviceId);
            } else {
                Log.w("DengageCR", "Unable to get device ID - deviceId is null or empty");
                callbackContext.error("Unable to get device ID");
            }
        } catch (Exception e) {
            Log.e("DengageCR", "Error getting device ID: " + e.getMessage(), e);
            callbackContext.error(e.getMessage());
        }
    }

    private void getSdkVersion(CallbackContext callbackContext) {
        try {
            String version = Dengage.INSTANCE.getSubscription().getSdkVersion();
            Log.d("DengageCR", "getSdkVersion called - SDK Version: " + (version != null ? version : "null"));
            if (version != null) {
                callbackContext.success(version);
            } else {
                callbackContext.success("");
            }
        } catch (Exception e) {
            Log.e("DengageCR", "Error getting SDK version: " + e.getMessage(), e);
            callbackContext.error(e.getMessage());
        }
    }

    private void requestLocationPermissions(CallbackContext callbackContext) {
        try {
            android.app.Activity activity = this.cordova.getActivity();
            if (activity != null) {
                Class<?> clazz = Class.forName("com.dengage.geofence.DengageGeofence");
                Object instance = clazz.getField("INSTANCE").get(null);
                java.lang.reflect.Method method = clazz.getMethod("requestLocationPermissions", android.app.Activity.class);
                method.invoke(instance, activity);
                callbackContext.success();
            } else {
                callbackContext.error("Activity is null");
            }
        } catch (ClassNotFoundException e) {
            callbackContext.error("DengageGeofence library could not be found");
        } catch (Exception e) {
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

class InAppReceiver extends InAppBroadcastReceiver {
    CallbackContext notifyCallbackContext = null;

    InAppReceiver(CallbackContext notifyCallbackContext) {
        this.notifyCallbackContext = notifyCallbackContext;
    }

    @Override
    public void onReceive(Context context, Intent intent) {
        try {
            if (notifyCallbackContext != null) {
                String json = new Gson().toJson(intent.getExtras().getString("targetUrl"));
                JsonParser parser = new JsonParser();
                JsonElement jsonElement = parser.parse(json);
                JsonObject jsonObject = jsonElement.getAsJsonObject();
                jsonObject.addProperty("eventType", "INAPP_CLICK_LINK");


                PluginResult result = new PluginResult(PluginResult.Status.OK, jsonObject.toString());
                result.setKeepCallback(true);
                notifyCallbackContext.sendPluginResult(result);
            }
        }
        catch (Exception e){}
    }


}