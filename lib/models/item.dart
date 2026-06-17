class Item {
  const Item({
    required this.id,
    required this.name, 
    required this.price,
    required this.desc,
    required this.shortDesc,
    required this.stock,
    required this.isPublic,
    this.rating = 0.0,
    this.amountSold = 0,
    required this.createdAt,
    required this.sellerID,
    required this.sellerName,
  });

  final int    id;
  final String name;
  final double price;
  final String desc;
  final String shortDesc;
  final int    stock;
  final bool   isPublic;
  final double rating;
  final int    amountSold;
  final DateTime createdAt;
  final String sellerID;
  final String sellerName;


  factory Item.fromMap(Map<String, dynamic> row) {
    return Item(
      id:         row["id"],
      name:       row["item_name"],
      price:      row["price"],
      desc:       row["desc"],
      shortDesc:  row["short_desc"],
      stock:      row["stock"],
      isPublic:   row["is_public"],
      rating:     row["rating"],
      amountSold: row["amount_sold"],
      createdAt:  DateTime.parse(row["item_created_at"]),
      sellerID:   row["user_profiles"]?["user_id"],
      sellerName: row["user_profiles"]?["user_name"] ?? "Unknown Seller",
    );
  }
}
