package com.bookstore.model;

import java.io.Serializable;

/**
 * Author Model Class
 * Represents a book author
 */
public class Author implements Serializable {
    private static final long serialVersionUID = 1L;
    
    private int id;
    private String name;
    private String country;
    
    // Constructors
    public Author() {}
    
    public Author(int id, String name, String country) {
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
        return "Author{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", country='" + country + '\'' +
                '}';
    }
}

