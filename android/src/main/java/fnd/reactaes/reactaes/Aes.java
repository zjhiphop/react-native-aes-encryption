package fnd.reactaes.reactaes;

import java.io.DataInputStream;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.math.BigInteger;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.util.Random;
import java.util.Arrays;

import android.util.Log;
import android.util.Base64;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;


public class Aes {

    public static class EncInfo {
        byte[] iV;
        byte[] cipherBytes;
        byte[] key;
        byte[] all;
        String ivHex;

        public EncInfo() {
        }
    }

    public static byte[] encrypt(String message, String keyHex) throws IllegalBlockSizeException, BadPaddingException, NoSuchAlgorithmException, NoSuchPaddingException, InvalidKeyException, InvalidAlgorithmParameterException, UnsupportedEncodingException {
        Random rnd = new Random(232354236);
        byte[] key_raw1 = new BigInteger(keyHex, 16).toByteArray();
        byte[] key_raw = new byte[16];
       if( key_raw1.length > 16){
           System.arraycopy(key_raw1,1,key_raw,0,16);
       }else{

           System.arraycopy(key_raw1,0,key_raw,0,16);
       }

        SecretKeySpec skeySpec = new SecretKeySpec(key_raw, "AES");
        byte[] IV = new byte[128 / 8];
        rnd.nextBytes(IV);
        IvParameterSpec IVSpec = new IvParameterSpec(IV);
        Cipher aESCipher = Cipher.getInstance("AES/CFB/NoPadding");
        aESCipher.init(Cipher.ENCRYPT_MODE, skeySpec, IVSpec);
        byte[] clearTextBytes = stringToBytesASCII(message);
        byte[] cipherBytes = aESCipher.doFinal(clearTextBytes);
        byte[] all = new byte[IV.length + cipherBytes.length];
        System.arraycopy(IV, 0, all, 0, IV.length);
        System.arraycopy(cipherBytes, 0, all, IV.length, cipherBytes.length);

        return all;

    }


    public static byte[] stringToBytesASCII(String str) {
        char[] buffer = str.toCharArray();
        byte[] b = new byte[buffer.length];
        for (int i = 0; i < b.length; i++) {
            b[i] = (byte) buffer[i];
        }
        return b;
    }

    public static String decrypt(byte[] data, String keyHex,byte[] IV) throws NoSuchAlgorithmException, NoSuchPaddingException, InvalidKeyException, InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException {
        byte[] key_raw1 = new BigInteger(keyHex, 16).toByteArray();
        byte[] key_raw = new byte[16];
        if( key_raw1.length > 16){
            System.arraycopy(key_raw1,1,key_raw,0,16);
        }else{
            System.arraycopy(key_raw1,0,key_raw,0,16);
        }
        IvParameterSpec IVSpec = new IvParameterSpec(IV);
        SecretKeySpec skeySpec = new SecretKeySpec(key_raw, "AES");
        Cipher aESCipher = Cipher.getInstance("AES/CFB/NoPadding");

        aESCipher.init(Cipher.DECRYPT_MODE, skeySpec, IVSpec);
        byte[] nonEncBytes = aESCipher.doFinal(data);


        try {
            return new String(nonEncBytes, "ASCII");
        } catch (UnsupportedEncodingException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        return null;

    }



    public interface Constants {
        String LOG = "enc";
    }

}


