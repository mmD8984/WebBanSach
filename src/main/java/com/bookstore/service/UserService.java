package com.bookstore.service;

import com.bookstore.dao.UserDAO;
import com.bookstore.model.User;

import java.util.List;

public class UserService {

    private UserDAO dao;

    public UserService(UserDAO dao) {
        this.dao = dao;
    }

    public List<User> getAllUsers() {
        return dao.getAll();
    }

    public User getById(int id) {
        return dao.findById(id);
    }

    public boolean create(User u) {
        return dao.insert(u);
    }

    public boolean update(User u) {
        return dao.update(u);
    }

    public boolean delete(int id) {
        return dao.delete(id);
    }
}
