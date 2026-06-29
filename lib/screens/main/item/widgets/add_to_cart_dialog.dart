import 'package:flutter/material.dart';
import 'package:i_bazaar/models/item.dart';
import 'package:i_bazaar/services/catalog_handler.dart';

class AddToCartDialog extends StatefulWidget {
  const AddToCartDialog({
    super.key,
    required this.item,
    required this.onConfirm,
  });

  final Item item;
  final void Function(int amount) onConfirm;

  @override
  State<AddToCartDialog> createState() => _AddToCartDialogState();
}

class _AddToCartDialogState extends State<AddToCartDialog> {
  int _amount = 1;

  void _increment() {
    if (_amount < widget.item.stock) {
      setState(() => _amount++);
    }
  }

  void _decrement() {
    if (_amount > 1) {
      setState(() => _amount--);
    }
  }

  Widget _buildThumbnail(ThemeData theme) {
    return SizedBox(
      width: 64,
      child: AspectRatio(
        aspectRatio: 1,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            CatalogHandler.fetchImageUrl(
              widget.item.sellerID,
              widget.item.id,
            ),
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.broken_image);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildItemDetails(ThemeData theme) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.item.name,
            style: theme.textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            widget.item.shortDesc,
            style: theme.textTheme.bodySmall!.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsRow(ThemeData theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildThumbnail(theme),
        const SizedBox(width: 12),

        _buildItemDetails(theme)
      ],
    );
  }

  Widget _buildAmountRow(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Amount Wanted', style: theme.textTheme.bodyLarge),
        Row(
          children: [
            IconButton(
              onPressed: _decrement,
              icon: const Icon(Icons.remove_circle_outline),
              style: IconButton.styleFrom(
                foregroundColor: (_amount == 1) ? 
                  Colors.grey
                  : Colors.black
              ),
            ),
            Text('$_amount', style: theme.textTheme.titleMedium),
            IconButton(
              onPressed: _increment,
              icon: const Icon(Icons.add_circle_outline),
              style: IconButton.styleFrom(
                foregroundColor: (_amount == widget.item.stock) ? 
                  Colors.grey
                  : Colors.black
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGrandTotal(ThemeData theme) {
    final grandTotal = widget.item.price * _amount;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Grand Total:', style: theme.textTheme.bodyLarge),
        Text(
          'RM${grandTotal.toStringAsFixed(2)}',
          style: theme.textTheme.titleMedium,
        ),
      ],
    );
  }

  Widget _buildConfirmButton() {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: () {
          widget.onConfirm(_amount);
          Navigator.of(context).pop();
        },
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Text('Confirm'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildDetailsRow(theme),
            const SizedBox(height: 16),

            _buildAmountRow(theme),
            const SizedBox(height: 12),

            _buildGrandTotal(theme),
            const SizedBox(height: 24),

            _buildConfirmButton(),
          ],
        ),
      ),
    );
  }
}
