import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:i_bazaar/models/item.dart';
import 'package:i_bazaar/services/cart_handler.dart';
import 'package:i_bazaar/services/catalog_handler.dart';


class CartCard extends StatelessWidget {
  const CartCard({
    super.key, 
    required this.item,
    required this.amount,
    required this.isSelected,
    required this.toggleItemSelection,
    required this.changeAmountInCart,
    required this.onDelete
  });

  final Item item;
  final int amount;
  final bool isSelected;
  final void Function(String) toggleItemSelection; // could use ValueSetter or ValueChanged; but explicit are easier to understand
  final void Function(Item, int) changeAmountInCart;
  final VoidCallback onDelete; // ts could be void Function()

  static const double cardSpacing      = 12.0;
  static const double cardBorderRadius = 20.0;
  static const double thumbnailSize         = 80.0;
  static const double thumbnailPadding      = 12.0;
  static const double thumbnailBorderRadius = cardBorderRadius - thumbnailPadding; // this code made it so that the other const needs to be const instead of final


  Widget _buildCheckBox() {
    return Checkbox(
      value: isSelected,
      onChanged: (bool? newValue) => toggleItemSelection(item.id),
    );
  }

  Widget _buildThumbnail() {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        margin: EdgeInsets.only(top: thumbnailPadding, right: thumbnailPadding),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(thumbnailBorderRadius),
        ),

        child: ClipRRect(
          borderRadius: BorderRadius.circular(thumbnailBorderRadius),
          child: Image.network(
            CatalogHandler.fetchImageUrl(item.sellerId, item.id),
            width: thumbnailSize,
            height: thumbnailSize,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }


  Widget _buildPriceRow(ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'RM${item.price.toStringAsFixed(2)}',
          style: TextStyle(
            color: Colors.lightGreenAccent,
            fontWeight: FontWeight.w900,
            fontSize: 18,
          ),
        ),

        Row(
          spacing: 4.0,
          children: [
            GestureDetector(
              // block click if the buttton is disabled
              onTap: () {},
              child: IconButton(
                onPressed: (amount > 1) ? () => changeAmountInCart(item, -1) : null,
                icon: Icon(Icons.remove),
                iconSize: 14,
                padding: EdgeInsets.all(4.0),
                constraints: BoxConstraints(),
                style: IconButton.styleFrom(
                  foregroundColor: colorScheme.onPrimary,
                  backgroundColor: colorScheme.tertiary,
                ),
              ),
            ),

            Text(
              "$amount",
              style: TextStyle(
                color: colorScheme.onPrimary,
              ),
            ),

            GestureDetector(
              // block click if the buttton is disabled
              onTap: () {},
              child: IconButton(
                onPressed: (amount < item.stock) ? () => changeAmountInCart(item, 1) : null,
                icon: Icon(Icons.add),
                iconSize: 14,
                padding: EdgeInsets.all(4.0),
                constraints: BoxConstraints(),
                style: IconButton.styleFrom(
                  foregroundColor: colorScheme.onPrimary,
                  backgroundColor: colorScheme.tertiary,
                ),
              )
          )
          ],
        )
      ],
    );
  }


  Widget _buildItemDetails(ColorScheme colorScheme) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: thumbnailPadding),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.name,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w700,
                color: colorScheme.onPrimary,
              ),
            ),
            const SizedBox(height: 2),

            Text(
              '@${item.sellerName}',
              style: TextStyle(
                color: colorScheme.onPrimary.withAlpha(167),
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 4),

            Text(
              " ${item.shortDesc}",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: colorScheme.onPrimary.withAlpha(167),
                fontSize: 14.0,
                fontStyle: FontStyle.italic,
              ),
            ),

            _buildPriceRow(colorScheme),
          ],
        ),
      ),
    );
  }


  Widget _buildDeleteArea(ColorScheme colorScheme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      margin: EdgeInsets.only(left: thumbnailPadding),

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
        behavior: HitTestBehavior.opaque,
        onTap: () async {
          // await CartHandler.removeItemFromCart(itemId: item.id);
          onDelete();
        },
        child: Icon(
          Icons.delete,
          color: Colors.redAccent,
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
          borderRadius: BorderRadius.circular(cardBorderRadius),
        ),

        margin: EdgeInsets.only(bottom: cardSpacing),

        child: IntrinsicHeight(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildCheckBox(),

              _buildThumbnail(),

              _buildItemDetails(colorScheme),

              _buildDeleteArea(colorScheme),
            ],
          ),
        ),
      ),
    );
  }
}
