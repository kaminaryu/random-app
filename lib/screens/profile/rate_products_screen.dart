import 'package:flutter/material.dart';
import 'package:i_bazaar/models/item.dart';
import 'package:i_bazaar/models/purchase.dart';
import 'package:i_bazaar/screens/profile/widgets/purchase_card.dart';
import 'package:i_bazaar/services/catalog_handler.dart';
import 'package:i_bazaar/services/purchases_handler.dart';
import 'package:i_bazaar/services/rating_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class PurchaseDetail {
  PurchaseDetail({required this.purchase, required this.item});

  final Purchase purchase; // fyi: for identification etc
  final Item item; // fyi: for displays
  double rating = 0.0;
}


class RateProductsScreen extends StatefulWidget {
  const RateProductsScreen({super.key});

  @override
  State<RateProductsScreen> createState() => _RateProductsScreenState();
}


class _RateProductsScreenState extends State<RateProductsScreen> {
  Future<List<PurchaseDetail>> _fetchPurchases() async {
    final SupabaseClient supabase = Supabase.instance.client;
    final User? user = supabase.auth.currentUser;

    if (user == null) throw "User is not logged in";

    final PurchasesHandler purchasesHandler = PurchasesHandler();
    final List<Purchase> purchaseRecords = await purchasesHandler.fetchUserPurchases(userId: user.id);

    List<PurchaseDetail> purchaseDetails = [];

    for (final Purchase purr in purchaseRecords) {
      final Item? item = await CatalogHandler.fetchItem(purr.itemId);

      if (item == null) {
        debugPrint("Error when fetching purchase record: Purchased Item does not exist");
        continue;
      }

      PurchaseDetail detail = PurchaseDetail(purchase: purr, item: item);

      purchaseDetails.add(detail);
    }

    return purchaseDetails;
  }


  // when user change the rating bar value
  void _onRatingBarValueChange(PurchaseDetail purchaseDetail, double rating) {
    purchaseDetail.rating = rating;
  }

  Future<void> _updateItemRating(PurchaseDetail purchaseDetail) async {
    RatingHandler ratingHandler = RatingHandler();

    final String itemId = purchaseDetail.purchase.itemId;
    final String userId = purchaseDetail.purchase.userId;
    final double rating = purchaseDetail.rating;

    await ratingHandler.rateItemPerUser(itemId: itemId, userId: userId, rating: rating);
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Purchase History')),
      body: Center(
        child: FutureBuilder<List<PurchaseDetail>>(
          future: _fetchPurchases(), 
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            if (!snapshot.hasData) {
              return Text('Something went wrong went fetching the purchase records');
            }

            List<PurchaseDetail> purchaseDetails = snapshot.data!;

            return ListView.builder(
              itemCount: purchaseDetails.length,
              itemBuilder: (historyContext, index) {
                final PurchaseDetail purchaseDetail = purchaseDetails[index];
                final Purchase purr = purchaseDetail.purchase;
                final Item purchasedItem = purchaseDetail.item;

                return PurchaseCard(
                  purchase: purr,
                  purchasedItem: purchasedItem,
                  onRatingBarValueChange: (newRating) => _onRatingBarValueChange(purchaseDetail, newRating),
                  onUpdateRating: () => _updateItemRating(purchaseDetail),
                );
              }
            );
        }
    )
      ),
    );
  }
}
