import 'package:flutter/rendering.dart';
import 'package:i_bazaar/models/item.dart';
import 'package:i_bazaar/services/catalog_handler.dart';

class CacheHandler {
  // dynamic: {"cacheTime": DateTime, "item": Item}
  static Map<String, Map<String, dynamic>> _items = {};

  // dynamic: {"cacheTime": DateTime, "items": List<Item>}
  static Map<String, Map<String, dynamic>> _itemQueries = {};

  /////////////////////////
  // -- Caching Items -- //
  /////////////////////////

  static Item? findItemInCache(String itemId) {
    if (!_items.containsKey(itemId)) {
      debugPrint("## Cache Handler: Requested item is not cached");
      return null;
    }

    final Map<String, dynamic> item = _items[itemId]!;

    // if item has been cached a while ago, refresh
    final Duration cacheDuration = DateTime.now().difference(item["cacheTime"]);
    if (cacheDuration.inMinutes >= 5) {
      debugPrint("## Cache Handler: Cached item is stale, fetching new");
      removeItemFromCache(itemId);
      return null;
    }

    debugPrint("## Cache Handler: Returning item from cache");
    return item['item'];
  }

  static void addItemToCache(Item item) {
    // do not add if already cached
    // if (findItemInCache(item.id) != null) return;

    debugPrint("## Cache Handler: Adding item to cache");
    _items[item.id] = {
      "cacheTime": DateTime.now(),
      "item": item,
    };
  }

  static void removeItemFromCache(String itemId) {
    _items.remove(itemId);
  }



  ///////////////////////////
  // -- Caching Queries -- //
  ///////////////////////////
 
  // -> query key => 'sort|filter|page|searchQuery'
  // Filter Naming Scheme:
  //  (i need to make a better system than ts lmao)
  //  UserId($userId)
  //  PriceRange($start,$end)
  static String generateQuerykey({required SortingOptions sortingOption, String filter="", required int page, String query=""}) {
    return "$sortingOption|$filter|$page|$query";
  }


  static List<Item>? findQueryInCache(String queryKey) {
    if (!_itemQueries.containsKey(queryKey)) {
      debugPrint("## Cache Handler: Requested query is not cached");
      debugPrint("Query Key: $queryKey");
      return null;
    }

    final Map<String, dynamic> query = _itemQueries[queryKey]!;

    // if query has been cached a while ago, refresh
    final Duration cacheDuration = DateTime.now().difference(query["cacheTime"]);
    if (cacheDuration.inMinutes >= 5) {
      debugPrint("## Cache Handler: Cached query is stale, fetching new query");
      removeQueryFromCache(queryKey);
      return null;
    }

    debugPrint("## Cache Handler: Returning query from cache");
    return query['items'];
  }


  static void addQueryToCache(String queryKey, List<Item> items) {
    debugPrint("## Cache Handler: Adding query to cache");
    debugPrint("Query Key: $queryKey");
    _itemQueries[queryKey] = {
      "cacheTime": DateTime.now(),
      "items": items,
    };
  }


  static void removeQueryFromCache(String queryKey) {
    _itemQueries.remove(queryKey);
  }
}
