package com.bookstore.model;

import java.io.Serializable;

/**
 * Publisher Model Class
 * Represents a book publisher
 */
public class Publisher implements Serializable {
    private static final long serialVersionUID = 1L;
    
    private int id;
    private String name;
    private String country;
    
    // Constructors
    public Publisher() {}
    
    public Publisher(int id, String name, String country) {
        this.id = id;
        this.name = name;
        this.country = country;
    }
    
    // Getters and Setters
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public String getCountry() {
        return country;
    }
    
    public void setCountry(String country) {
        this.country = country;
    }
    
    @Override
    public String toString() {
        return "Publisher{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", country='" + country + '\'' +
                '}';
    }
}

