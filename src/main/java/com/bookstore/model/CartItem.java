package com.bookstore.model;

import java.io.Serializable;

/**
 * CartItem Model Class
 * Represents an item in the shopping cart
 */
public class CartItem implements Serializable {
    private static final long serialVersionUID = 1L;
    
    private int id;
    private Book book;
    private int quantity;
    private long price;
    
    // Constructors
    public CartItem() {}
    
    public CartItem(Book book, int quantity) {
        this.book = book;
        this.quantity = quantity;
        this.price = book.getPrice();
        this.id = book.getId();
    }
    
    // Getters and Setters
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public Book getBook() {
        return book;
    }
    
    public void setBook(Book book) {
        this.book = book;
    }
    
    public int getQuantity() {
        return quantity;
    }
    
    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
    
    public long getPrice() {
        return price;
    }
    
    public void setPrice(long price) {
        this.price = price;
    }
    
    public long getTotal() {
        return price * quantity;
    }
    
    @Override
    public String toString() {
        return "CartItem{" +
                "id=" + id +
                ", book=" + book.getTitle() +
                ", quantity=" + quantity +
                ", price=" + price +
                '}';
    }
}

