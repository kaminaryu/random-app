// NOTE: the menu bs is the most confusing code ive ever wrote..
// but it works... i think
import 'package:flutter/material.dart';
import 'package:i_bazaar/models/item.dart';
import 'package:i_bazaar/services/catalog_handler.dart';
import 'package:i_bazaar/widgets/homepage/item_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  SortingOptions _selectedSortingOption = SortingOptions.relevance;
  bool _isAscending = false;


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
        IconButton(
          onPressed: () => _showFilterMenu(context),
          icon: Icon(Icons.tune),
        ),

        // sort button
        IconButton(
          onPressed: () => _showSortMenu(context),
          icon: Icon(Icons.sort),
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
                onPressed: () {},
                label: "Relevance",
                sortingOption: SortingOptions.relevance,
                setMenuState: setMenuState,
              ),

              _buildSortButton(
                onPressed: () {},
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
                onPressed: () {},
                label: "Price",
                sortingOption: SortingOptions.price,
                setMenuState: setMenuState,
              ),

              _buildSortButton(
                onPressed: () {},
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
              setState(() => _isAscending = v);
              setMenuState(() {});
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
    required VoidCallback onPressed,
    required String label,
    required SortingOptions sortingOption,
    required StateSetter setMenuState,
  })
  {
    final colorScheme = Theme.of(context).colorScheme;
    final isSelected = sortingOption == _selectedSortingOption;

    return Expanded(
      child: OutlinedButton(
        onPressed: () {
          onPressed();
          setState(() {
            _selectedSortingOption = sortingOption;
          });
          setMenuState(() {});
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
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
        ),

        child: Text("Search the Catalog")
      ),

    );
  }


  Widget _buildCatalogGrid(List<Item> items) {
    return GridView.builder(
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          SizedBox(height: 16),

          _buildSearchRow(),
          SizedBox(height: 12),

          _buildSearchButton(),
          SizedBox(height: 12),

          Expanded(child: FutureBuilder<List<Item>>(
            future: CatalogHandler.fetchRangedItems(
              start: 0,
              end: 20,
              sortingOption: _selectedSortingOption,
              isAscending: _isAscending
            ),
            builder: (catalogContext, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());
    
              if (!snapshot.hasData) return Text("Failed lol");

              return _buildCatalogGrid(snapshot.data!);
            }
          ),
          ),
          SizedBox(height: 12),

          Text(_selectedSortingOption.queryColumn),
        ],
      )
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
// import 'package:i_bazaar/models/item.dart';
// import 'package:i_bazaar/services/catalog_handler.dart';
// import 'package:i_bazaar/widgets/homepage/item_card.dart';
//
// enum SortOption { relevance, price, alpha, rating }
//
// class SearchScreen extends StatefulWidget {
//   const SearchScreen({super.key});
//
//   @override
//   State<SearchScreen> createState() => _SearchScreenState();
// }
//
// class _SearchScreenState extends State<SearchScreen> {
//   final _searchController = TextEditingController();
//
//   String _query = '';
//   double _minPrice = 0;
//   double _maxPrice = 0;
//   RangeValues _priceRange = const RangeValues(0, 0);
//   SortOption _sortBy = SortOption.relevance;
//   bool _ascending = true;
//   bool _rangeLoaded = false;
//   var _hasSearched = false;
//
//   static const _pageSize = 6;
//
//   late final PagingController<int, Item> _pagingController = PagingController<int, Item>(
//     getNextPageKey: _getNextPageKey,
//     fetchPage: _fetchPage,
//   );
//
//   int? _getNextPageKey(PagingState<int, Item> state) {
//     if (state.pages == null || state.pages!.isEmpty) return 0;
//     final lastPage = state.pages!.last;
//     if (lastPage.length < _pageSize) return null;
//     final fetchedCount = state.pages!.fold(0, (sum, p) => sum + p.length);
//     return fetchedCount;
//   }
//
//   Future<List<Item>> _fetchPage(int pageKey) async {
//     return CatalogHandler.searchRangedItems(
//       query: _query.isEmpty ? null : _query,
//       priceMin: _rangeLoaded ? _priceRange.start : null,
//       priceMax: _rangeLoaded ? _priceRange.end : null,
//       sortBy: _sortBy == SortOption.relevance ? null : _sortBy.name,
//       ascending: _ascending,
//       start: pageKey,
//       end: pageKey + _pageSize - 1,
//     );
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _pagingController.addListener(() {
//       if (mounted) setState(() {});
//     });
//     _initPriceRange();
//   }
//
//   Future<void> _initPriceRange() async {
//     final range = await CatalogHandler.fetchPriceRange();
//     if (!mounted) return;
//     setState(() {
//       _minPrice = range.min;
//       _maxPrice = range.max;
//       _priceRange = RangeValues(range.min, range.max);
//       _rangeLoaded = true;
//     });
//   }
//
//   @override
//   void dispose() {
//     _searchController.dispose();
//     _pagingController.dispose();
//     super.dispose();
//   }
//
//   void _performSearch() {
//     _query = _searchController.text.trim();
//     _hasSearched = true;
//     _pagingController.refresh();
//   }
//
//   void _submitFilters() {
//     _pagingController.refresh();
//   }
//
//   void _showFilterSortSheet() {
//     var tempRange = _priceRange;
//     var tempSort = _sortBy;
//     var tempAscending = _ascending;
//
//     showModalBottomSheet(
//       context: context,
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setSheetState) {
//             return SingleChildScrollView(
//               child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text('Price Range', style: Theme.of(context).textTheme.titleSmall),
//                   const SizedBox(height: 8),
//                   RangeSlider(
//                     values: tempRange,
//                     min: _minPrice,
//                     max: _maxPrice,
//                     divisions: 50,
//                     labels: RangeLabels(
//                       'RM${tempRange.start.toStringAsFixed(2)}',
//                       'RM${tempRange.end.toStringAsFixed(2)}',
//                     ),
//                     onChanged: (v) => setSheetState(() => tempRange = v),
//                   ),
//                   const Divider(),
//                   Text('Sort By', style: Theme.of(context).textTheme.titleSmall),
//                   const SizedBox(height: 4),
//                   ...SortOption.values.map((opt) =>
//                     RadioListTile<SortOption>(
//                       dense: true,
//                       title: Text({
//                         SortOption.relevance: 'Relevance',
//                         SortOption.price: 'Price',
//                         SortOption.alpha: 'Alphabet',
//                         SortOption.rating: 'Rating',
//                       }[opt]!),
//                       value: opt,
//                       groupValue: tempSort,
//                       onChanged: (v) => setSheetState(() => tempSort = v!),
//                     ),
//                   ),
//                   CheckboxListTile(
//                     dense: true,
//                     title: const Text('Ascending'),
//                     value: tempAscending,
//                     onChanged: (v) => setSheetState(() => tempAscending = v!),
//                     controlAffinity: ListTileControlAffinity.leading,
//                   ),
//                   const SizedBox(height: 12),
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: () {
//                         setState(() {
//                           _priceRange = tempRange;
//                           _sortBy = tempSort;
//                           _ascending = tempAscending;
//                         });
//                         _submitFilters();
//                         Navigator.pop(context);
//                       },
//                       child: const Text('Apply'),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//           },
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
//             child: Column(
//               children: [
//                 Row(
//                   children: [
//                     Expanded(
//                       child: TextField(
//                         controller: _searchController,
//                         textInputAction: TextInputAction.search,
//                         decoration: const InputDecoration(
//                           hintText: 'Search items...',
//                           prefixIcon: Icon(Icons.search),
//                           border: OutlineInputBorder(),
//                         ),
//                         onSubmitted: (_) => _performSearch(),
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     IconButton(
//                       icon: const Icon(Icons.search),
//                       onPressed: _performSearch,
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 8),
//                 SizedBox(
//                   width: double.infinity,
//                   child: OutlinedButton.icon(
//                     icon: const Icon(Icons.filter_list),
//                     label: const Text('Filter & Sort'),
//                     onPressed: _showFilterSortSheet,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 8),
//           Expanded(
//             child: PagedGridView<int, Item>(
//               state: _pagingController.value,
//               fetchNextPage: _pagingController.fetchNextPage,
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 crossAxisSpacing: 12,
//                 mainAxisSpacing: 24,
//                 childAspectRatio: 0.7,
//               ),
//               builderDelegate: PagedChildBuilderDelegate<Item>(
//                 itemBuilder: (context, item, index) => ItemCard(item),
//                 firstPageProgressIndicatorBuilder: (_) =>
//                     const Center(child: CircularProgressIndicator()),
//                 noItemsFoundIndicatorBuilder: (_) =>
//                     Center(child: Text(
//                       _hasSearched ? 'No items found' : 'Search for items above',
//                     )),
//                 newPageProgressIndicatorBuilder: (_) =>
//                     const Padding(
//                       padding: EdgeInsets.all(16),
//                       child: Center(child: CircularProgressIndicator()),
//                     ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
