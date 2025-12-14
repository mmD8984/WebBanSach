package com.bookstore.model;

import java.math.BigDecimal;

public class Book {
    private int id;
    private String title;
    private String description;
    private BigDecimal price;
    private int stockQuantity;
    private String coverImage;
    private int categoryId;
    private int publisherId;
    private boolean active;

    private String categoryName;
    private String publisherName;
    private String authorNames;
    
    public Book() {}
    
    public Book(int id, String title, String description,
            BigDecimal price, int stockQuantity, String coverImage,
            Integer categoryId, Integer publisherId, boolean active,
            String categoryName, String publisherName, String authorNames) {
    	this.id = id;
        this.title = title;
        this.description = description;
        this.price = price;
        this.stockQuantity = stockQuantity;
        this.coverImage = coverImage;
        this.categoryId = categoryId;
        this.publisherId = publisherId;
        this.active = active;
        this.categoryName = categoryName;
        this.publisherName = publisherName;
        this.authorNames = authorNames;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }

    public int getStockQuantity() { return stockQuantity; }
    public void setStockQuantity(int stockQuantity) { this.stockQuantity = stockQuantity; }
    
    public String getCoverImage() { return coverImage; }
    public void setCoverImage(String coverImage) { this.coverImage = coverImage; }
    
    public Integer getCategoryId() { return categoryId; }
    public void setCategoryId(Integer categoryId) { this.categoryId = categoryId; }
    
    public Integer getPublisherId() { return publisherId; }
    public void setPublisherId(Integer publisherId) { this.publisherId = publisherId; }

    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }

    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }

    public String getPublisherName() { return publisherName; }
    public void setPublisherName(String publisherName) { this.publisherName = publisherName; }

    public String getAuthorNames() { return authorNames; }
    public void setAuthorNames(String authorNames) { this.authorNames = authorNames; }
}
