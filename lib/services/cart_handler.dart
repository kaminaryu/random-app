import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:i_bazaar/models/cart_item.dart';
import 'package:i_bazaar/models/item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartHandler {
  static const _cartKey = 'cart_items';

  static Future<void> saveCart(List<CartItem> cartItems) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = cartItems.map((c) => jsonEncode(c.toMap())).toList();
    await prefs.setStringList(_cartKey, jsonList);
  }

  static Future<List<CartItem>> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_cartKey) ?? [];
    return jsonList.map((jsonStr) => CartItem.fromMap(jsonDecode(jsonStr))).toList();
  }

  static Future<void> addToCart(Item item, int amount) async {
    final cart = await loadCart();
    final index = cart.indexWhere((c) => c.item.id == item.id);

    if (index == -1) {
      cart.add(CartItem(item: item, quantity: amount));
    }
    else {
      cart[index] = cart[index].copyWith(quantity: cart[index].quantity + amount);
    }

    await saveCart(cart);
  }

  static Future<void> removeFromCart(String itemId) async {
    final cart = await loadCart();
    cart.removeWhere((c) => c.item.id == itemId);
    await saveCart(cart);
  }

  static Future<void> updateQuantity(String itemId, int newQuantity) async {
    final cart = await loadCart();
    final index = cart.indexWhere((c) => c.item.id == itemId);
    if (index != -1) {
      cart[index] = cart[index].copyWith(quantity: newQuantity);
    }
    await saveCart(cart);
  }

  static Future<void> clearCart() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cartKey);
  }

  static Future<void> debugPrintCartItems() async {
    final cart = await CartHandler.loadCart();
    debugPrint('--- CART (${cart.length} items) ---');
    for (final c in cart) {
      debugPrint('${c.item.name} x${c.quantity}');
    }
  }
}
