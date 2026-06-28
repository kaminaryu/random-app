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
    final isSelected = sortingOption == _selectedSortingOption;

    return Expanded(
      child: OutlinedButton(
        onPressed: () {
          setMenuState(() => _selectedSortingOption = sortingOption);
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
        onPressed: () => setState(() {}), // rebuilds the screen
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
