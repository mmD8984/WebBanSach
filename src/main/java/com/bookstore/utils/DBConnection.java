//package com.bookstore.utils;
//
//import java.sql.Connection;
//import java.sql.DriverManager;
//
//public class DBConnection {
//
//    private static final String URL = "jdbc:postgresql://localhost:5432/bookstore";
//    private static final String USER = "postgres";
//    private static final String PASSWORD = "backenddev";
//
//    public static Connection getConnection() {
//        Connection conn = null;
//        try {
//            Class.forName("org.postgresql.Driver");
//            conn = DriverManager.getConnection(URL, USER, PASSWORD);
//            System.out.println("Kết nối DB thành công!");
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//        return conn;
//    }
//}
