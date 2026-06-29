import 'package:flutter/material.dart';

class AddToCartButton extends StatelessWidget {
  const AddToCartButton({
    super.key,
    required this.price,
    required this.onPressed,
  });

  final double price;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 64,

      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: FloatingActionButton.extended(
          onPressed: onPressed,

          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,

          icon: Icon(
            Icons.shopping_cart,
            size: 24
          ),
          label: Text(
            'Add to Cart   I   RM${price.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 22,
            )
          ),
        ),
      ),
    );
  }
}
