import 'package:flutter/material.dart';
import 'package:i_bazaar/models/item.dart';

class ItemDetails extends StatelessWidget {
  const ItemDetails({super.key, required this.item, required this.theme});

  final Item item;
  final ThemeData theme;


  Widget _buildName() {
    return Text(
      item.name,
      style: theme.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
        fontSize: 32,
      ),
    );
  }

  Widget _buildSellerName() {
    return Text(
      '@${item.sellerName}',
      style: theme.textTheme.bodyLarge?.copyWith(
        color: theme.colorScheme.onSurface.withAlpha(130),
        fontSize: 16,
      ),
    );
  }

  Widget _buildPrice() {
    return Text(
      'RM${item.price}',
      style: TextStyle(
        color: theme.colorScheme.primary,
        fontWeight: FontWeight.w900,
        fontSize: 24,
      ),
    );
  }

  Widget _buildFullDesc() {
    return SelectableText(
      item.desc,
      style: theme.textTheme.bodyLarge?.copyWith(
        fontSize: 26,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildName(),
          const SizedBox(height: 0),

          _buildSellerName(),
          const SizedBox(height: 12),

          _buildFullDesc(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
