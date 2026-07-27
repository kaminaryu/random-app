import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:i_bazaar/models/item.dart';
import 'package:i_bazaar/services/catalog_handler.dart';

class ItemCard extends StatelessWidget {
  const ItemCard(this.item, {super.key});

  final Item item;

  String _compactNumbers(int num) {
    if (num >= 1_000_000) {
      return "${(num / 1_000_000).toStringAsFixed(2)}M";
    }
    else if (num >= 1000) {
      return "${(num / 1000).toStringAsFixed(2)}K";
    }

    return num.toString();
  }

  Widget _buildThumbnail() {
    return AspectRatio(
      aspectRatio: 1.0,
      child: Image.network(
        CatalogHandler.fetchImageUrl(item.sellerId, item.id),
        width: double.infinity,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return const Center(child: CircularProgressIndicator());
        },
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.broken_image);
        }
      ),
    );
  }


  Widget _buildStockRatingRow(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          spacing: 4.0,
          children: [
            Icon(
              Icons.star,
              color: Colors.amber,
              size: 12,
            ),
            Text(
              "${item.rating} (${_compactNumbers(item.raters)})",
              style: TextStyle(
                color: Colors.amber,
                fontWeight: FontWeight.w300,
                fontSize: 12,
              ),
            ),
          ],
        ),

        Row(
          spacing: 4.0,
          children: [
            Icon(
              Icons.inventory,
              color: theme.colorScheme.onPrimary.withAlpha(200),
              size: 12,
            ),
            Text(
              "${item.stock}",
              style: TextStyle(
                color: theme.colorScheme.onPrimary.withAlpha(200),
                fontWeight: FontWeight.w300,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ]
    );
  }

  Widget _buildSellerInfo(ThemeData theme) {
    return Row(
      spacing: 4.0,
      children: [
        Icon(
          Icons.person,
          color: theme.colorScheme.onPrimary.withAlpha(125),
          size: 14,
        ),
        Text(
          item.sellerName,
          style: TextStyle(
            color: theme.colorScheme.onPrimary.withAlpha(125),
            fontWeight: FontWeight.w300,
            fontSize: 14,
          ),
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => context.push("/item/?id=${item.id}"),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: theme.colorScheme.primary,
          borderRadius: BorderRadius.circular(12),
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildThumbnail(),
            const SizedBox(height: 8),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0), 
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                    ),
                  ),

                  _buildSellerInfo(theme),

                  Text(
                    "RM${item.price.toStringAsFixed(2)}",
                    style: TextStyle(
                      color: Colors.lightGreenAccent,
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 4.0),

                  _buildStockRatingRow(theme),
                  SizedBox(height: 4.0),

                  Text(
                    item.shortDesc,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: theme.colorScheme.onPrimary.withAlpha(167),
                    ),
                  ),
                  SizedBox(height: 12.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
