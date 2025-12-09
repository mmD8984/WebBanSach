package com.bookstore.util;

import java.security.MessageDigest;
import java.security.SecureRandom;
import java.util.Base64;

/**
 * Password Utility Class
 * Provides methods for password hashing and verification using SHA-256
 */
public class PasswordUtil {
    
    /**
     * Hash password using SHA-256
     * @param password Plain text password
     * @return Hashed password (hex string)
     */
    public static String hash(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] messageDigest = md.digest(password.getBytes());
            
            // Convert to hex string
            StringBuilder hexString = new StringBuilder();
            for (byte b : messageDigest) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) {
                    hexString.append('0');
                }
                hexString.append(hex);
            }
            return hexString.toString();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    
    /**
     * Verify password by comparing with hashed version
     * @param password Plain text password to verify
     * @param hashedPassword Stored hashed password
     * @return True if password matches
     */
    public static boolean verify(String password, String hashedPassword) {
        if (password == null || hashedPassword == null) {
            return false;
        }
        String hash = hash(password);
        return hash != null && hash.equals(hashedPassword);
    }
    
    /**
     * Generate random password (for password reset)
     * @param length Length of password
     * @return Random password
     */
    public static String generateRandomPassword(int length) {
        SecureRandom random = new SecureRandom();
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
        StringBuilder password = new StringBuilder();
        for (int i = 0; i < length; i++) {
            password.append(chars.charAt(random.nextInt(chars.length())));
        }
        return password.toString();
    }
}

