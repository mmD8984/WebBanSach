package com.bookstore.model;

import java.io.Serializable;

/**
 * Book Model Class
 * Represents a book product
 */
public class Book implements Serializable {
    private static final long serialVersionUID = 1L;
    
    private int id;
    private String title;
    private int authorId;
    private String authorName;
    private int publisherId;
    private String publisherName;
    private int categoryId;
    private String categoryName;
    private long price;
    private long originalPrice;
    private int discount;
    private int pages;
    private int year;
    private double rating;
    private int reviews;
    private String description;
    private String image;
    private String status;
    private String format;
    private String size;
    private int stock;
    private boolean featured;
    private boolean bestseller;
    private boolean isNew;
    
    // Constructors
    public Book() {}
    
    public Book(int id, String title, String authorName, int categoryId, long price, String image) {
        this.id = id;
        this.title = title;
        this.authorName = authorName;
        this.categoryId = categoryId;
        this.price = price;
        this.image = image;
    }
    
    // Getters and Setters
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public String getTitle() {
        return title;
    }
    
    public void setTitle(String title) {
        this.title = title;
    }
    
    public int getAuthorId() {
        return authorId;
    }
    
    public void setAuthorId(int authorId) {
        this.authorId = authorId;
    }
    
    public String getAuthorName() {
        return authorName;
    }
    
    public void setAuthorName(String authorName) {
        this.authorName = authorName;
    }
    
    public int getPublisherId() {
        return publisherId;
    }
    
    public void setPublisherId(int publisherId) {
        this.publisherId = publisherId;
    }
    
    public String getPublisherName() {
        return publisherName;
    }
    
    public void setPublisherName(String publisherName) {
        this.publisherName = publisherName;
    }
    
    public int getCategoryId() {
        return categoryId;
    }
    
    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }
    
    public String getCategoryName() {
        return categoryName;
    }
    
    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }
    
    public long getPrice() {
        return price;
    }
    
    public void setPrice(long price) {
        this.price = price;
    }
    
    public long getOriginalPrice() {
        return originalPrice;
    }
    
    public void setOriginalPrice(long originalPrice) {
        this.originalPrice = originalPrice;
    }
    
    public int getDiscount() {
        return discount;
    }
    
    public void setDiscount(int discount) {
        this.discount = discount;
    }
    
    public int getPages() {
        return pages;
    }
    
    public void setPages(int pages) {
        this.pages = pages;
    }
    
    public int getYear() {
        return year;
    }
    
    public void setYear(int year) {
        this.year = year;
    }
    
    public double getRating() {
        return rating;
    }
    
    public void setRating(double rating) {
        this.rating = rating;
    }
    
    public int getReviews() {
        return reviews;
    }
    
    public void setReviews(int reviews) {
        this.reviews = reviews;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public String getImage() {
        return image;
    }
    
    public void setImage(String image) {
        this.image = image;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public String getFormat() {
        return format;
    }
    
    public void setFormat(String format) {
        this.format = format;
    }
    
    public String getSize() {
        return size;
    }
    
    public void setSize(String size) {
        this.size = size;
    }
    
    public int getStock() {
        return stock;
    }
    
    public void setStock(int stock) {
        this.stock = stock;
    }
    
    public boolean isFeatured() {
        return featured;
    }
    
    public void setFeatured(boolean featured) {
        this.featured = featured;
    }
    
    public boolean isBestseller() {
        return bestseller;
    }
    
    public void setBestseller(boolean bestseller) {
        this.bestseller = bestseller;
    }
    
    public boolean isNew() {
        return isNew;
    }
    
    public void setNew(boolean isNew) {
        this.isNew = isNew;
    }
    
    @Override
    public String toString() {
        return "Book{" +
                "id=" + id +
                ", title='" + title + '\'' +
                ", author='" + authorName + '\'' +
                ", price=" + price +
                '}';
    }
}

