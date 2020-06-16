package com.heyteago.udesk;

import android.content.Context;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;

import cn.udesk.UdeskSDKManager;
import cn.udesk.config.UdeskConfig;
import udesk.core.UdeskConst;

public class ReactNativeUdeskModule extends ReactContextBaseJavaModule {

    private final ReactApplicationContext reactContext;
    private String sdkToken; // 用户唯一的标识

    public ReactNativeUdeskModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
    }

    @Override
    public String getName() {
        return "ReactNativeUdesk";
    }

    @ReactMethod
    public void init(@Nullable ReadableMap initParam, Promise promise) {
        try {
            UdeskSDKManager.getInstance().initApiKey(
                    getCurrentActivity(),
                    getReadableMapString(initParam, "domain", ""),
                    getReadableMapString(initParam, "appKey", ""),
                    getReadableMapString(initParam, "appId", "")
            );
            sdkToken = getReadableMapString(initParam, "sdkToken", null);
            promise.resolve(null);
        } catch (Exception e) {
            promise.reject(new Throwable(e.getMessage()));
        }
    }

    @ReactMethod
    public void startChat(@Nullable ReadableMap userInfo, Promise promise) {
        try {
            // 默认系统字段是Udesk已定义好的字段，开发者可以直接传入这些用户信息，供客服查看。
            Map<String, String> info = new HashMap<>();
            info.put(UdeskConst.UdeskUserInfo.USER_SDK_TOKEN, sdkToken);
            //以下信息是可选
            if (userInfo != null) {
                info.put(UdeskConst.UdeskUserInfo.NICK_NAME, getReadableMapString(userInfo, "nickename", ""));
                info.put(UdeskConst.UdeskUserInfo.EMAIL, getReadableMapString(userInfo, "email", ""));
                info.put(UdeskConst.UdeskUserInfo.CELLPHONE, getReadableMapString(userInfo, "phone", ""));
                info.put(UdeskConst.UdeskUserInfo.DESCRIPTION, getReadableMapString(userInfo, "description", ""));
            }
            // info.put(UdeskConst.UdeskUserInfo.CUSTOMER_TOKEN, custom_token);
            // 只设置用户基本信息的配置
            UdeskConfig.Builder builder = new UdeskConfig.Builder();
            builder.setDefaultUserInfo(info);
            UdeskSDKManager.getInstance().entryChat(getApplicationContext(), builder.build(), sdkToken);
            promise.resolve(null);
        } catch (Exception e) {
            promise.reject(new Throwable(e.getMessage()));
        }
    }

    private Context getApplicationContext() {
        return getCurrentActivity().getApplicationContext();
    }

    private String getReadableMapString(@Nullable ReadableMap map, @Nonnull String key, String defaultValue) {
        try {
            if (map == null) {
                return defaultValue;
            }
            String value = map.getString(key);
            return value == null ? defaultValue : value;
        } catch (Exception e) {
            return defaultValue;
        }
    }
}
