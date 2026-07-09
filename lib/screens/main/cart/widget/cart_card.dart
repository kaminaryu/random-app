import 'package:flutter/material.dart';
import 'package:i_bazaar/models/item.dart';
import 'package:i_bazaar/services/cart_handler.dart';
import 'package:i_bazaar/services/catalog_handler.dart';

class CartCard extends StatelessWidget {
  const CartCard(this.item, {super.key, required this.onDelete});

  final Item item;
  final VoidCallback onDelete;

  static double get cardHeight => 128;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final grandTotal = item.price * item.amountInCart;

    return Container(
      height: cardHeight,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 96,
              height: 96,
              child: Image.network(
                CatalogHandler.fetchImageUrl(item.sellerId, item.id),
                fit: BoxFit.contain,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.broken_image);
                },
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: SizedBox(
              height: 96,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '@${item.sellerName}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: const Color(0xFFCECBF6),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.shortDesc,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white70,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'RM${grandTotal.toStringAsFixed(2)}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.green,
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '(RM${item.price.toStringAsFixed(2)} × ${item.amountInCart})',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white.withAlpha(200),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            onPressed: () async {
              await CartHandler.removeItemFromCart(itemId: item.id);
              onDelete();
            },
            icon: const Icon(Icons.delete, color: Colors.redAccent),
            tooltip: "Remove from cart",
          ),
        ],
      ),
    );
  }
}
