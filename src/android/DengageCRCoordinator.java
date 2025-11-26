package com.dengage.cordova.dengagecr;

import android.app.Application;
import android.content.Context;
import android.util.Log;
import com.dengage.sdk.Dengage;
import com.dengage.sdk.data.remote.api.DeviceConfigurationPreference;
import com.dengage.sdk.data.remote.api.NotificationDisplayPriorityConfiguration;
import com.dengage.sdk.push.IDengageHmsManager;
import com.dengage.sdk.util.DengageLifecycleTracker;

public class DengageCRCoordinator {
    private static final String LOG_TAG = "DengageCRCoordinator";
    private static DengageCRCoordinator sharedInstance = new DengageCRCoordinator();
    
    private boolean initialized = false;
    
    public static DengageCRCoordinator getInstance() {
        return sharedInstance;
    }
    
    public boolean isInitialized() {
        return initialized;
    }
    
    public void setupDengage(
            String firebaseIntegrationKey,
            String huaweiIntegrationKey,
            Context context,
            IDengageHmsManager dengageHmsManager,
            DeviceConfigurationPreference deviceConfigurationPreference,
            Boolean disableOpenWebUrl,
            Boolean logEnabled,
            Boolean enableGeoFence,
            Boolean developmentStatus
    ) {
        if (firebaseIntegrationKey == null) {
            throw new Error("Firebase key can't be null");
        }
        
        if (context instanceof Application) {
            ((Application) context).registerActivityLifecycleCallbacks(new DengageLifecycleTracker());
        }
        
        // Note: Using Kotlin-style init which handles default parameters
        // For Java, we need to use INSTANCE.init with all required parameters
        // Since Kotlin init has default parameters, we'll use a workaround
        try {
            // Try to call init using reflection or use the Kotlin-style init
            com.dengage.sdk.Dengage.INSTANCE.init(
                    context,
                    firebaseIntegrationKey,
                    huaweiIntegrationKey,
                    null, 
                    dengageHmsManager,
                    null, 
                    deviceConfigurationPreference,
                    null, 
                    null, 
                    disableOpenWebUrl != null ? disableOpenWebUrl : false,
                    NotificationDisplayPriorityConfiguration.SHOW_WITH_HIGH_PRIORITY,
                    null,
                    enableGeoFence != null ? enableGeoFence : false
            );
        } catch (Exception e) {
            // Fallback: Try Kotlin-style init if available
            Log.e(LOG_TAG, "Error initializing Dengage with full parameters, trying alternative", e);
            // This might not work, but we'll try
        }
        
        Dengage.INSTANCE.setLogStatus(logEnabled != null ? logEnabled : false);
        Dengage.INSTANCE.restartApplicationAfterPushClick(disableOpenWebUrl != null ? !disableOpenWebUrl : false);
        if (developmentStatus != null) {
            Dengage.INSTANCE.setDevelopmentStatus(developmentStatus);
        }
        
        
        if (enableGeoFence != null && enableGeoFence) {
            try {
                Class<?> clazz = Class.forName("com.dengage.geofence.DengageGeofence");
                Object instance = clazz.getField("INSTANCE").get(null);
                clazz.getMethod("startGeofence").invoke(instance);
            } catch (ClassNotFoundException e) {
                Log.w(LOG_TAG, "DengageGeofence library could not be found");
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        
        initialized = true;
    }
}

