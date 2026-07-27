import 'package:flutter/material.dart';
import 'package:i_bazaar/models/item.dart';
import 'package:i_bazaar/screens/main/item/widgets/add_to_cart_button.dart';
import 'package:i_bazaar/screens/main/item/widgets/item_details.dart';
import 'package:i_bazaar/screens/main/item/widgets/item_metadata_label.dart';
import 'package:i_bazaar/screens/main/item/widgets/item_thumbnail.dart';
import 'package:i_bazaar/services/cache_handler.dart';
import 'package:i_bazaar/services/catalog_handler.dart';
import 'package:i_bazaar/widgets/main/main_app_bar.dart';

class ItemScreen extends StatefulWidget {
  const ItemScreen({super.key, required this.itemId});
  final String itemId;

  @override
  State<ItemScreen> createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {
  late Future<Item?> _itemFuture;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    // remove the cache and refresh the page
    CacheHandler.removeItemFromCache(widget.itemId);
    _itemFuture = CatalogHandler.fetchItem(widget.itemId);

    // wait for the future to be fully fetched (so that RefreshIndicator() doesnt ping "done" early)
    await _itemFuture;

    setState(() {});
  }

  Widget _buildItemScreen(Item item, ThemeData theme) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ItemThumbnail(item: item, theme: theme),
          ItemMetadataLabel(item: item, theme: theme),
          ItemDetails(item: item, theme: theme),
          const SizedBox(height: 64),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Item?>(
      future: _itemFuture,
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
          body: RefreshIndicator(
            onRefresh: _refresh,
            child: _buildItemScreen(item, Theme.of(context)),
          ),
          floatingActionButton: AddToCartButton(
            price: item.price,
            item: item,

          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        );
      },
    );
  }
}
