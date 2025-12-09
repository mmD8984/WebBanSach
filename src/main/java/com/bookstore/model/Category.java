package com.bookstore.model;

import java.io.Serializable;

/**
 * Category Model Class
 * Represents a book category
 */
public class Category implements Serializable {
    private static final long serialVersionUID = 1L;
    
    private int id;
    private String name;
    private String icon;
    private String description;
    private int count;
    
    // Constructors
    public Category() {}
    
    public Category(int id, String name, String icon, String description) {
        this.id = id;
        this.name = name;
        this.icon = icon;
        this.description = description;
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
    
    public String getIcon() {
        return icon;
    }
    
    public void setIcon(String icon) {
        this.icon = icon;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public int getCount() {
        return count;
    }
    
    public void setCount(int count) {
        this.count = count;
    }
    
    @Override
    public String toString() {
        return "Category{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", icon='" + icon + '\'' +
                ", count=" + count +
                '}';
    }
}

