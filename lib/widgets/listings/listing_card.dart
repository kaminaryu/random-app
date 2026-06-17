import 'package:flutter/material.dart';
import 'package:i_bazaar/models/item.dart';
import 'package:i_bazaar/services/catalog_handler.dart';

class ListingCard extends StatelessWidget {
  const ListingCard(this.item, {super.key});

  final Item item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF2D2A5E),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Image ──
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  CatalogHandler.fetchImageUrl("${item.sellerID}/${item.name}.jpg"),
                  width: 120,
                  height: 120,
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
                              color: const Color(0xFF7F77DD),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          // ── Pencil edit button ──
                          InkWell(
                            onTap: () {
                              // TODO: future edit functionality
                            },
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: const Color(0xFF7F77DD).withAlpha(40),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Icon(
                                Icons.edit,
                                size: 18,
                                color: Color(0xFFCECBF6),
                              ),
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
          color: item.isPublic ? const Color(0xFF00FF00) : const Color(0xFFFF0000),
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
          color: const Color(0xFF1A1740).withAlpha(200),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: const Color(0xFF7F77DD).withAlpha(100),
            width: 1,
          ),
        ),
        child: Text(
          'Stock: ${item.stock}',
          style: const TextStyle(
            color: Color(0xFFCECBF6),
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
