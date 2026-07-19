class CartItem {
  CartItem(this.itemId, this.amount);

  final String itemId;
  int amount = 0;

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(map["itemId"], map["amount"]);
  }

  Map<String, dynamic> toMap() {
    return {
      "itemId": itemId,
      "amount": amount,
    };
  }
}

