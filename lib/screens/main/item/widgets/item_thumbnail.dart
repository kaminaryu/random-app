import 'package:flutter/material.dart';
import 'package:i_bazaar/models/item.dart';
import 'package:i_bazaar/services/catalog_handler.dart';

class ItemThumbnail extends StatelessWidget {
  const ItemThumbnail({super.key, required this.item, required this.theme});

  final Item item;
  final ThemeData theme;

  Widget _buildLoadingPlaceholder() {
    return const SizedBox(
      height: 280,
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildErrorPlaceholder() {
    return SizedBox(
      height: 280,
      child: Center(
        child: Icon(Icons.broken_image, size: 48,
            color: theme.colorScheme.onSurface.withAlpha(100)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(16),
        bottomRight: Radius.circular(16),
      ),
      child: AspectRatio(
        aspectRatio: 3 / 3,
        child: Image.network(
          CatalogHandler.fetchImageUrl(item.sellerID, item.id),
          width: double.infinity,
          fit: BoxFit.contain,
          loadingBuilder: (context, child, progress) {
            if (progress == null) return child;
            return _buildLoadingPlaceholder();
          },
          errorBuilder: (context, error, stackTrace) {
            return _buildErrorPlaceholder();
          },
        ),
      ),
    );
  }
}
