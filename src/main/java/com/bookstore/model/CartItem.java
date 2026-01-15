package com.bookstore.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class CartItem {
    private int id;
    private int cartId;
    private int bookId;
    private int quantity;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // JOIN fields for display
    private String bookTitle;
    private BigDecimal bookPrice;
    private String bookCoverImage;

    public CartItem() {}

    public CartItem(int id, int cartId, int bookId, int quantity) {
        this.id = id;
        this.cartId = cartId;
        this.bookId = bookId;
        this.quantity = quantity;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getCartId() { return cartId; }
    public void setCartId(int cartId) { this.cartId = cartId; }

    public int getBookId() { return bookId; }
    public void setBookId(int bookId) { this.bookId = bookId; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }

    // JOIN getters/setters
    public String getBookTitle() { return bookTitle; }
    public void setBookTitle(String bookTitle) { this.bookTitle = bookTitle; }

    public BigDecimal getBookPrice() { return bookPrice; }
    public void setBookPrice(BigDecimal bookPrice) { this.bookPrice = bookPrice; }

    public String getBookCoverImage() { return bookCoverImage; }
    public void setBookCoverImage(String bookCoverImage) { this.bookCoverImage = bookCoverImage; }

    // Calculated field
    public BigDecimal getSubtotal() {
        if (bookPrice == null) return BigDecimal.ZERO;
        return bookPrice.multiply(BigDecimal.valueOf(quantity));
    }
}
