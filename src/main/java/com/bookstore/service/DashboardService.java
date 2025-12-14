package com.bookstore.service;

import com.bookstore.dao.DashboardDAO;

public class DashboardService {

    private DashboardDAO dao;

    public DashboardService(DashboardDAO dao) {
        this.dao = dao;
    }

    public long getTotalUsers() { return dao.totalUsers(); }
    public long getActiveUsers() { return dao.totalActiveUsers(); }

    public long getTotalBooks() { return dao.totalBooks(); }
    public long getActiveBooks() { return dao.totalActiveBooks(); }

    public long getTotalOrders() { return dao.totalOrders(); }
    public long getPendingOrders() { return dao.totalPendingOrders(); }

    public long getTotalCategories() { return dao.totalCategories(); }
    
    public String[] getLatestBook() {return dao.getLatestBookInfo(); }
    
    public String[] getLatestUser() {return dao.getLatestUserInfo(); }
}
