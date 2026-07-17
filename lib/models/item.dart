class Item {
  Item({
    required this.id,
    required this.name, 
    required this.price,
    required this.desc,
    required this.shortDesc,
    required this.stock,
    this.amountInCart = 0,
    required this.isPublic,
    this.rating = 0.0,
    this.raters = 0,
    this.amountSold = 0,
    required this.createdAt,
    required this.sellerId,
    required this.sellerName,
    this.isDeleted = false,
  });

  final String id;
  final String name;
  final double price;
  final String desc;
  final String shortDesc;
  final int    stock;
  final int    amountInCart;
  final bool   isPublic;
  final double rating;
  final int    raters;
  final int    amountSold;
  final DateTime createdAt;
  final String sellerId;
  final String sellerName;
  bool isDeleted;


  factory Item.fromMapToItem(Map<String, dynamic> row) {
    return Item(
      id:         row["id"],
      name:       row["item_name"],
      price:      row["price"],
      desc:       row["desc"],
      shortDesc:  row["short_desc"],
      stock:      row["stock"],
      isPublic:   row["is_public"],
      rating:     row["rating"],
      raters:     row["raters"],
      amountSold: row["amount_sold"],
      createdAt:  DateTime.parse(row["item_created_at"]),
      sellerId:   row["user_id"],
      sellerName: row["user_profiles"]?["user_name"] ?? row["user_name"] ?? "Unknown User",
    );
  }

  // for converting cart row to Item when displaying cart lists
  factory Item.fromCartRow(Map<String, dynamic> cartRow) {
    final catalog = cartRow["catalog"] as Map<String, dynamic>;

    return Item(
      id:         catalog["id"],
      name:       catalog["item_name"],
      price:      catalog["price"],
      desc:       catalog["desc"],
      shortDesc:  catalog["short_desc"],
      stock:      catalog["stock"],
      amountInCart: cartRow["item_quantity"] as int,
      isPublic:   catalog["is_public"],
      rating:     catalog["rating"],
      raters:     catalog["raters"],
      amountSold: catalog["amount_sold"],
      createdAt:  DateTime.parse(catalog["item_created_at"]),
      sellerId:   catalog["user_id"],
      sellerName: catalog["user_profiles"]?["user_name"] ?? "Unknown User",
    );
  }

  Map<String, dynamic> fromItemToMap() {
    return {
      "id": id,
      "item_name": name,
      "price": price,
      "desc": desc,
      "short_desc": shortDesc,
      "stock": stock,
      "amountInCart": amountInCart,
      "is_public": isPublic,
      "rating": rating,
      "amount_sold": amountSold,
      "item_created_at": createdAt.toIso8601String(),
      "user_id": sellerId,
      "user_name": sellerName,
    };
  }
}
