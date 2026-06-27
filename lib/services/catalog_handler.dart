import 'package:i_bazaar/models/item.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


enum SortingOptions {
  relevance("", "Relevance"),
  uploadDate("item_created_at", ""),
  price("price", ""),
  rating("rating", "");

  // so that the enums have values lol, just contructor
  const SortingOptions(this.queryColumn, this.label);
  final String queryColumn;
  final String label;
}


class CatalogHandler {
  static final supabase = Supabase.instance.client;

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
        .order(sortingOption.queryColumn, ascending: isAscending)
        .range(start, end);
    }

    return (response as List)
      .map((row) => Item.fromMap(row))
      .toList();
  }

  static String fetchImageUrl(String path) {
    return supabase.storage.from("catalog-images").getPublicUrl(path);
  }

  // static String fetchRelevanceSortedRangedItems() {
  //
  // }
  //
  // static String fetchUploadDateSortedRangedItems() {
  //   final response = await supabase
  //     .from("catalog")
  //     .select("*, user_profiles(*)")
  //     .
  // }
  //
  // static String fetchPriceSortedRangedItems() {
  //
  // }
  //
  // static String fetchRatingSortedRangedItems() {
  //
  // }


  // static Future<List<Item>> fetchRangedItemsSortedPrice({required int start, required int end, bool ascending = false}) async {
  //   final response = await supabase
  //     .from("catalog")
  //     .select("*, user_profiles(*)")
  //     .order('price', ascending: ascending)
  //     .range(start, end);
  //
  //   return (response as List)
  //     .map((row) => Item.fromMap(row))
  //     .toList();
  // }
  // // static void filterItems() {};
  //
  // static Future<List<Item>> searchRangedItems({
  //   required String? query,
  //   required double? priceMin,
  //   required double? priceMax,
  //   required String? sortBy,
  //   required bool ascending,
  //   required int start,
  //   required int end,
  // }) async {
  //   dynamic q = supabase.from("catalog").select("*, user_profiles(*)");
  //   if (query != null && query.isNotEmpty) {
  //     q = q.or(
  //       'name.ilike.%$query%,short_desc.ilike.%$query%,desc.ilike.%$query%',
  //     );
  //   }
  //   if (priceMin != null) q = q.gte('price', priceMin);
  //   if (priceMax != null) q = q.lte('price', priceMax);
  //   final col = switch (sortBy) {
  //     'price' => 'price',
  //     'alpha' => 'name',
  //     'rating' => 'rating',
  //     _ => 'created_at',
  //   };
  //   q = q.order(col, ascending: ascending).range(start, end);
  //   final res = await q;
  //   return (res as List).map((row) => Item.fromMap(row)).toList();
  // }
  //
  // static Future<({double min, double max})> fetchPriceRange() async {
  //   final minRes = await supabase
  //     .from("catalog")
  //     .select('price')
  //     .order('price', ascending: true)
  //     .limit(1);
  //   final maxRes = await supabase
  //     .from("catalog")
  //     .select('price')
  //     .order('price', ascending: false)
  //     .limit(1);
  //   final min = ((minRes as List).firstOrNull?['price'] as num?)?.toDouble() ?? 0.0;
  //   final max = ((maxRes as List).firstOrNull?['price'] as num?)?.toDouble() ?? 0.0;
  //   return (min: min, max: max);
  // }
}
