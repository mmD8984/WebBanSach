package com.bookstore.service;

import com.bookstore.dao.CategoryDAO;
import com.bookstore.model.Category;

import java.util.List;

public class CategoryService {

    private CategoryDAO dao;

    public CategoryService(CategoryDAO dao) {
        this.dao = dao;
    }

    public List<Category> getAllCategories() {
        return dao.getAll();
    }
    
    public Category getById(int id) {
        return dao.findById(id);
    }
    
    public boolean create(Category c) {
        return dao.insert(c);
    }
    
    public boolean update(Category c) {
        return dao.update(c);
    }
    
    public boolean delete(int id) {
        return dao.delete(id);
    }
}
