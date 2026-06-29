import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:i_bazaar/models/item.dart';
import 'package:i_bazaar/services/catalog_handler.dart';

class ListingCard extends StatelessWidget {
  const ListingCard(this.item, {super.key, required this.refreshScreen});

  final Item item;
  final VoidCallback refreshScreen;

  void _goToEditScreen(BuildContext context) async {
    final success = await context.push<bool>("/edit-listing", extra: item);

    if (success == true) {
      refreshScreen.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => context.push("/item/?id=${item.id}"),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: SizedBox(
                    width: 120,
                    height: 120,

                    child: Image.network(
                      CatalogHandler.fetchImageUrl(item.sellerID, item.id),
                      width: 120,
                      height: 120,
                      fit: BoxFit.contain,

                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;

                        return const Center(child: CircularProgressIndicator());
                      },

                      errorBuilder: (context, error, stackTrace) {
                        debugPrint("Error when fetching image: $error");
                        debugPrint("Stack Trace: $stackTrace");

                        return const Icon(Icons.broken_image);
                      }
                    ),
                  ),
                ),
                const SizedBox(width: 14),

                // ── Info column ──
                Expanded(
                  child: SizedBox(
                    height: 120,
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
                              item.desc,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.white70,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),

                        // ── Price + edit button row ──
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'RM${item.price}',
                              style: theme.textTheme.titleSmall?.copyWith(
                                color: theme.colorScheme.onPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),

                            Container(
                              width: 32,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black.withAlpha(67),
                              ),

                              child: IconButton(
                                onPressed: () => _goToEditScreen(context),
                                icon: Icon(
                                  Icons.edit,
                                  size: 14,
                                  color: theme.colorScheme.onPrimary,
                                )
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),


          _buildStatusLabel(theme),
          _buildStockCounter(theme),
        ],
      ),
    );
  }

  Widget _buildStatusLabel(ThemeData theme) {
    // shi like Public | Private | Sold
    return Positioned(
      top: -4,
      left: -4,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: item.isPublic ? const Color(0xFF00AA00) : const Color(0xFFAA0000),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12),
            bottomRight: Radius.circular(12),
          ),
        ),
        child: Text(
          item.isPublic ? "Public" : "Private",
          style: theme.textTheme.bodySmall?.copyWith(
            color:  Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 11,
          ),
        ),
      ),
    );
  }

  Widget _buildStockCounter(ThemeData theme) {
    return Positioned(
      top: 8,
      right: 8,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: theme.colorScheme.outline,
            width: 2,
          ),
        ),

        child: Text(
          'Stock: ${item.stock}',
          style: TextStyle(
            color: theme.colorScheme.onPrimary,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
