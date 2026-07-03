import 'package:flutter/rendering.dart';
import 'package:i_bazaar/models/item.dart';

class CacheHandler {
  static Map<String, Map<String, dynamic>> _items = {};

  /////////////////////////
  // -- Caching Items -- //
  /////////////////////////

  static Item? findItemInCache(String itemID) {
    if (!_items.containsKey(itemID)) {
      debugPrint("## Cache Handler: Requested item is not cached");
      return null;
    }

    final Map<String, dynamic> item = _items[itemID]!;

    // if item has been cached a while ago, refresh
    final Duration cacheDuration = DateTime.now().difference(item["cacheTime"]);
    if (cacheDuration.inMinutes >= 5) {
      debugPrint("## Cache Handler: Cached item is stale, fetching new");
      removeItemFromCache(itemID);
      return null;
    }

    debugPrint("## Cache Handler: Returning item from cache");
    return item['item'];
  }

  static void addItemToCache(Item item) {
    // do not add if already cached
    if (findItemInCache(item.id) != null) return;

    debugPrint("## Cache Handler: Adding item to cache");
    _items[item.id] = {
      "cacheTime": DateTime.now(),
      "item": item,
    };
  }

  static void removeItemFromCache(String itemID) {
    _items.remove(itemID);
  }



  ///////////////////////////
  // -- Caching Queries -- //
  ///////////////////////////
}
