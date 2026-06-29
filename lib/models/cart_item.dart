// lib/models/cart_item.dart
import 'item.dart';

class CartItem {
  const CartItem({
    required this.item,
    required this.quantity,
  });

  final Item item;
  final int quantity;

  CartItem copyWith({int? quantity}) {
    return CartItem(
      item: item,
      quantity: quantity ?? this.quantity,
    );
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      item: Item.fromMapToItem(map["item"]),
      quantity: map["quantity"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "item": item.fromItemToMap(),
      "quantity": quantity,
    };
  }
}
