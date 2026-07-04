// TODO: fix this mess
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:i_bazaar/models/item.dart';
import 'package:i_bazaar/services/cache_handler.dart';
import 'package:i_bazaar/services/catalog_handler.dart';
import 'package:i_bazaar/screens/main/listings/listing_card.dart';
import 'package:i_bazaar/services/listing_handler.dart';
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
    _refresh();
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
    _futureFunction = CatalogHandler.fetchRangedItems(
      page: _page,
      sortingOption: SortingOptions.uploadDate,
      userID: userID,
    );
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
        return ListingCard(items[index]);
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
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
    );
  }
}

/*
 final _items = <Item>[];
  bool _isLoading = false;
  bool _hasMore = true;
  static const _pageSize = 20;
  final int _page = 1;
  final _scrollController = ScrollController();
  late Future<List<Item>> _futureFunction;

  @override
  void initState() {
    super.initState();
    _fetchNextPage();
    _scrollController.addListener(_onScroll);

    _futureFunction = CatalogHandler.fetchRangedItems(
      page: _page,
      sortingOption: SortingOptions.uploadDate,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }


  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        _hasMore &&
        !_isLoading) {
      _fetchNextPage();
    }
  }


  Future<void> _fetchNextPage() async {
    setState(() => _isLoading = true);
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    final items =
      await CatalogHandler.fetchRangedItems(
        page: _page,
        sortingOption: SortingOptions.uploadDate,
        userID: user.id,
      );
    if (!mounted) return;
    setState(() {
      if (items.length < _pageSize) _hasMore = false;
      _items.addAll(items);
      _isLoading = false;
    });
  }


  Future<void> _refresh() async {
    setState(() {
      _items.clear();
      _hasMore = true;
    });
    await _fetchNextPage();
  }


  Future<void> _navigateToCreate() async {
    final created = await context.push<bool>('/create-listing');
    if (created == true) {
      _refresh();
    }
  }


  Widget _buildListings() {
    final body = _items.isEmpty && !_isLoading
        ? Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text("You have no listed product."),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Upload one now!",
                    style: TextStyle(decoration: TextDecoration.underline),
                  ),
                ),
              ],
            ),
          )
        : _items.isEmpty && _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _items.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.inventory_2_outlined,
                            size: 64, color: Colors.white38),
                        const SizedBox(height: 16),
                        Text(
                          'No listings yet',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(color: Colors.white54),
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                      const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: double.infinity,
                      mainAxisExtent: 156,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: _items.length + (_hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index >= _items.length) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      return ListingCard(_items[index], refreshScreen: _refresh);
                    },
                  );

    return Stack(
      children: [
        body,
        Positioned(
          right: 16,
          bottom: 16,
          child: FloatingActionButton(
            onPressed: _navigateToCreate,
            backgroundColor: Theme.of(context).colorScheme.tertiary,
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }
*/
