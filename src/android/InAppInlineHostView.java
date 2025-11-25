package com.dengage.cordova.dengagecr;

import android.app.Activity;
import android.content.Context;
import android.widget.FrameLayout;

import com.dengage.sdk.Dengage;
import com.dengage.sdk.ui.inappmessage.InAppInlineElement;

import java.util.HashMap;
import java.util.Map;

public class InAppInlineHostView extends FrameLayout {

    private final InAppInlineElement inlineElement;
    private boolean hasRendered = false;

    public InAppInlineHostView(Context context) {
        super(context);
        setClipToPadding(true);
        setClipChildren(true);
        setBackgroundColor(0);

        inlineElement = new InAppInlineElement(context);
        inlineElement.setLayoutParams(new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT));
        addView(inlineElement);
    }

    void showInline(String propertyId, String screenName, Map<String, String> customParams, Activity activity) {
        if (hasRendered || activity == null) {
            return;
        }

        if (propertyId == null || propertyId.isEmpty() || screenName == null || screenName.isEmpty()) {
            return;
        }

         Dengage.INSTANCE.showInlineInApp(propertyId,inlineElement,activity, (HashMap<String, String>) customParams,screenName,false);
        hasRendered = true;
    }
}

