package com.bookstore.service;

import com.bookstore.dao.BookDAO;
import com.bookstore.model.Book;

import java.util.List;

public class BookService {

    private BookDAO dao;

    public BookService(BookDAO dao) {
        this.dao = dao;
    }

    public List<Book> getAllBooks() {
        return dao.getAll();
    }

    public Book getById(int id) {
        return dao.findById(id);
    }

    public boolean create(Book b) {
        return dao.insert(b);
    }

    public boolean update(Book b) {
        return dao.update(b);
    }

    public boolean delete(int id) {
        return dao.delete(id);
    }
}
