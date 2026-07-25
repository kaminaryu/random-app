import 'package:flutter/material.dart';
import 'package:i_bazaar/models/item.dart';
import 'package:i_bazaar/models/purchase.dart';

class PurchaseCard extends StatelessWidget {
  const PurchaseCard(this.purchase, this.purchasedItem, {super.key});

  final Purchase purchase;
  final Item purchasedItem;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(purchasedItem.name),
        Text(purchasedItem.sellerName),
        Text("${purchase.amount}"),
        // Text("${purchase.purchaseAt}"),
      ],
    );
  }
}
