// TODO: fix this mess
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:i_bazaar/models/item.dart';
import 'package:i_bazaar/services/cache_handler.dart';
import 'package:i_bazaar/services/catalog_handler.dart';
import 'package:i_bazaar/screens/main/listings/listing_card.dart';
import 'package:i_bazaar/widgets/not_signed_in_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ListingsScreen extends StatefulWidget {
  const ListingsScreen({super.key});

  @override
  State<ListingsScreen> createState() => _ListingsScreenState();
}

class _ListingsScreenState extends State<ListingsScreen> {
  static const int _page = 1;
  late Future<List<Item>> _futureFunction; 

  @override
  void initState() {
    super.initState();
    _fetchListing();
  }

  Future<void> _fetchListing() async {
    final String userID = Supabase.instance.client.auth.currentUser!.id;

    _futureFunction = CatalogHandler.fetchRangedItems(
      page: _page,
      sortingOption: SortingOptions.uploadDate,
      userID: userID,
    );
  }

  Future<void> _refresh() async {
    final String userID = Supabase.instance.client.auth.currentUser!.id;

    // remove query from cache before rebuilding
    final String queryKey = CacheHandler.generateQuerykey(
      sortingOption: SortingOptions.uploadDate,
      filter: "UserID($userID)",
      page: _page,
    );
    CacheHandler.removeQueryFromCache(queryKey);

    // rebuild
    setState(() {
      _futureFunction = CatalogHandler.fetchRangedItems(
        page: _page,
        sortingOption: SortingOptions.uploadDate,
        userID: userID,
      );
    });
  }

  Future<void> _goCreate() async {
    final addedNewItem = await context.push<bool>("/create-listing");

    if (addedNewItem ?? false) _refresh();
  }

 
  Widget _buildListings() {
    return FutureBuilder<List<Item>>(
      future: _futureFunction,
      builder: (catalogContext, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());

        if (!snapshot.hasData || snapshot.data!.isEmpty) return SizedBox(child: Text("Error Displaying Catalog."));

        return _buildListingsView(snapshot.data!);
      }
    );
  }


  Widget _buildListingsView(List<Item> items) {
    final double horizontalPadding = 12.0;
    final double verticalPadding = 24.0;
    final double cardHeight = ListingCard.cardHeight;

    return ListView.builder(
      padding: EdgeInsets.fromLTRB(horizontalPadding, verticalPadding, horizontalPadding, verticalPadding + cardHeight),

      itemCount: items.length,
      itemBuilder: (itemContext, index) {
        return ListingCard(items[index], refreshScreen: _refresh);
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: StreamBuilder<AuthState>(
        stream: Supabase.instance.client.auth.onAuthStateChange,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data?.session == null) {
            return const NotSignedInScreen();
          }
          return RefreshIndicator(
            onRefresh: _refresh,
            child: _buildListings()
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _goCreate,
        backgroundColor: colorScheme.primaryContainer,
        tooltip: "Add New Listing",

        child: Icon(
          Icons.add,
          color: colorScheme.onPrimaryContainer
        ),
      ),
    );
  }
}
