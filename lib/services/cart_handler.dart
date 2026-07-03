import 'package:flutter/rendering.dart';
import 'package:i_bazaar/models/item.dart';
import 'package:i_bazaar/services/catalog_handler.dart';
import 'package:i_bazaar/services/listing_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CartHandler {
  static final supabase = Supabase.instance.client;


  static Future<void> addItemToCart({
    required String itemID,
    required int quantity
  })
  async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      debugPrint("User is not logged in");
      return;
    }

    // basically check if user add more amount when they already have the shit in the cart yk, ik you have done this before
    try {
      final int existingCartItemQuantity = await _checkForExistingCartItem(itemID: itemID);

      if (existingCartItemQuantity == -1) {
        _createNewCartItem(user: user, itemID: itemID, quantity: quantity);
      }
      else {
        _changeCartItemQuantity(itemID: itemID, currentQuantity: existingCartItemQuantity, deltaQuantity: quantity);
      }

      ListingHandler.decreaseListingStock(itemID: itemID, amount: quantity);

    }
    catch (e) {
      debugPrint("Error when adding to cart: ${e.toString()}");
      rethrow;
    }
  }


  static Future<int> _checkForExistingCartItem({required String itemID}) async {
    final user = supabase.auth.currentUser;
    if (user == null) return -1;

    final  List<Map<String, dynamic>> response;

    try {
      response = await supabase
        .from("user_cart")
        .select("item_quantity")
        .eq("item_id", itemID)
        .eq("user_id", user.id);
    }
    catch (e) {
      debugPrint("Error when fetching existing item quantity: ${e.toString()}");
      rethrow;
    }

    if (response.isEmpty) {
      return -1;
    }
    
    return response.first["item_quantity"];
  }


  static Future<void> _changeCartItemQuantity({
    required String itemID,
    required int currentQuantity,
    required int deltaQuantity,
  }) async {
    int newQuantity = currentQuantity + deltaQuantity;

    try {
      await supabase
        .from("user_cart")
        .update({
          "item_quantity": newQuantity,
        })
        .eq("item_id", itemID);
    }
    catch (e) {
      debugPrint("Error when changing cart item quantity: ${e.toString()}");
      rethrow;
    }
  }


  static Future<void> _createNewCartItem({
    required User user,
    required String itemID,
    required int quantity,
  }) async {
    try {
      await supabase
        .from("user_cart")
        .insert({
          "user_id": user.id,
          "item_id": itemID,
          "item_quantity": quantity,
        });
    }
    catch (e) {
      debugPrint("Error when creating new cart item listing: ${e.toString()}");
      rethrow;
    }
  }


  static Future<void> removeItemFromCart({required String itemID}) async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    try {
      await supabase
        .from("user_cart")
        .delete()
        .eq("item_id", itemID)
        .eq("user_id", user.id);
    }
    catch (e) {
      debugPrint("Error when adding to cart: ${e.toString()}");
      rethrow;
    }
  }


  static Future<List<Item>> fetchRangedCartItems({
    required int page,
    required String userID
  })
  async {
    // 1 based indexing cuz normal people uses ts
    final start = (page - 1) * CatalogHandler.pageSize;
    final end   = start + (CatalogHandler.pageSize - 1);

    final List<Map<String, dynamic>> response = await supabase
      .from("user_cart")
      // join user_cart with INNER_JOIN(catalog, user_profile)
      .select("item_quantity, catalog!inner(*, user_profiles(*))")
      .eq("user_id", userID)
      .range(start, end);

    return (response)
      .map((row) => Item.fromCartRow(row))
      .toList();
  }

}
