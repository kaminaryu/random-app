import 'package:flutter/material.dart';
import 'package:i_bazaar/models/item.dart';
import 'package:i_bazaar/models/purchase.dart';
import 'package:i_bazaar/screens/profile/widgets/purchase_card.dart';
import 'package:i_bazaar/services/catalog_handler.dart';
import 'package:i_bazaar/services/purchases_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PurchaseHistoryScreen extends StatefulWidget {
  const PurchaseHistoryScreen({super.key});

  @override
  State<PurchaseHistoryScreen> createState() => _PurchaseHistoryScreen();
}


class _PurchaseHistoryScreen extends State<PurchaseHistoryScreen> {
  List<Purchase> _purchases = [];
  Map<String, Item> _items = {};

  @override 
  void initState() {
    super.initState();
    _fetchPurchases();
  }


  Future<void> _fetchPurchases() async {
    final SupabaseClient supabase = Supabase.instance.client;
    final User? user = supabase.auth.currentUser;

    if (user == null) throw "User is not logged in";
    PurchasesHandler purchasesHandler = PurchasesHandler();

    _purchases = await purchasesHandler.fetchUserPurchases(userId: user.id);

    await _fetchItemDetails();

    setState(() {});
  }


  Future<void> _fetchItemDetails() async {
    for (final Purchase purr in _purchases) {
      if (_items.containsKey(purr.itemId)) {
        continue;
      }

      final Item item = await CatalogHandler.fetchItem(purr.itemId);
      _items[purr.itemId] = item;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Purchase History')),
      body: Center(
        child: ListView.builder(
          itemCount: _purchases.length,
          itemBuilder: (historyContext, index) {
            // dont ask why i use purr, i like it
            final Purchase purr = _purchases[index];
            final Item? purchasedItem = _items[purr.itemId];

            if (purchasedItem == null) throw "Bro the purchased item doesnt exist (${purr.itemId})";

            return PurchaseCard(purr, purchasedItem);
          }
        )
      ),
    );
  }
}
