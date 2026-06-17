import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:i_bazaar/models/item.dart';
import 'package:i_bazaar/services/catalog_handler.dart';
import 'package:i_bazaar/widgets/homepage/item_card.dart';

enum SortOption { relevance, price, alpha, rating }

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();

  String _query = '';
  double _minPrice = 0;
  double _maxPrice = 0;
  RangeValues _priceRange = const RangeValues(0, 0);
  SortOption _sortBy = SortOption.relevance;
  bool _ascending = true;
  bool _rangeLoaded = false;
  var _hasSearched = false;

  static const _pageSize = 6;

  late final PagingController<int, Item> _pagingController = PagingController<int, Item>(
    getNextPageKey: _getNextPageKey,
    fetchPage: _fetchPage,
  );

  int? _getNextPageKey(PagingState<int, Item> state) {
    if (state.pages == null || state.pages!.isEmpty) return 0;
    final lastPage = state.pages!.last;
    if (lastPage.length < _pageSize) return null;
    final fetchedCount = state.pages!.fold(0, (sum, p) => sum + p.length);
    return fetchedCount;
  }

  Future<List<Item>> _fetchPage(int pageKey) async {
    return CatalogHandler.searchRangedItems(
      query: _query.isEmpty ? null : _query,
      priceMin: _rangeLoaded ? _priceRange.start : null,
      priceMax: _rangeLoaded ? _priceRange.end : null,
      sortBy: _sortBy == SortOption.relevance ? null : _sortBy.name,
      ascending: _ascending,
      start: pageKey,
      end: pageKey + _pageSize - 1,
    );
  }

  @override
  void initState() {
    super.initState();
    _pagingController.addListener(() {
      if (mounted) setState(() {});
    });
    _initPriceRange();
  }

  Future<void> _initPriceRange() async {
    final range = await CatalogHandler.fetchPriceRange();
    if (!mounted) return;
    setState(() {
      _minPrice = range.min;
      _maxPrice = range.max;
      _priceRange = RangeValues(range.min, range.max);
      _rangeLoaded = true;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _pagingController.dispose();
    super.dispose();
  }

  void _performSearch() {
    _query = _searchController.text.trim();
    _hasSearched = true;
    _pagingController.refresh();
  }

  void _submitFilters() {
    _pagingController.refresh();
  }

  void _showFilterSortSheet() {
    var tempRange = _priceRange;
    var tempSort = _sortBy;
    var tempAscending = _ascending;

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return SingleChildScrollView(
              child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Price Range', style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 8),
                  RangeSlider(
                    values: tempRange,
                    min: _minPrice,
                    max: _maxPrice,
                    divisions: 50,
                    labels: RangeLabels(
                      'RM${tempRange.start.toStringAsFixed(2)}',
                      'RM${tempRange.end.toStringAsFixed(2)}',
                    ),
                    onChanged: (v) => setSheetState(() => tempRange = v),
                  ),
                  const Divider(),
                  Text('Sort By', style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 4),
                  ...SortOption.values.map((opt) =>
                    RadioListTile<SortOption>(
                      dense: true,
                      title: Text({
                        SortOption.relevance: 'Relevance',
                        SortOption.price: 'Price',
                        SortOption.alpha: 'Alphabet',
                        SortOption.rating: 'Rating',
                      }[opt]!),
                      value: opt,
                      groupValue: tempSort,
                      onChanged: (v) => setSheetState(() => tempSort = v!),
                    ),
                  ),
                  CheckboxListTile(
                    dense: true,
                    title: const Text('Ascending'),
                    value: tempAscending,
                    onChanged: (v) => setSheetState(() => tempAscending = v!),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _priceRange = tempRange;
                          _sortBy = tempSort;
                          _ascending = tempAscending;
                        });
                        _submitFilters();
                        Navigator.pop(context);
                      },
                      child: const Text('Apply'),
                    ),
                  ),
                ],
              ),
            ),
          );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        textInputAction: TextInputAction.search,
                        decoration: const InputDecoration(
                          hintText: 'Search items...',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(),
                        ),
                        onSubmitted: (_) => _performSearch(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: _performSearch,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.filter_list),
                    label: const Text('Filter & Sort'),
                    onPressed: _showFilterSortSheet,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: PagedGridView<int, Item>(
              state: _pagingController.value,
              fetchNextPage: _pagingController.fetchNextPage,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 24,
                childAspectRatio: 0.7,
              ),
              builderDelegate: PagedChildBuilderDelegate<Item>(
                itemBuilder: (context, item, index) => ItemCard(item),
                firstPageProgressIndicatorBuilder: (_) =>
                    const Center(child: CircularProgressIndicator()),
                noItemsFoundIndicatorBuilder: (_) =>
                    Center(child: Text(
                      _hasSearched ? 'No items found' : 'Search for items above',
                    )),
                newPageProgressIndicatorBuilder: (_) =>
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
