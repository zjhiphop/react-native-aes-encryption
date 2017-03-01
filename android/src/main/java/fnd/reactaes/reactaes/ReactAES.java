package fnd.reactaes.reactaes;

import com.facebook.react.bridge.NativeModule;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.bridge.WritableNativeMap;
import com.facebook.react.bridge.ReactMethod;

import android.util.Base64;
import android.util.Log;

import java.lang.String;
import java.math.BigInteger;

/**
 * Created by daiyungui on 16/6/19.
 */
public class ReactAES extends ReactContextBaseJavaModule {
    public ReactAES(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @Override
    public String getName() {
        return "ReactAES";
    }


    @ReactMethod
    public void encrypt(final String plainText, final String key, Promise promise) {
        try {
            byte[] all = Aes.encrypt(plainText, key); //encrypt

            promise.resolve(Base64.encodeToString(all, Base64.DEFAULT));
        } catch (Exception e) {
            promise.reject("-1", e);
        }
    }

    @ReactMethod
    public void decrypt(final String encryptedText, final String key, final String iv, Promise promise) {
        try {
            String plainText =  Aes.decrypt(Base64.decode(encryptedText, Base64.DEFAULT),key,Base64.decode(iv, Base64.DEFAULT));
            promise.resolve(plainText);
        } catch (Exception e) {
            promise.reject("-1", e);
        }
    }

}

