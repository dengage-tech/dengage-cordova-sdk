package com.dengage.cordova.dengagecr;

import android.app.Activity;
import android.content.Context;
import android.widget.FrameLayout;

import com.dengage.sdk.Dengage;
import com.dengage.sdk.ui.story.StoriesListView;

import java.util.HashMap;
import java.util.Map;

public class StoriesListHostView extends FrameLayout {

    private final StoriesListView storiesListView;
    private boolean hasRendered = false;

    public StoriesListHostView(Context context) {
        super(context);
        setClipToPadding(true);
        setClipChildren(true);
        setBackgroundColor(0);

        storiesListView = new StoriesListView(context);
        addView(storiesListView, new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT));
    }

    void showStories(String propertyId, String screenName, Map<String, String> customParams, Activity activity) {
        if (hasRendered || activity == null || propertyId == null || propertyId.isEmpty() || screenName == null || screenName.isEmpty()) {
            return;
        }

        final HashMap<String, String> paramsCopy = customParams != null ? new HashMap<>(customParams) : null;
        Dengage.INSTANCE.showStoriesList(propertyId, storiesListView, activity, paramsCopy, screenName);
        hasRendered = true;
    }
}




