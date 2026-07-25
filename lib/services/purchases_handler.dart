import 'package:flutter/material.dart';
import 'package:i_bazaar/models/purchase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PurchasesHandler {
  Future<void> recordPuchases({
    required String userId,
    required String itemId,
    required int amount,
  }) async {
    final SupabaseClient supabase = Supabase.instance.client;

    try {
      await supabase
        .from("purchases")
        .insert({
          "item_id": itemId,
          "user_id": userId,
          "amount": amount,
        });
    }
    on PostgrestException catch (err) {
      debugPrint("Error when recording purchases for item:");
      debugPrint("itemId: $itemId");
      debugPrint("userId: $userId");
      debugPrint(err.message);
    }
    return;
  }
  

  Future<List<Purchase>> fetchUserPurchases({
    required String userId
  }) async {
    final SupabaseClient supabase = Supabase.instance.client;
    final List<Map<String, dynamic>> response;

    try {
      response = await supabase
        .from("purchases")
        .select("*")
        .eq("user_id", userId);
    }
    on PostgrestException catch (err) {
      debugPrint("Unable to fetch purchasing history");
      debugPrint(err.message);

      rethrow;
    }

    return response.map((row) => Purchase.fromMap(row)).toList();
  }
}
