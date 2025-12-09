package com.bookstore.model;

import java.io.Serializable;

/**
 * OrderItem Model Class
 * Represents an item in an order
 */
public class OrderItem implements Serializable {
    private static final long serialVersionUID = 1L;
    
    private int id;
    private int orderId;
    private int bookId;
    private String bookTitle;
    private int quantity;
    private long price;
    
    // Constructors
    public OrderItem() {}
    
    public OrderItem(int orderId, int bookId, int quantity, long price) {
        this.orderId = orderId;
        this.bookId = bookId;
        this.quantity = quantity;
        this.price = price;
    }
    
    // Getters and Setters
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public int getOrderId() {
        return orderId;
    }
    
    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }
    
    public int getBookId() {
        return bookId;
    }
    
    public void setBookId(int bookId) {
        this.bookId = bookId;
    }
    
    public String getBookTitle() {
        return bookTitle;
    }
    
    public void setBookTitle(String bookTitle) {
        this.bookTitle = bookTitle;
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
    
    public long getUnitPrice() {
        return price;
    }
    
    public long getTotal() {
        return price * quantity;
    }
    
    @Override
    public String toString() {
        return "OrderItem{" +
                "id=" + id +
                ", orderId=" + orderId +
                ", bookId=" + bookId +
                ", quantity=" + quantity +
                ", price=" + price +
                '}';
    }
}

