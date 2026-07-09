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
  static const int pageSize = 20;

  static final supabase = Supabase.instance.client;

  static Future<List<Item>> fetchRangedItems({
    required int page,
    required SortingOptions sortingOption,
    bool isAscending = false,
    String? userId
  })
  async {
    final List<Map<String, dynamic>> response;
    final String queryKey;

    // 1 based indexing cuz normal people uses ts
    final start = (page - 1) * pageSize;
    final end   = start + (pageSize - 1);

    // if requested for specufic user's
    if (userId != null) {
      // check if the query if cached
      queryKey = CacheHandler.generateQuerykey(sortingOption: sortingOption, filter: "UserId($userId)" ,page: page);

      final List<Item>? queryInCache = CacheHandler.findQueryInCache(queryKey);

      if (queryInCache != null) return queryInCache;

      response = await supabase
        .from("catalog")
        .select("*, user_profiles(*)")
        .eq("user_id", userId)
        .order(sortingOption.queryColumn, ascending: isAscending)
        .range(start, end);
    }
    else {
      // check if the query if cached
      queryKey = CacheHandler.generateQuerykey(sortingOption: sortingOption, page: page);
      final List<Item>? queryInCache = CacheHandler.findQueryInCache(queryKey);

      if (queryInCache != null) return queryInCache;

      response = await supabase
        .from("catalog")
        .select("*, user_profiles(*)")
        .eq("is_public", true)
        .order(sortingOption.queryColumn, ascending: isAscending)
        .range(start, end);
    }

    // covert postgres rows to items
    final queryList = response
      .map((row) => Item.fromMapToItem(row))
      .toList();

    CacheHandler.addQueryToCache(queryKey, queryList);

    return queryList;
  }


  static String fetchImageUrl(String sellerId, String itemId) {
    final path = "$sellerId/$itemId.jpg";
    return supabase.storage.from("catalog-images").getPublicUrl(path);
  }


  static Future<List<Item>> searchRangedItems({
    required int page,
    required String query,
    required SortingOptions sortingOption,
    required double priceStart,
    required double priceEnd,
    bool isAscending = false,
  })
  async {
    // 1 based indexing cuz normal people uses ts
    final start = (page - 1) * pageSize;
    final end   = start + (pageSize - 1);

    // check if the query if cached
    final queryKey = CacheHandler.generateQuerykey(sortingOption: sortingOption, filter: "PriceRange($priceStart,$priceEnd)", page: page, query: query);
    final List<Item>? queryInCache = CacheHandler.findQueryInCache(queryKey);

    if (queryInCache != null) return queryInCache;

    // make the price end range "infinite" if the user slides to the end
    if (priceEnd == 1000) priceEnd = 999_999_999;


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

    final queryList = response
      .map((row) => Item.fromMapToItem(row))
      .toList();

    CacheHandler.addQueryToCache(queryKey, queryList);

    return queryList;
  }


  static Future<Item> fetchItem(String itemId) async {
    // do not call db if item is already cached
    final Item? itemInCache = CacheHandler.findItemInCache(itemId);

    if (itemInCache != null) return itemInCache;


    final List<Map<String, dynamic>> response = await supabase
      .from("catalog")
      .select("*, user_profiles(*)")
      .eq("id", itemId);

    final Map<String, dynamic>? row = response.firstOrNull;

    if (row == null) {
      throw Exception("Item not found: $itemId");
    }

    final item = Item.fromMapToItem(row);

    // cache the item
    CacheHandler.addItemToCache(item);

    return item;
  }
}
