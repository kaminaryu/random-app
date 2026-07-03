import 'package:i_bazaar/models/item.dart';
import 'package:i_bazaar/services/cache_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


enum SortingOptions {
  relevance("relevance"),
  uploadDate("item_created_at"),
  price("price"),
  rating("rating");

  // so that the enums have values lol, just contructor
  const SortingOptions(this.queryColumn);
  final String queryColumn;
}


class CatalogHandler {
  static final supabase = Supabase.instance.client;
  // caching feature, unused rn cuz headache
  // static final Map<String, Item> _items = {};

  static Future<List<Item>> fetchRangedItems({
    required int start,
    required int end,
    required SortingOptions sortingOption,
    bool isAscending = false,
    String? userID
  })
  async {
    final List<Map<String, dynamic>> response;

    if (userID != null) {
      response = await supabase
        .from("catalog")
        .select("*, user_profiles(*)")
        .eq("user_id", userID)
        .order(sortingOption.queryColumn, ascending: isAscending)
        .range(start, end);
    }
    else {
      response = await supabase
        .from("catalog")
        .select("*, user_profiles(*)")
        .eq("is_public", true)
        .order(sortingOption.queryColumn, ascending: isAscending)
        .range(start, end);
    }

    // covert postgres rows to items
    return (response)
      .map((row) => Item.fromMapToItem(row))
      .toList();
  }

  static String fetchImageUrl(String sellerID, String itemID) {
    final path = "$sellerID/$itemID.jpg";
    return supabase.storage.from("catalog-images").getPublicUrl(path);
  }

  static Future<List<Item>> searchRangedItems({
    required int start,
    required int end,
    required String query,
    required SortingOptions sortingOption,
    required double priceStart,
    required double priceEnd,
    bool isAscending = false,
  })
  async {
    if (priceEnd == 1000) priceEnd = 999999;

    final List<Map<String, dynamic>> response = await supabase.rpc(
      "search_catalogs",
      params: {
        'search_query': query,
        'sorting_option': sortingOption.queryColumn,
        'ascending': isAscending,
        'price_start': priceStart,
        'price_end': priceEnd,
        'page_offset': start,
        'page_limit': end - start + 1,
      }
    );

    return (response)
      .map((row) => Item.fromMapToItem(row))
      .toList();
  }

  static Future<Item> fetchItem(String itemID) async {
    // do not call db if item is already cached
    final Item? itemInCache = CacheHandler.findItemInCache(itemID);

    if (itemInCache != null) {
      return itemInCache;
    }


    final List<Map<String, dynamic>> response = await supabase
      .from("catalog")
      .select("*, user_profiles(*)")
      .eq("id", itemID);


    final Map<String, dynamic>? row = response.firstOrNull;

    if (row == null) {
      throw Exception("Item not found: $itemID");
    }

    final item = Item.fromMapToItem(row);

    // cache the item
    CacheHandler.addItemToCache(item);

 
    return item;
  }

  // static void clearCache() {
  //   _items.clear();
  // }
}
