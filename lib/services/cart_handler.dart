import 'package:flutter/rendering.dart';
import 'package:i_bazaar/models/item.dart';
import 'package:i_bazaar/services/cache_handler.dart';
import 'package:i_bazaar/services/catalog_handler.dart';
import 'package:i_bazaar/services/listing_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CartHandler {
  static final supabase = Supabase.instance.client;


  static Future<void> addItemToCart({
    required String itemId,
    required int quantity
  })
  async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      debugPrint("User is not logged in");
      return;
    }

    // when user add to cart, check if the item is already inside the cart
    try {
      final int existingCartItemQuantity = await _checkForExistingCartItem(itemId: itemId);

      // no item is in cart, create new instance
      if (existingCartItemQuantity == 0) {
        _createNewCartItem(user: user, itemId: itemId, quantity: quantity);
      }
      // increase existing item in cart
      else {
        _changeCartItemQuantity(itemId: itemId, currentQuantity: existingCartItemQuantity, deltaQuantity: quantity);
      }

      ListingHandler.decreaseListingStock(itemId: itemId, amount: quantity);

    }
    catch (e) {
      debugPrint("Error when adding to cart: ${e.toString()}");
      rethrow;
    }
  }


  static Future<int> _checkForExistingCartItem({required String itemId}) async {
    final user = supabase.auth.currentUser;
    if (user == null) return 0;

    final  List<Map<String, dynamic>> response;

    try {
      response = await supabase
        .from("user_cart_item")
        .select("item_quantity")
        .eq("item_id", itemId)
        .eq("user_id", user.id);
    }
    catch (e) {
      debugPrint("Error when fetching existing item quantity: ${e.toString()}");
      rethrow;
    }

    if (response.isEmpty) {
      return 0;
    }
    
    return response.first["item_quantity"];
  }


  static Future<void> _changeCartItemQuantity({
    required String itemId,
    required int currentQuantity,
    required int deltaQuantity,
  }) async {
    int newQuantity = currentQuantity + deltaQuantity;

    try {
      await supabase
        .from("user_cart_item")
        .update({
          "item_quantity": newQuantity,
        })
        .eq("item_id", itemId);
    }
    catch (e) {
      debugPrint("Error when changing cart item quantity: ${e.toString()}");
      rethrow;
    }
  }


  static Future<void> _createNewCartItem({
    required User user,
    required String itemId,
    required int quantity,
  }) async {
    try {
      await supabase
        .from("user_cart_item")
        .insert({
          "user_id": user.id,
          "item_id": itemId,
          "item_quantity": quantity,
        });
    }
    catch (e) {
      debugPrint("Error when creating new cart item listing: ${e.toString()}");
      rethrow;
    }
  }


  static Future<void> removeItemFromCart({required String itemId}) async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    try {
      await supabase
        .from("user_cart_item")
        .delete()
        .eq("item_id", itemId)
        .eq("user_id", user.id);
    }
    catch (e) {
      debugPrint("Error when removing from cart: ${e.toString()}");
      rethrow;
    }
  }


  static Future<List<Item>> fetchRangedCartItems({
    required int page,
    required String userId
  })
  async {
    // check item in cache
    List<Item>? cachedCartItems = CacheHandler.findCartItemsInCache(userId);

    if (cachedCartItems != null) return cachedCartItems;


    // 1 based indexing cuz normal people uses ts
    final start = (page - 1) * CatalogHandler.pageSize;
    final end   = start + (CatalogHandler.pageSize - 1);

    final List<Map<String, dynamic>> response = await supabase
      .from("user_cart_item")
      // join user_cart_item with INNER_JOIN(catalog, user_profile)
      .select("item_quantity, catalog!inner(*, user_profiles(*))")
      .eq("user_id", userId)
      .range(start, end);
    

    final cartItems = (response)
      .map((row) => Item.fromCartRow(row))
      .toList();

    CacheHandler.addCartItemsToCache(userId, cartItems);

    return cartItems;
  }

}
