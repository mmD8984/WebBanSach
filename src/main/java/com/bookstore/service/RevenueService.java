package com.bookstore.service;

import com.bookstore.dao.RevenueDAO;
import com.bookstore.model.RevenueStat;

import java.util.List;

public class RevenueService {

    private RevenueDAO dao;

    public RevenueService(RevenueDAO dao) {
        this.dao = dao;
    }

    public List<RevenueStat> getWeeklyRevenue() {
        return dao.getWeeklyRevenue();
    }

    public List<RevenueStat> getMonthlyRevenue() {
        return dao.getMonthlyRevenue();
    }
}
