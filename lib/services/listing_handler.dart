import 'dart:io';

import 'package:i_bazaar/models/item.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ListingHandler {
  static final supabase = Supabase.instance.client;

  static Future<Item> createListing({
    required String name,
    required double price,
    required String desc,
    required String shortDesc,
    required int stock,
    required bool isPublic,
    required XFile imageFile,
  }) async {
    final user = supabase.auth.currentUser;
    if (user == null) throw Exception('Not signed in');

    final sellerId = user.id;
    final imagePath = '$sellerId/$name.jpg';

    await supabase.storage.from("catalog-images").upload(
      imagePath,
      File(imageFile.path),
      fileOptions: const FileOptions(contentType: 'image/jpeg'),
    );

    final response = await supabase.from("catalog").insert({
      "item_name": name,
      "price": price,
      "desc": desc,
      "short_desc": shortDesc,
      "stock": stock,
      "is_public": isPublic,
      "user_id": sellerId,
    }).select("*, user_profiles(*)");

    return Item.fromMap((response as List).first);
  }
}
