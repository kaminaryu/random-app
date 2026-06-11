import 'package:flutter/material.dart';
import 'package:i_bazaar/models/item.dart';
import 'package:i_bazaar/widgets/listings/listing_card.dart';

class ListingsScreen extends StatefulWidget {
  const ListingsScreen({super.key});

  @override
  State<ListingsScreen> createState() => _ListingsScreenState();
}

class _ListingsScreenState extends State<ListingsScreen> {
  static const _mockListings = [
    Item(
      name: 'LightSaber (Red)',
      price: '6.70',
      desc: 'It works 100%, barely used.',
      stock: 12,
      status: "Public",
      imgSrc: 'red_lightsaber.png',
    ),
    Item(
      name: 'Dragon Figurine',
      price: '12.50',
      desc: 'Rare collectible, hand-painted.',
      stock: 54,
      status: "Public",
      imgSrc: 'dragon.png',
    ),
    Item(
      name: 'Green Boulder',
      price: '3.20',
      desc: 'Mysterious stone found in the woods.',
      stock: 234,
      status: "Hidden",
      imgSrc: 'green_boulder.png',
    ),
    Item(
      name: 'Crystal Vase',
      price: '24.99',
      desc: 'Elegant crystal vase, perfect for flowers.',
      stock: 8,
      status: "Hidden",
      imgSrc: 'dragon.png',
    ),
    Item(
      name: 'Vintage Watch',
      price: '89.00',
      desc: 'Mechanical watch from the 1960s, still ticking.',
      stock: 3,
      status: "Public",
      imgSrc: 'red_lightsaber.png',
    ),
    Item(
      name: 'Wooden Chair',
      price: '45.00',
      desc: 'Handcrafted oak chair, comfortable and sturdy.',
      stock: 15,
      status: "Hidden",
      imgSrc: 'green_boulder.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _mockListings.isEmpty
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
                maxCrossAxisExtent: 420,
                mainAxisExtent: 156,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
              ),
              itemCount: _mockListings.length,
              itemBuilder: (context, index) =>
                  ListingCard(_mockListings[index]),
            ),
    );
  }
}
