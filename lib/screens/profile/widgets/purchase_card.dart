import 'package:flutter/material.dart';
import 'package:i_bazaar/models/item.dart';
import 'package:i_bazaar/models/purchase.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class PurchaseCard extends StatelessWidget {
  const PurchaseCard({super.key, required this.purchase, required this.purchasedItem, required this.onRatingBarValueChange, required this.onUpdateRating});

  final Purchase purchase;
  final Item purchasedItem;
  final void Function(double) onRatingBarValueChange;
  final VoidCallback onUpdateRating;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(purchasedItem.name),
        Text(purchasedItem.sellerName),
        Text("x${purchase.amount}"),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 8.0,
          children: [
            RatingBar.builder(
              initialRating: 0.0,
              minRating: 0.0,
              maxRating: 5.0,
              allowHalfRating: true,

              itemSize: 24,
              glowRadius: 0.0,

              itemBuilder: (context, idkWhatThisParamsDoes) {
                return Icon(
                  Icons.star,
                  color: Colors.amber,
                );
              },

              onRatingUpdate: (value) => onRatingBarValueChange(value),
            ),

            ElevatedButton(
              onPressed: onUpdateRating,
              child: Icon(Icons.arrow_right),
            )
          ],
        ),

        const SizedBox(height: 24),

      ],
    );
  }
}
