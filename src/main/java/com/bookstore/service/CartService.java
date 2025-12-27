package com.bookstore.service;

import com.bookstore.dao.CartDAO;
import com.bookstore.model.Cart;
import com.bookstore.model.CartItem;

import java.math.BigDecimal;
import java.util.List;

public class CartService {

    private CartDAO dao;

    public CartService(CartDAO dao) {
        this.dao = dao;
    }

    public Cart getOrCreateCart(int userId) {
        return dao.getOrCreateCart(userId);
    }

    public List<CartItem> getCartItems(int cartId) {
        return dao.getCartItems(cartId);
    }

    public boolean addToCart(int userId, int bookId, int quantity) {
        Cart cart = dao.getOrCreateCart(userId);
        if (cart == null) return false;
        return dao.addItem(cart.getId(), bookId, quantity);
    }

    public boolean updateQuantity(int itemId, int quantity) {
        return dao.updateItemQuantity(itemId, quantity);
    }

    public boolean removeFromCart(int itemId) {
        return dao.removeItem(itemId);
    }

    public boolean clearCart(int cartId) {
        return dao.clearCart(cartId);
    }

    public int getCartItemCount(int userId) {
        Cart cart = dao.findByUserId(userId);
        if (cart == null) return 0;
        return dao.countItems(cart.getId());
    }

    public BigDecimal getCartTotal(int userId) {
        Cart cart = dao.findByUserId(userId);
        if (cart == null) return BigDecimal.ZERO;
        return dao.getCartTotal(cart.getId());
    }
}
