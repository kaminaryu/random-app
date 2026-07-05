import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:i_bazaar/models/item.dart';
import 'package:i_bazaar/screens/main/listings/builders/listing_card_item_details.dart';
import 'package:i_bazaar/services/catalog_handler.dart';


class ListingCard extends StatefulWidget {
  const ListingCard(this.item, {super.key});

  final Item item;

  static const double cardHeight       = 128.0;
  static const double cardSpacing      = 12.0;
  static const double cardBorderRadius = 20.0;
  static const double thumbnailSize         = 96.0;
  static const double thumbnailPadding      = 12.0;
  static const double thumbnailBorderRadius = cardBorderRadius - thumbnailPadding;

  @override
  State<ListingCard> createState() => _ListingCardState();
}

class _ListingCardState extends State<ListingCard> {
  Widget _buildThumnail() {
    return Padding(
      padding: EdgeInsets.all(ListingCard.thumbnailPadding),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(ListingCard.thumbnailBorderRadius),
        child: Image.network(
          CatalogHandler.fetchImageUrl(widget.item.sellerID, widget.item.id),
          width: ListingCard.thumbnailSize,
          height: ListingCard.thumbnailSize,
          fit: BoxFit.cover,
        ),
      ),
    );
  }


  Widget _buildItemDetails(ColorScheme colorScheme) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: ListingCard.thumbnailPadding),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListingCardItemDetails.nameStatusRatingRow(widget.item, colorScheme),

            ListingCardItemDetails.shortDesc(widget.item, colorScheme),

            ListingCardItemDetails.priceStockRow(widget.item, colorScheme),
          ],
        ),
      )
    );
  }


  Widget _buildEditArea(ColorScheme colorScheme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.0),
      margin: EdgeInsets.only(left: ListingCard.thumbnailPadding),

      decoration: BoxDecoration(
        color: Color(0xFF583a6f),
        border: Border(
          left: BorderSide(
            color: Colors.black12,
            width: 2.0,
          ),
        ),
      ),

      child: GestureDetector(
        behavior: HitTestBehavior.opaque, // make it expand to parent instead of shrink to child
        onTap: () => context.push("/edit-listing", extra: widget.item),
        child: Icon(
          Icons.edit,
          color: colorScheme.onPrimary,
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => context.push("/item/?id=${widget.item.id}"),

      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: colorScheme.primary,
          borderRadius: BorderRadius.circular(ListingCard.cardBorderRadius),
        ),

        margin: EdgeInsets.only(bottom: ListingCard.cardSpacing),

        //     Tell the Row() children to have the same height as the tallest child
        child: IntrinsicHeight(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildThumnail(),

              _buildItemDetails(colorScheme),

              _buildEditArea(colorScheme),
            ],
          ),
        ),
      ),
    );
  }
}

// class ListingCard extends StatelessWidget {
//   const ListingCard(this.item, {super.key, required this.refreshScreen});
//
//   final Item item;
//   final VoidCallback refreshScreen;
//
//   void _goToEditScreen(BuildContext context) async {
//     final success = await context.push<bool>("/edit-listing", extra: item);
//
//     if (success == true) {
//       refreshScreen.call();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//
//     return GestureDetector(
//       onTap: () => context.push("/item/?id=${item.id}"),
//       child: Stack(
//         clipBehavior: Clip.none,
//         children: [
//           Container(
//             decoration: BoxDecoration(
//               color: theme.colorScheme.primary,
//               borderRadius: BorderRadius.circular(16),
//             ),
//             padding: const EdgeInsets.all(12),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(16),
//                   child: SizedBox(
//                     width: 120,
//                     height: 120,
//
//                     child: Image.network(
//                       CatalogHandler.fetchImageUrl(item.sellerID, item.id),
//                       width: 120,
//                       height: 120,
//                       fit: BoxFit.contain,
//
//                       loadingBuilder: (context, child, progress) {
//                         if (progress == null) return child;
//
//                         return const Center(child: CircularProgressIndicator());
//                       },
//
//                       errorBuilder: (context, error, stackTrace) {
//                         debugPrint("Error when fetching image: $error");
//                         debugPrint("Stack Trace: $stackTrace");
//
//                         return const Icon(Icons.broken_image);
//                       }
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 14),
//
//                 // ── Info column ──
//                 Expanded(
//                   child: SizedBox(
//                     height: 128,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               item.name,
//                               style: theme.textTheme.titleSmall?.copyWith(
//                                 color: Colors.white,
//                               ),
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                             const SizedBox(height: 2),
//
//                             Text(
//                               '@${item.sellerName}',
//                               style: theme.textTheme.bodySmall?.copyWith(
//                                 color: const Color(0xFFCECBF6),
//                               ),
//                             ),
//                             const SizedBox(height: 4),
//
//                             Text(
//                               item.desc,
//                               style: theme.textTheme.bodySmall?.copyWith(
//                                 color: Colors.white70,
//                               ),
//                               maxLines: 2,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ],
//                         ),
//
//                         // ── Price + edit button row ──
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               'RM${item.price}',
//                               style: theme.textTheme.titleSmall?.copyWith(
//                                 color: theme.colorScheme.onPrimary,
//                                 fontWeight: FontWeight.w700,
//                               ),
//                             ),
//
//                             Container(
//                               width: 32,
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color: Colors.black.withAlpha(67),
//                               ),
//
//                               child: IconButton(
//                                 onPressed: () => _goToEditScreen(context),
//                                 tooltip: "Edit Listing",
//                                 icon: Icon(
//                                   Icons.edit,
//                                   size: 14,
//                                   color: theme.colorScheme.onPrimary,
//                                 )
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//
//           _buildStatusLabel(theme),
//           _buildStockCounter(theme),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildStatusLabel(ThemeData theme) {
//     // shi like Public | Private | Sold
//     return Positioned(
//       top: -4,
//       left: -4,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//         decoration: BoxDecoration(
//           color: item.isPublic ? const Color(0xFF00AA00) : const Color(0xFFAA0000),
//           borderRadius: const BorderRadius.only(
//             topLeft: Radius.circular(12),
//             bottomRight: Radius.circular(12),
//           ),
//         ),
//         child: Text(
//           item.isPublic ? "Public" : "Private",
//           style: theme.textTheme.bodySmall?.copyWith(
//             color:  Colors.white,
//             fontWeight: FontWeight.w700,
//             fontSize: 11,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildStockCounter(ThemeData theme) {
//     return Positioned(
//       top: 8,
//       right: 8,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(
//             color: theme.colorScheme.outline,
//             width: 2,
//           ),
//         ),
//
//         child: Text(
//           'Stock: ${item.stock}',
//           style: TextStyle(
//             color: theme.colorScheme.onPrimary,
//             fontSize: 12,
//           ),
//         ),
//       ),
//     );
//   }
// }
