import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RatingHandler {
  Future<double> fetchItemRatingPerUser(String itemId, String userId) async {
    final SupabaseClient supabase = Supabase.instance.client;
    final Map<String, dynamic> response;

    try {
       response = await supabase
        .from("ratings")
        .select("*")
        .eq("item_id", itemId)
        .eq("user_id", userId)
        .single();
    }
    on PostgrestException catch (err) {
      debugPrint("Error when fetching item rating per user: ${err.message}");
      rethrow;
    }

    return response["rating"];
  }


  Future<void> rateItemPerUser({required String itemId, required String userId, required double rating}) async {
    final SupabaseClient supabase = Supabase.instance.client;

    try {
      await supabase
        .from("ratings")
        .insert({
          "item_id": itemId,
          "user_id": userId,
          "rating": rating,
        });
    }
    on PostgrestException catch (err) {
      debugPrint("Error when user rating item: ${err.message}");
      rethrow;
    }
  }
}
