import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:i_bazaar/models/item.dart';
import 'package:i_bazaar/screens/main/listings/builders/listing_card_item_details.dart';
import 'package:i_bazaar/services/catalog_handler.dart';


class ListingCard extends StatefulWidget {
  const ListingCard(this.item, {super.key, required this.refreshScreen});

  final Item item;
  final VoidCallback refreshScreen;

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
  late Item item;

  @override
  void initState() {
    super.initState();
    item = widget.item;
  }


  void _goEdit() async {
    Item? newItem = await context.push<Item>("/edit-listing", extra: item);

    if (newItem == null) {
      return;
    }

    // this is so dumb BUT IT WORKS LMAOOOOOOOOOOOOOOOOOOOOOOOOOOOO
    if (newItem.id == Item.deletedID) {
      widget.refreshScreen();
    }

    setState(() {
      item = newItem;
    });
  }


  Widget _buildThumnail() {
    return Padding(
      padding: EdgeInsets.all(ListingCard.thumbnailPadding),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(ListingCard.thumbnailBorderRadius),
        child: Image.network(
          CatalogHandler.fetchImageUrl(item.sellerID, item.id),
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
            ListingCardItemDetails.nameStatusRatingRow(item, colorScheme),

            ListingCardItemDetails.shortDesc(item, colorScheme),

            ListingCardItemDetails.priceStockRow(item, colorScheme),
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
        onTap: () => _goEdit(),
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
      onTap: () => context.push("/item/?id=${item.id}"),

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
