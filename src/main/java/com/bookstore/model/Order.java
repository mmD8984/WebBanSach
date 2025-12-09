package com.bookstore.model;

import java.io.Serializable;
import java.time.LocalDateTime;
import java.util.List;

/**
 * Order Model Class
 * Represents a customer order
 */
public class Order implements Serializable {
    private static final long serialVersionUID = 1L;
    
    private int id;
    private int userId;
    private String fullname;
    private String phone;
    private String email;
    private String address;
    private String city;
    private String district;
    private String notes;
    private String shippingMethod;
    private String paymentMethod;
    private long total;
    private long shippingCost;
    private String status;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private List<OrderItem> items;
    
    // VNPAY Fields
    private String vnpTxnRef;
    private String vnpTransactionNo;
    private String paymentStatus;
    
    // Constructors
    public Order() {}
    
    public Order(int userId, String fullname, String phone, String email, String address) {
        this.userId = userId;
        this.fullname = fullname;
        this.phone = phone;
        this.email = email;
        this.address = address;
    }
    
    // Getters and Setters
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public int getUserId() {
        return userId;
    }
    
    public void setUserId(int userId) {
        this.userId = userId;
    }
    
    public String getFullname() {
        return fullname;
    }
    
    public void setFullname(String fullname) {
        this.fullname = fullname;
    }
    
    public String getPhone() {
        return phone;
    }
    
    public void setPhone(String phone) {
        this.phone = phone;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public String getAddress() {
        return address;
    }
    
    public void setAddress(String address) {
        this.address = address;
    }
    
    public String getCity() {
        return city;
    }
    
    public void setCity(String city) {
        this.city = city;
    }
    
    public String getDistrict() {
        return district;
    }
    
    public void setDistrict(String district) {
        this.district = district;
    }
    
    public String getNotes() {
        return notes;
    }
    
    public void setNotes(String notes) {
        this.notes = notes;
    }
    
    public String getShippingMethod() {
        return shippingMethod;
    }
    
    public void setShippingMethod(String shippingMethod) {
        this.shippingMethod = shippingMethod;
    }
    
    public String getPaymentMethod() {
        return paymentMethod;
    }
    
    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }
    
    public long getTotal() {
        return total;
    }
    
    public void setTotal(long total) {
        this.total = total;
    }
    
    public long getShippingCost() {
        return shippingCost;
    }
    
    public void setShippingCost(long shippingCost) {
        this.shippingCost = shippingCost;
    }
    
    public long getTotalAmount() {
        return total;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
    
    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }
    
    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }
    
    public List<OrderItem> getItems() {
        return items;
    }
    
    public void setItems(List<OrderItem> items) {
        this.items = items;
    }
    
    public String getVnpTxnRef() {
        return vnpTxnRef;
    }
    
    public void setVnpTxnRef(String vnpTxnRef) {
        this.vnpTxnRef = vnpTxnRef;
    }
    
    public String getVnpTransactionNo() {
        return vnpTransactionNo;
    }
    
    public void setVnpTransactionNo(String vnpTransactionNo) {
        this.vnpTransactionNo = vnpTransactionNo;
    }
    
    public String getPaymentStatus() {
        return paymentStatus;
    }
    
    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }
    
    @Override
    public String toString() {
        return "Order{" +
                "id=" + id +
                ", userId=" + userId +
                ", fullname='" + fullname + '\'' +
                ", total=" + total +
                ", status='" + status + '\'' +
                '}';
    }
}

