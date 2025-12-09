package com.bookstore.util;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import javax.servlet.http.HttpServletRequest;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.util.*;

/**
 * VNPAY Payment Gateway Configuration
 * Provides configuration and utility methods for VNPAY integration
 */
public class VNPayConfig {
    
    // VNPAY Configuration
    // Credentials from VNPAY Sandbox registration (laga2134@gmail.com)
    // Received from VNPAY email on 06/12/2025 16:08
    public static final String vnp_TmnCode = "5ICQMMPN";
    public static final String vnp_HashSecret = "M1477CK4H75JBCWKSFY0GSF1W2FDZBXE";
    public static final String vnp_PayUrl = "https://sandbox.vnpayment.vn/paymentv2/vpcpay.html";
    public static final String vnp_ApiUrl = "https://sandbox.vnpayment.vn/merchant_webapi/api/transaction";
    public static final String vnp_Version = "2.1.0";
    
    // Return URL (Fix context path to match deployment)
    public static final String vnp_ReturnUrl = "http://localhost:8080/webbansach_war/vnpay/return";
    public static final String vnp_IpnUrl = "http://localhost:8080/webbansach_war/vnpay/ipn";
    
    /**
     * Generate HMACSHA512 checksum
     * @param key Secret key (VNPAY HashSecret)
     * @param data Data to hash
     * @return SHA512 hash
     */
    public static String hmacSHA512(String key, String data) {
        try {
            if (key == null) {
                key = "";
            }
            SecretKeySpec secretKeySpec = new SecretKeySpec(key.getBytes(StandardCharsets.UTF_8), "HmacSHA512");
            Mac mac = Mac.getInstance("HmacSHA512");
            mac.init(secretKeySpec);
            byte[] rawHmac = mac.doFinal(data.getBytes(StandardCharsets.UTF_8));
            StringBuilder hexString = new StringBuilder();
            for (byte b : rawHmac) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) {
                    hexString.append('0');
                }
                hexString.append(hex);
            }
            return hexString.toString();
        } catch (Exception e) {
            e.printStackTrace();
            return "";
        }
    }
    
    /**
     * Generate random number for vnp_TxnRef
     * @param length Length of random number
     * @return Random number as string
     */
    public static String getRandomNumber(int length) {
        Random random = new Random();
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < length; i++) {
            sb.append(random.nextInt(10));
        }
        return sb.toString();
    }
    
    /**
     * Get client IP address from request
     * @param request HTTP request
     * @return Client IP address
     */
    public static String getIpAddress(HttpServletRequest request) {
        String ipAdress;
        try {
            ipAdress = request.getHeader("X-FORWARDED-FOR");
            if (ipAdress == null) {
                ipAdress = request.getRemoteAddr();
            }
        } catch (Exception e) {
            ipAdress = "0.0.0.0";
        }
        return ipAdress;
    }
    
    /**
     * Build payment URL data - EXACTLY as per VNPAY sample code
     * Returns array: [0]=queryString, [1]=secureHash
     * @param params Parameter map
     * @return String array with query and hash
     */
    public static String[] buildPaymentData(Map<String, String> params) {
        List<String> fieldNames = new ArrayList<>(params.keySet());
        Collections.sort(fieldNames);
        StringBuilder hashData = new StringBuilder();
        StringBuilder query = new StringBuilder();
        
        Iterator<String> itr = fieldNames.iterator();
        while (itr.hasNext()) {
            String fieldName = itr.next();
            String fieldValue = params.get(fieldName);
            if ((fieldValue != null) && (fieldValue.length() > 0)) {
                try {
                    // Build hash data
                    hashData.append(fieldName);
                    hashData.append('=');
                    hashData.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));
                    // Build query
                    query.append(URLEncoder.encode(fieldName, StandardCharsets.US_ASCII.toString()));
                    query.append('=');
                    query.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));
                    if (itr.hasNext()) {
                        query.append('&');
                        hashData.append('&');
                    }
                } catch (UnsupportedEncodingException e) {
                    e.printStackTrace();
                }
            }
        }
        
        String vnp_SecureHash = hmacSHA512(vnp_HashSecret, hashData.toString());
        return new String[]{query.toString(), vnp_SecureHash};
    }
    
    /**
     * Hash all fields for verification - VNPAY standard method
     * @param params Parameter map
     * @return Hash string
     */
    public static String hashAllFields(Map<String, String> params) {
        List<String> fieldNames = new ArrayList<>(params.keySet());
        Collections.sort(fieldNames);
        StringBuilder hashData = new StringBuilder();
        
        Iterator<String> itr = fieldNames.iterator();
        while (itr.hasNext()) {
            String fieldName = itr.next();
            String fieldValue = params.get(fieldName);
            if ((fieldValue != null) && (fieldValue.length() > 0)) {
                try {
                    hashData.append(fieldName);
                    hashData.append('=');
                    hashData.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));
                    if (itr.hasNext()) {
                        hashData.append('&');
                    }
                } catch (UnsupportedEncodingException e) {
                    e.printStackTrace();
                }
            }
        }
        return hmacSHA512(vnp_HashSecret, hashData.toString());
    }
    
    /**
     * Verify checksum from request parameters
     * @param vnp_SecureHash Received hash
     * @param params Request parameters
     * @return True if valid
     */
    public static boolean verifyChecksum(String vnp_SecureHash, Map<String, String> params) {
        // Remove hash and hash type from params
        params.remove("vnp_SecureHash");
        params.remove("vnp_SecureHashType");
        
        String calculatedHash = hashAllFields(params);
        
        return calculatedHash.equalsIgnoreCase(vnp_SecureHash);
    }
    
    /**
     * Format amount for VNPAY (multiply by 100)
     * @param amount Amount in VND
     * @return Amount * 100
     */
    public static long formatAmount(long amount) {
        return amount * 100;
    }
    
    /**
     * Parse amount from VNPAY (divide by 100)
     * @param amount Amount from VNPAY
     * @return Amount in VND
     */
    public static long parseAmount(long amount) {
        return amount / 100;
    }
}

