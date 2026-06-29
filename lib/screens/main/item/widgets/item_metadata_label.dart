import 'package:flutter/material.dart';
import 'package:i_bazaar/models/item.dart';

class ItemMetadataLabel extends StatelessWidget {
  const ItemMetadataLabel({super.key, required this.item, required this.theme});

  final Item item;
  final ThemeData theme;

  String _formatDate(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }


  Widget _buildStarIcons(double rating) {
    return Row(
      children: [
        for (var i = 0; i < 5; i++)
          Icon(
            i < rating.floor()
                ? Icons.star
                : (rating % 1 >= 0.5 && i < rating.ceil())
                    ? Icons.star_half
                    : Icons.star_border,
            size: 18,
            color: Colors.amber,
          ),
      ],
    );
  }

  Widget _buildRatingRow() {
    return Row(
      children: [
        _buildStarIcons(item.rating),
        const SizedBox(width: 6),

        Text(
          item.rating.toStringAsFixed(1),
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withAlpha(150),
            fontSize: 14,
          ),
        ),
        const SizedBox(width: 6),

        Text(
          'I ${item.amountSold} sold',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withAlpha(100),
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildStockLabel() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.inventory_2,
          size: 14,
          color: theme.colorScheme.onSurface.withAlpha(101)
        ),
        const SizedBox(width: 4),

        Text(
          'Stock: ${item.stock}',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withAlpha(150),
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildDateLabel() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.calendar_today,
          size: 14,
          color: theme.colorScheme.onSurface.withAlpha(100)
        ),
        const SizedBox(width: 4),

        Text(
          'Listed ${_formatDate(item.createdAt)}',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withAlpha(150),
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStockLabel(),
              _buildDateLabel(),
            ],
          ),
          SizedBox(height: 8),

          _buildRatingRow(),
        ],
      ),
    );
  }
}
