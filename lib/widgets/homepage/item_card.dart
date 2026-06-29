import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:i_bazaar/models/item.dart';
import 'package:i_bazaar/services/catalog_handler.dart';

class ItemCard extends StatelessWidget {
  const ItemCard(this.item, {super.key});

  final Item item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => context.push("/item/?id=${item.id}"),
      child: Container(
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
                child: Image.network(
                  CatalogHandler.fetchImageUrl(item.sellerID, item.id),
                  width: double.infinity,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.broken_image);
                  }
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
                    "RM${item.price}",
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    item.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    "by ${item.sellerName}",
                    style: theme.textTheme.bodyMedium,
                  ),

                  Text(
                    "\"${item.shortDesc}\"",
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                    ),
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
      ),
    );
  }
}
