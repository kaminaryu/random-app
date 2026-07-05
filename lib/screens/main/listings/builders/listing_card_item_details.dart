import 'package:flutter/material.dart';
import 'package:i_bazaar/models/item.dart';

class ListingCardItemDetails {
  static Widget nameRatingRow(Item item, ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _nameStatusSection(item, colorScheme),

        _ratingSection(item, colorScheme),
      ],
    );
  }

  static Widget _nameStatusSection(Item item, ColorScheme colorScheme) {
    return Expanded(
      child: Text(
        item.name,
        overflow: TextOverflow.ellipsis,

        style: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w700,
          color: colorScheme.onPrimary,
        ),
      ),
    );
  }

  static Widget _ratingSection(Item item, ColorScheme colorScheme) {
    return Row(
      spacing: 4.0,
      children: [
        Icon(
          Icons.star,
          color: Colors.amber,
          size: 14.0,
        ),

        Text(
          item.rating.toStringAsFixed(2),
          style: TextStyle(
            color: Colors.amber,
            fontSize: 14.0
          ),
        ),
      ]
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


  static Widget priceStockRow(Item item, ColorScheme colorScheme) {
    return Column(
      children: [
        _horizontalDivider(),

        IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _priceStockSection(value: "RM ${item.price.toStringAsFixed(2)}", label: "Price",  colorScheme: colorScheme),
              _verticalDivider(),
              _priceStockSection(value: "${item.stock}",    label: "Stock",  colorScheme: colorScheme),
            ],
          ),
        ),
      ],
    );
  }

  static Widget _priceStockSection({required String value, required String label, required ColorScheme colorScheme}) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8), 
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                color: colorScheme.onPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                overflow: TextOverflow.ellipsis,
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
      ),
    );
  }

  static Widget _horizontalDivider() {
    return Container(
      height: 1,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(67),
      ),
    );
  }

  static Widget _verticalDivider() {
    return Container(
      width: 1,
      margin: EdgeInsets.symmetric(horizontal: 4.0),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(67),
      ),
    );
  }
}
