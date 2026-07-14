// NOTE: the menu bs is the most confusing code ive ever wrote..
// but it works... i think
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:i_bazaar/models/item.dart';
import 'package:i_bazaar/services/cache_handler.dart';
import 'package:i_bazaar/services/catalog_handler.dart';
import 'package:i_bazaar/widgets/homepage/item_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();

  final ValueNotifier<bool> _isFiltering = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _isSorting   = ValueNotifier<bool>(false);

  static const int _page = 1;
  static const double _minPriceRange = 0;
  static const double _maxPriceRange = 1000;

  Future<List<Item>>? _searchFuture;

  SortingOptions _selectedSortingOption = SortingOptions.relevance;
  RangeValues _priceRange = RangeValues(_minPriceRange, _maxPriceRange);
  bool _isAscending = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    setState(() {
      _searchFuture = CatalogHandler.searchRangedItems(
        page: _page,
        query: _searchController.text,
        priceStart: _priceRange.start,
        priceEnd: _priceRange.end,
        sortingOption: _selectedSortingOption,
        isAscending: _isAscending,
      );
    });
  }

  Future<void> _refresh() async {
    final double priceStart = _priceRange.start;
    final double priceEnd   = _priceRange.end;

    final String queryKey = CacheHandler.generateQuerykey(
      sortingOption: _selectedSortingOption,
      filter: "PriceRange($priceStart,$priceEnd)",
      page: _page,
      query: _searchController.text,
    );
    CacheHandler.removeQueryFromCache(queryKey);

    setState(() {
      _searchFuture = CatalogHandler.searchRangedItems(
        page: _page,
        query: _searchController.text,
        priceStart: priceStart,
        priceEnd: priceEnd,
        sortingOption: _selectedSortingOption,
        isAscending: _isAscending,
      );
    });
  }


  Widget _buildSearchRow() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: "Search for items..",
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
          ),
        ),

        // filter button
        ValueListenableBuilder(
          valueListenable: _isFiltering,
          builder: (context, isFiltering, child) {
            return IconButton(
              onPressed: () => _showFilterMenu(context),
              tooltip: isFiltering ? 
                "Filter (Active)"
                : "Filter",
              icon: isFiltering ?
                Badge(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Icon(Icons.tune),
                )
                : Icon(Icons.tune),
            );
          }
        ),

        // sort button
        ValueListenableBuilder(
          valueListenable: _isSorting,
          builder: (context, isSorting, child) {
            return IconButton(
              onPressed: () => _showSortMenu(context),
              tooltip: isSorting ?
                "Sort (Active)"
                : "Sort",
              icon: isSorting ?
                Badge(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Icon(Icons.sort),
                )
                : Icon(Icons.sort),
            );
          }
        )
      ]
    );
  }


  void _showFilterMenu(BuildContext context) {
    _showMenu(
      context: context,
      menuBuilder: (sheetContext, setMenuState) {
        return [
          Text(
            "Filter Catalog",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(),

          RangeSlider(
            values: _priceRange,
            min: _minPriceRange,
            max: _maxPriceRange,
            divisions: 100,
            labels: RangeLabels(
              _priceRange.start.round().toString(),
              _priceRange.end == _maxPriceRange ? 
              "${_priceRange.end.round()}+"
              : _priceRange.end.round().toString(),
            ),
            onChanged: (RangeValues values) => setMenuState(() {
              _priceRange = values;
              _isFiltering.value = (
                _priceRange.start != _minPriceRange
                || _priceRange.end != _maxPriceRange
              );
            })
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Min'),
              Text('Max'),
            ],
          )
        ];
      }
    );
  }


  void _showSortMenu(BuildContext context) {
    _showMenu(
      context: context,
      menuBuilder: (sheetContext, setMenuState) {
        return [
          Text(
            "Sort Catalog",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12.0),

          Row(
            spacing: 14.0,
            children: [
              _buildSortButton(
                label: "Relevance",
                sortingOption: SortingOptions.relevance,
                setMenuState: setMenuState,
              ),

              _buildSortButton(
                label: "Upload Date",
                sortingOption: SortingOptions.uploadDate,
                setMenuState: setMenuState,
              ),
            ]
          ),
          SizedBox(height: 12.0),

          Row(
            spacing: 18.0,
            children: [
              _buildSortButton(
                label: "Price",
                sortingOption: SortingOptions.price,
                setMenuState: setMenuState,
              ),

              _buildSortButton(
                label: "Rating",
                sortingOption: SortingOptions.rating,
                setMenuState: setMenuState,
              ),
            ]
          ),

          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: (_isAscending)
              ? const Text("Ascending")
              : const Text("Descending"),
            subtitle: (_isAscending)
              ? const Text("Lowest -> Highest")
              : const Text("Highest -> Lowest"),
            value: _isAscending,
            activeTrackColor: Theme.of(context).colorScheme.primary,
            onChanged: (v) {
              setMenuState(() => _isAscending = v);
            },
          ),
        ];
      }
    );
  }


  void _showMenu({
    required BuildContext context,
    required List<Widget> Function(BuildContext, StateSetter) menuBuilder
  })
  {
    showModalBottomSheet(
      context: context,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (menuContext, setMenuState) {
            return Container(
              padding: EdgeInsets.fromLTRB(20.0, 16, 20.0, 0),
              height: MediaQuery.sizeOf(context).height * 0.5,
              child: SingleChildScrollView(
                child: Column(
                  children: menuBuilder(menuContext, setMenuState)
                )
              )
            );
          }
        );
      }
    );
  }


  Widget _buildSortButton({
    required String label,
    required SortingOptions sortingOption,
    required StateSetter setMenuState,
  })
  {
    final colorScheme = Theme.of(context).colorScheme;
    final isSelected = (sortingOption == _selectedSortingOption);

    return Expanded(
      child: OutlinedButton(
        onPressed: () {
          setMenuState(() => _selectedSortingOption = sortingOption);
          _isSorting.value = (_selectedSortingOption != SortingOptions.relevance);
        },
        style: OutlinedButton.styleFrom(
          backgroundColor: isSelected ? colorScheme.primary : colorScheme.surface,
          foregroundColor: isSelected ? colorScheme.surface : colorScheme.primary,
        ),

        child: Text(label),
      )
    );
  }


  Widget _buildSearchButton() {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _search(),
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
        ),

        child: Text("Search the Catalog")
      ),

    );
  }


  Widget _buildCatalog() {
    return Expanded(
      child: FutureBuilder<List<Item>>(
        future: _searchFuture,
        builder: (catalogContext, snapshot) {
          if (_searchFuture == null) {
            return Center(child: Text("You have not search anything yet."));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return SizedBox(child: Text("No result found."));
          }

          return _buildCatalogGrid(snapshot.data!);
        }
      ),
    );
  }


  Widget _buildCatalogGrid(List<Item> items) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: MasonryGridView.count(
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          SizedBox(height: 16),

          _buildSearchRow(),
          SizedBox(height: 12),

          _buildSearchButton(),
          SizedBox(height: 12),

          _buildCatalog(),
          SizedBox(height: 12),

          // Text(_selectedSortingOption.queryColumn),
        ],
      )
    );
  }
}
