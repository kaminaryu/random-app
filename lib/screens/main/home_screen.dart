import 'package:flutter/material.dart';
import 'package:i_bazaar/models/item.dart';
import 'package:i_bazaar/services/cache_handler.dart';
import 'package:i_bazaar/services/catalog_handler.dart';
import 'package:i_bazaar/widgets/homepage/hero.dart';
import 'package:i_bazaar/widgets/homepage/item_card.dart';
import 'package:i_bazaar/widgets/homepage/section_title.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List catalog = [];
  bool isLoading = true;
  late Future<List<Item>> _futureFunction;

  final int _page = 1;

  @override
  void initState() {
    super.initState();
    fetchCatalog();
    _futureFunction = CatalogHandler.fetchRangedItems(
      page: _page,
      sortingOption: SortingOptions.uploadDate,
    );
  }

  Future<void> _refresh() async {
    setState(() {
      // refresh the grid
      final String queryKey = CacheHandler.generateQuerykey(sortingOption: SortingOptions.uploadDate, page: _page);
      CacheHandler.removeQueryFromCache(queryKey);

      _futureFunction = CatalogHandler.fetchRangedItems(
        page: _page,
        sortingOption: SortingOptions.uploadDate,
      );
    });

    // await the refreshing
    await _futureFunction;
  }


  Future<void> fetchCatalog() async {
    final result = await CatalogHandler.fetchRangedItems(
      page: _page,
      sortingOption: SortingOptions.uploadDate,
    );
    setState(() {
      catalog = result;
      isLoading = false;
    });
  }

  Widget _buildCatalog() {
    return FutureBuilder<List<Item>>(
      future: _futureFunction,
      builder: (catalogContext, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());

        if (!snapshot.hasData || snapshot.data!.isEmpty) return SizedBox(child: Text("Error Displaying Catalog."));

        return _buildCatalogGrid(snapshot.data!);
      }
    );
  }

  Widget _buildCatalogGrid(List<Item> items) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: MasonryGridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        itemCount: items.length,
        itemBuilder: (itemContext, index) {
          return ItemCard(items[index]);
        },
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: SingleChildScrollView(
        child: Column(
          children: [
            HomeHero(),
            SectionTitle("Recently Uploaded Products"),
            SizedBox(height: 16),

            _buildCatalog()
          ],
        ),
      ),
    );
  }
}
