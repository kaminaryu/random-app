class Item {
  const Item({
    required this.name, 
    required this.price,
    required this.desc,
    required this.seller,
    required this.stock,
    required this.status,
    required this.imgSrc,
  });

  final String name;
  final String price;
  final String desc;
  final String seller;
  final int stock;
  final String status;
  final String imgSrc;
}
