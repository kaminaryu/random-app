import 'dart:io';

// import 'package:i_bazaar/models/item.dart';
import 'package:flutter/widgets.dart';
import 'package:i_bazaar/models/item.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class ListingHandler {
  static final supabase = Supabase.instance.client;

  static Future<void> createListing({
    required String name,
    required double price,
    required String desc,
    required String shortDesc,
    required int stock,
    required bool isPublic,
    required XFile imageFile,
  })
  async {
    final user = supabase.auth.currentUser;

    final itemId = const Uuid().v4();

    final sellerId = user!.id;
    final imagePath = '$sellerId/$itemId.jpg';

    await supabase.storage.from("catalog-images").upload(
      imagePath,
      File(imageFile.path),
      fileOptions: const FileOptions(contentType: 'image/jpeg'),
    );

    final double roundedPrice = double.parse(price.toStringAsFixed(2));

    try {
      await supabase
        .from("catalog")
        .insert({
          "id": itemId,
          "item_name": name,
          "price": roundedPrice,
          "desc": desc,
          "short_desc": shortDesc,
          "stock": stock,
          "is_public": isPublic,
          "user_id": sellerId,
        }); //.select("*, user_profiles(*)");
    }
    catch (e) {
      // delete from bucket if failed so that there will be no orphaned image file
      await supabase.storage.from("catalog-images").remove([imagePath]);

      debugPrint("Error when creating listing: ${e.toString()}");

      rethrow;
    }

    // return Item.fromMap((response as List).first);
  }


  static Future<Item> updateListing({
    required String itemId,
    required String name,
    required double price,
    required String desc,
    required String shortDesc,
    required int stock,
    required bool isPublic,
    XFile? imageFile,
  })
  async {
    final user = supabase.auth.currentUser;

    final sellerId = user!.id;
    final imagePath = '$sellerId/$itemId.jpg';

    if (imageFile != null) {
      await supabase.storage.from("catalog-images").update(
        imagePath,
        File(imageFile.path),
        fileOptions: const FileOptions(contentType: 'image/jpeg'),
      );
    }

    final double roundedPrice = double.parse(price.toStringAsFixed(2));

    try {
      final List<Map<String, dynamic>> response = await supabase
        .from("catalog")
        .update({
          "item_name": name,
          "price": roundedPrice,
          "desc": desc,
          "short_desc": shortDesc,
          "stock": stock,
          "is_public": isPublic,
          "user_id": sellerId,
        })
        .eq("id", itemId)
        .select("*, user_profiles(*)");

      return (response)
        .map((row) => Item.fromMap(row))
        .toList()
        .first;

    }
    catch (e) {
      // delete from bucket if failed so that there will be no orphaned image file
      await supabase.storage.from("catalog-images").remove([imagePath]);

      debugPrint("Error when creating listing: ${e.toString()}");

      rethrow;
    }

  }


  // using RPC to avoid race cond
  static Future<void> decreaseListingStock({
    required String itemId,
    required int amount
  })
  async {
    try {
      await supabase
        .rpc("decrease_stock", params: {
          "item_id": itemId,
          "amount": amount
        });
    }
    catch (e) {
      debugPrint("Error when creating listing: ${e.toString()}");
      rethrow;
    }
  }


  // delete the listing from the backend
  static Future<void> deleteListing({required String sellerId, required String itemId}) async {
    await supabase.from("catalog").delete().eq("id", itemId);

    // delete the thumbnail associated with the item
    final imagePath = '$sellerId/$itemId.jpg';
    await supabase.storage.from("catalog-images").remove([imagePath]);
  }
}
