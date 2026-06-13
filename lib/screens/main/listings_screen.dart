import 'package:flutter/material.dart';
import 'package:i_bazaar/data/mock_lists.dart';
import 'package:i_bazaar/widgets/listings/listing_card.dart';

class ListingsScreen extends StatefulWidget {
  const ListingsScreen({super.key});

  @override
  State<ListingsScreen> createState() => _ListingsScreenState();
}

class _ListingsScreenState extends State<ListingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MockLists.items.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.inventory_2_outlined,
                      size: 64, color: Colors.white38),
                  const SizedBox(height: 16),
                  Text(
                    'No listings yet',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Colors.white54,
                        ),
                  ),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: double.infinity,
                mainAxisExtent: 156,
                mainAxisSpacing: 16,
              ),
              itemCount: MockLists.items.length,
              itemBuilder: (context, index) =>
                  ListingCard(MockLists.items[index]),
            ),
    );
  }
}
