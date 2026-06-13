import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:i_bazaar/data/mock_lists.dart';
import 'package:i_bazaar/models/item.dart';
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
  RangeValues _priceRange = const RangeValues(0, 0);
  SortOption _sortBy = SortOption.relevance;
  bool _ascending = true;
  List<Item> _allFilteredItems = [];
  var _hasSearched = false;

  late double _minPrice;
  late double _maxPrice;

  static const _pageSize = 6;

  late final PagingController<int, Item> _pagingController = PagingController<int, Item>(
    getNextPageKey: _getNextPageKey,
    fetchPage: _fetchPage,
  );

  int? _getNextPageKey(PagingState<int, Item> state) {
    if (state.pages == null) return 0;
    final fetchedCount = state.pages!.fold(0, (sum, p) => sum + p.length);
    if (fetchedCount >= _allFilteredItems.length) return null;
    return fetchedCount;
  }

  Future<List<Item>> _fetchPage(int pageKey) async {
    final end = (pageKey + _pageSize).clamp(0, _allFilteredItems.length);
    return _allFilteredItems.sublist(pageKey, end);
  }

  @override
  void initState() {
    super.initState();
    _pagingController.addListener(() {
      if (mounted) setState(() {});
    });
    _initPriceRange();
  }

  void _initPriceRange() {
    final prices = MockLists.items.map((i) => double.parse(i.price));
    _minPrice = prices.reduce((a, b) => a < b ? a : b);
    _maxPrice = prices.reduce((a, b) => a > b ? a : b);
    _priceRange = RangeValues(_minPrice, _maxPrice);
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
    _applyFilters();
  }

  void _applyFilters() {
    _allFilteredItems = MockLists.items.where((item) {
      if (_query.isNotEmpty) {
        final q = _query.toLowerCase();
        if (!item.name.toLowerCase().contains(q) &&
            !item.desc.toLowerCase().contains(q) &&
            !item.seller.toLowerCase().contains(q)) {
          return false;
        }
      }
      final price = double.parse(item.price);
      return price >= _priceRange.start && price <= _priceRange.end;
    }).toList();

    _sortItems(_allFilteredItems);
    _pagingController.refresh();
  }

  void _sortItems(List<Item> items) {
    switch (_sortBy) {
      case SortOption.relevance:
        items.sort((a, b) => _relevanceScore(b).compareTo(_relevanceScore(a)));
      case SortOption.price:
        items.sort((a, b) => _ascending
            ? double.parse(a.price).compareTo(double.parse(b.price))
            : double.parse(b.price).compareTo(double.parse(a.price)));
      case SortOption.alpha:
        items.sort((a, b) => _ascending
            ? a.name.toLowerCase().compareTo(b.name.toLowerCase())
            : b.name.toLowerCase().compareTo(a.name.toLowerCase()));
      case SortOption.rating:
        items.sort((a, b) => b.rating.compareTo(a.rating));
    }
  }

  int _relevanceScore(Item item) {
    if (_query.isEmpty) return 0;

    final q = _query.toLowerCase();
    final name = item.name.toLowerCase();
    final desc = item.desc.toLowerCase();
    final seller = item.seller.toLowerCase();
    int score = 0;

    // check in name first
    if (name == q) {
      score += 10;
    } else if (name.startsWith(q)) {
      score += 7;
    } else if (name.contains(q)) {
      score += 5;
    }

    // check if desc have it
    if (desc.contains(q)) score += 3;

    // check if the seller 
    if (seller.contains(q)) score += 2;

    return score;
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
                        _applyFilters();
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
