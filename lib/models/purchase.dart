class Purchase {
  const Purchase({
    required this.purchaseId,
    required this.itemId,
    required this.userId,
    required this.amount,
    required this.purchaseAt,
  });

  final String purchaseId;
  final String itemId;
  final String userId;
  final int amount;
  final DateTime purchaseAt;

  factory Purchase.fromMap(Map<String, dynamic> map) {
    return Purchase(
      purchaseId: map["purchase_id"],
      itemId:     map["item_id"],
      userId:     map["user_id"],
      amount:     map["amount"],
      purchaseAt: DateTime.parse(map["purchased_at"]),
    );
  }
}
