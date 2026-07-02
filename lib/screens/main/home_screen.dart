import 'package:flutter/material.dart';
import 'package:i_bazaar/models/item.dart';
import 'package:i_bazaar/services/catalog_handler.dart';
import 'package:i_bazaar/widgets/homepage/hero.dart';
import 'package:i_bazaar/widgets/homepage/item_card.dart';
import 'package:i_bazaar/widgets/homepage/section_title.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List catalog = [];
  bool isLoading = true;

  final int _startSearch = 0;
  final int _endSearch   = 20;

  @override
  void initState() {
    super.initState();
    fetchCatalog();
  }

  Future<void> fetchCatalog() async {
    final result = await CatalogHandler.fetchRangedItems(
      start: _startSearch,
      end: _endSearch,
      sortingOption: SortingOptions.uploadDate,
    );
    setState(() {
      catalog = result;
      isLoading = false;
    });
  }

  Widget _buildCatalog() {
    return 
       FutureBuilder<List<Item>>(
        future: CatalogHandler.fetchRangedItems(
          start: _startSearch,
          end: _endSearch,
          sortingOption: SortingOptions.uploadDate,
        ),
        builder: (catalogContext, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());

          if (!snapshot.hasData || snapshot.data!.isEmpty) return SizedBox(child: Text("Error Displaying Catalog."));

          return _buildCatalogGrid(snapshot.data!);
        }
    );
  }

  Widget _buildCatalogGrid(List<Item> items) {
    return GridView.builder(
      shrinkWrap: true, // wraps children
      physics: const NeverScrollableScrollPhysics(), // do not scroll itself
      padding: EdgeInsets.symmetric(horizontal: 24.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 8.0,
        childAspectRatio: 9/16,
      ),

      itemCount: items.length,
      itemBuilder: (itemContext, index) {
        return ItemCard(items[index]);
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
