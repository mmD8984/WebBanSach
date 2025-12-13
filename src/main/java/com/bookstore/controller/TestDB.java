package com.bookstore.controller;

import java.sql.Connection;
import java.sql.DriverManager;

public class TestDB {
    public static void main(String[] args) {
        try {
            Class.forName("org.postgresql.Driver");
            Connection c = DriverManager.getConnection(
                "jdbc:postgresql://localhost:5432/bookstore",
                "postgres",
                "backenddev"
            );
            System.out.println("OK!");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}

