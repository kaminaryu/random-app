import 'package:flutter/material.dart';
import 'package:i_bazaar/models/item.dart';
import 'package:i_bazaar/widgets/homepage/hero.dart';
import 'package:i_bazaar/widgets/homepage/item_card.dart';
import 'package:i_bazaar/widgets/homepage/section_title.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final items = [
    Item(name: "LightSaber (Red)", price: "6.70",  desc: "It works 100%",    seller: "Khazin", imgSrc: "red_lightsaber.png"),
    Item(name: "Dragon Figurine",  price: "12.50", desc: "Rare collectible", seller: "Ali",    imgSrc: "dragon.png"),
    Item(name: "Green Boulder",    price: "3.20",  desc: "Mysterious stone", seller: "Sara",   imgSrc: "green_boulder.png"),
    Item(name: "Green Boulder",    price: "3.20",  desc: "Mysterious stone", seller: "Sara",   imgSrc: "green_boulder.png"),
    Item(name: "Green Boulder",    price: "3.20",  desc: "Mysterious stone", seller: "Sara",   imgSrc: "green_boulder.png"),
    Item(name: "Green Boulder",    price: "3.20",  desc: "Mysterious stone", seller: "Sara",   imgSrc: "green_boulder.png"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: HomeHero()),
          SliverToBoxAdapter(child: SectionTitle("Catalogs")),
          SliverLayoutBuilder(builder: (context, constraints) {
            const columnsCount = 2;
            const crossAxisPadding = 24.0;
            const gapBetweenImageAndText = 8.0;
            const crossAxisSpacing = 12.0;
            const mainAxisSpacing = 24.0;
            const textBlockBaseHeight = 60.0;

            final widgetWidth = constraints.crossAxisExtent;
            final cardWidth = (widgetWidth - crossAxisPadding * 2 - crossAxisSpacing) / columnsCount;
            final textBlockHeight = textBlockBaseHeight * MediaQuery.textScalerOf(context).scale(1.0);

            final cardHeight = cardWidth + gapBetweenImageAndText + textBlockHeight;

            return SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: crossAxisPadding, vertical: mainAxisSpacing),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columnsCount,
                  crossAxisSpacing: crossAxisSpacing,
                  mainAxisSpacing: mainAxisSpacing,
                  mainAxisExtent: cardHeight,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) => ItemCard(items[index]),
                  childCount: items.length,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
