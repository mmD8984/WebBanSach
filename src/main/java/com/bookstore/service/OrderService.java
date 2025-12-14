package com.bookstore.service;

import com.bookstore.dao.OrderDAO;
import com.bookstore.model.Order;

import java.util.List;

public class OrderService {

    private OrderDAO dao;

    public OrderService(OrderDAO dao) {
        this.dao = dao;
    }

    public List<Order> getAllOrders() {
        return dao.getAll();
    }

    public Order getById(int id) {
        return dao.findById(id);
    }

    public boolean create(Order o) {
        return dao.insert(o);
    }

    public boolean update(Order o) {
        return dao.update(o);
    }

    public boolean delete(int id) {
        return dao.delete(id);
    }
}
