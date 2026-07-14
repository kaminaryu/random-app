import 'package:flutter/material.dart';
import 'package:i_bazaar/models/item.dart';

class ListingCardItemDetails {
  static Widget nameVisibilityRow(Item item, ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _nameSection(item, colorScheme),
        _visibilityBadge(item),
      ],
    );
  }

  static Widget _nameSection(Item item, ColorScheme colorScheme) {
    return Expanded(
      child: Text(
        item.name,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w700,
          color: colorScheme.onPrimary,
        ),
      ),
    );
  }

  static Widget _visibilityBadge(Item item) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 6.0),
      decoration: BoxDecoration(
        color: item.isPublic ? Colors.green : Colors.red,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Text(
        item.isPublic ? "Public" : "Private",
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
      ),
    );
  }

  static Widget shortDesc(Item item, ColorScheme colorScheme) {
    return Text(
      " ${item.shortDesc}",
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: colorScheme.onPrimary.withAlpha(167),
        fontSize: 14.0,
        fontStyle: FontStyle.italic,
      ),
    );
  }

  static Widget compactBottomRow(Item item, ColorScheme colorScheme) {
    return Column(
      children: [
        _horizontalDivider(),
        IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _compactSection(
                icon: Icons.star,
                value: item.rating.toStringAsFixed(2),
                label: "Rating",
                color: Colors.amber,
              ),
              _verticalDivider(),
              _compactSection(
                icon: null,
                value: "RM ${item.price.toStringAsFixed(2)}",
                label: "Price",
                color: Colors.lightGreenAccent,
              ),
              _verticalDivider(),
              _compactSection(
                icon: Icons.inventory_2,
                value: "${item.stock}",
                label: "Stock",
                color: colorScheme.onPrimary,
              ),
            ],
          ),
        ),
      ],
    );
  }

  static Widget _compactSection({
    IconData? icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 2,
              children: [
                if (icon != null) Icon(icon, size: 13, color: color),
                Flexible(
                  child: Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: color,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Widget _horizontalDivider() {
    return Container(
      height: 1,
      margin: EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(67),
      ),
    );
  }

  static Widget _verticalDivider() {
    return Container(
      width: 1,
      margin: EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(67),
      ),
    );
  }
}
