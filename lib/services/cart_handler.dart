import 'dart:convert';

import 'package:i_bazaar/models/cart_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _storageKey = "cart_items";


class CartHandler {
  CartHandler(this.userId);
  final String userId;

  // userId: [CartItems]
  static Map<String, List<CartItem>> _cartDirectory = {};

  
  Future<void> addItemToCart(String itemId, int amount) async {
    List<CartItem> userCart = await fetchCart();

    // check if the item is already in cart
    final int itemIndex = userCart.indexWhere(
      (cartItem) => cartItem.itemId == itemId 
    );

    // if item isnt in the cart 
    if (itemIndex == -1) {
      // create new entry
      userCart.add(CartItem(itemId, amount));
    }
    else {
      // increase amount instead
      userCart[itemIndex].amount += amount;
    }

    // save the cart
    _cartDirectory[userId] = userCart;
    await saveToStorage();
  }


  Future<List<CartItem>> fetchCart() async {
    if (!_cartDirectory.containsKey(userId)) {
      return [];
    }

    return _cartDirectory[userId]!;
  }


  Future<void> removeItemFromCart(String itemId) async {
    if (!_cartDirectory.containsKey(userId)) {
      return;
    }

    _cartDirectory[userId]!.removeWhere((cartItem) => cartItem.itemId == itemId);
    saveToStorage();
  }


  // these two are static cuz the cart needs to sync across instances
  static Future<void> saveToStorage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // welcome to bullshit :
    final jsonString = _cartDirectory.map(  // 1. iterate over all carts in the dir
      (userId, cartItems) => MapEntry(      // 2. Converting to Map<String, List<map>>
        userId,                             // 2a. Still uses userId as key
        cartItems.map(
          (item) => item.toMap()            // 3. Turning CartItem into Map/Dict/JSON Obj
        ).toList(),                         // 3a. Convert the Iterable into a List
      )
    );

    await prefs.setString(_storageKey, jsonEncode(jsonString));

  }

  static Future<void> initCart() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);

    // return if no saved carts
    if (jsonString == null) return;

    // convert back the saved json
    final Map<String, dynamic> decoded = jsonDecode(jsonString);

    // same bullshit as before, but we changing List<map> to List<CartItem>
    _cartDirectory = decoded.map(
      (userId, cartItems) => MapEntry(
        userId,
        cartItems.map<CartItem>( // return map<CartItem> instead of map<dynamic>
          (item) => CartItem.fromMap(item)
        ).toList(),
      ),
    );
  }
}
