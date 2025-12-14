package com.bookstore.listener;

import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

import java.sql.Connection;
import java.sql.DriverManager;

@WebListener
public class DBContextListener implements ServletContextListener {

    private Connection connection;

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        try {
            Class.forName("org.postgresql.Driver");

            connection = DriverManager.getConnection(
            		"jdbc:postgresql://localhost:5432/bookstore",
                    "postgres",
                    "backenddev"
            );

            ServletContext context = sce.getServletContext();
            context.setAttribute("DBConnection", connection);

            System.out.println(">>> Database connected and stored in ServletContext.");

        } catch (Exception e) {
        	System.out.println(">>> Cannot connect to database. Reason:");
        	e.printStackTrace();
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        try {
            if (connection != null) {
                connection.close();
            }
            System.out.println(">>> Database connection closed.");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
