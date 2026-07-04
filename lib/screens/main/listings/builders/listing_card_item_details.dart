import 'package:flutter/material.dart';
import 'package:i_bazaar/models/item.dart';

class ListingCardItemDetails {
  static Widget nameStatusRow(Item item, ColorScheme colorScheme) {
    return Row(
      spacing: 8.0,
      children: [
        Text(
          item.name,
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w700,
            color: colorScheme.onPrimary,
          ),
        ),

        Container(
          padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 6.0),
          decoration: BoxDecoration(
            color: item.isPublic ? Colors.green : Colors.red,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Text(
            item.isPublic ? "Public" : "Private",
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
            ),
          )
        )
      ],
    );
  }


  static Widget shortDesc(Item item, ColorScheme colorScheme) {
    return Text(
      " ${item.shortDesc}",
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: colorScheme.onPrimary.withAlpha(167),
        fontSize: 12.0,
        fontStyle: FontStyle.italic,
      ),
    );
  }


  static Widget priceRatingStock(Item item, ColorScheme colorScheme) {
    return Column(
      children: [
        _horizontalDivider(),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _priceRatingStockSection(value: "RM ${item.price.toStringAsFixed(2)}", label: "Price",  colorScheme: colorScheme),
            _priceRatingStockSection(value: "★ ${item.rating}", label: "Rating", colorScheme: colorScheme),
            _priceRatingStockSection(value: "${item.stock}",    label: "Stock",  colorScheme: colorScheme),
          ],
        ),
      ],
    );
  }

  static Widget _priceRatingStockSection({required String value, required String label, required ColorScheme colorScheme}) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: colorScheme.onPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: colorScheme.onPrimary.withAlpha(200),
              fontSize: 12,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }

  static Widget _horizontalDivider() {
    return Container(
      height: 1,
      margin: EdgeInsets.symmetric(vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(67),
      ),
    );
  }

  // static Widget _verticalDivider() {
  //   return Container(
  //     width: 1,
  //     margin: EdgeInsets.symmetric(horizontal: 4.0),
  //     decoration: BoxDecoration(
  //       color: Colors.white.withAlpha(67),
  //     ),
  //   );
  // }
}
