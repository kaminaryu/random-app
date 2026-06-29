import 'package:flutter/material.dart';
import 'package:i_bazaar/models/item.dart';
import 'package:i_bazaar/screens/main/item/widgets/add_to_cart_button.dart';
import 'package:i_bazaar/screens/main/item/widgets/item_details.dart';
import 'package:i_bazaar/screens/main/item/widgets/item_metadata_label.dart';
import 'package:i_bazaar/screens/main/item/widgets/item_thumbnail.dart';
import 'package:i_bazaar/services/catalog_handler.dart';
import 'package:i_bazaar/widgets/main/main_app_bar.dart';

class ItemScreen extends StatelessWidget {
  const ItemScreen({super.key, required this.itemID});

  final String itemID;

  Widget _buildItemScreen(Item item, ThemeData theme) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ItemThumbnail(item: item, theme: theme),

          ItemMetadataLabel(item: item, theme: theme),

          ItemDetails(item: item, theme: theme),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Item>(
      future: CatalogHandler.fetchItem(itemID),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            appBar: MainAppBar(),
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (!snapshot.hasData) {
          return const Scaffold(
            appBar: MainAppBar(),
            body: Center(child: Text('Error loading item')),
          );
        }

        final item = snapshot.data!;

        return Scaffold(
          appBar: MainAppBar(label: item.name),

          body: _buildItemScreen(item, Theme.of(context)),

          floatingActionButton: AddToCartButton(
            price: item.price,
            onPressed: () {},
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        );
      },
    );
  }
}
