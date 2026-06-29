import 'package:flutter/material.dart';
import 'package:i_bazaar/services/cart_handler.dart';
import 'package:i_bazaar/widgets/main/main_app_bar.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  @override
  Widget build(BuildContext context) {
    CartHandler.debugPrintCartItems();

    return Scaffold(
      appBar: MainAppBar(),

      body: Column(
        children: [
          Text("hi")
        ],
      ),
    );
  }
}
