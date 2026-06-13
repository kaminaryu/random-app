import 'package:flutter/material.dart';
import 'package:i_bazaar/models/item.dart';

class ItemCard extends StatelessWidget {
  const ItemCard(this.item, {super.key});

  final Item item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1.0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                "assets/items/${item.imgSrc}",
                width: double.infinity,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 8),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item.name,
                  style: theme.textTheme.bodyLarge,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  item.seller,
                  style: theme.textTheme.bodyMedium,
                ),
                Text(
                  "RM${item.price}",
                  style: theme.textTheme.bodySmall,
                ),
                Row(
                  children: [
                    for (var i = 0; i < 5; i++)
                        Icon(
                          i < item.rating.floor()
                            ? Icons.star
                            : ( item.rating % 1 >= 0.5 && i < item.rating.ceil())
                              ? Icons.star_half
                              : Icons.star_border,
                          size: 12,
                          color: Colors.amber,
                        ),
                    const SizedBox(width: 4),

                    Text(
                      item.rating.toStringAsFixed(1),
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
