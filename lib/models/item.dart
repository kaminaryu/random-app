class Item {
  const Item({
    required this.name, 
    required this.price,
    required this.desc,
    required this.seller,
    required this.stock,
    required this.status,
    required this.imgSrc,
    this.rating = 0.0,
  });

  final String name;
  final String price;
  final String desc;
  final String seller;
  final int stock;
  final String status;
  final String imgSrc;
  final double rating;
}
