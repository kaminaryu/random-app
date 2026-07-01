import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:i_bazaar/models/item.dart';
import 'package:i_bazaar/screens/main/create_listing/widgets/thumbnail_picker.dart';
import 'package:i_bazaar/services/catalog_handler.dart';
import 'package:i_bazaar/services/listing_handler.dart';
import 'package:i_bazaar/widgets/auth/auth_text_field.dart';
import 'package:i_bazaar/widgets/auth/snack_bar.dart';
import 'package:image_picker/image_picker.dart';

class EditListingScreen extends StatefulWidget {
  const EditListingScreen(this.item, {super.key});

  final Item item;

  @override
  State<EditListingScreen> createState() => _EditListingScreenState();
}

class _EditListingScreenState extends State<EditListingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _shortDescController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController(text: '1');
  bool _isPublic = true;
  XFile? _imageFile;
  bool _isSubmitting = false;
  bool _thumbnailDeleted = false;


  @override
  void dispose() {
    _nameController.dispose();
    _shortDescController.dispose();
    _descController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }


  @override
  void initState() {
    super.initState();
    _fillInFields();
  }

  Future<void> _pickImage() async {
    // return if image already there
    if (_imageFile != null || !_thumbnailDeleted) return;

    final file = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
    );
    if (file != null) {
      setState(() => _imageFile = file);
    }
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_imageFile == null && _thumbnailDeleted) {
      AuthErrorSnackBar.show(
        ScaffoldMessenger.of(context),
        "Please select an image",
        Theme.of(context).colorScheme.error,
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      await ListingHandler.updateListing(
        itemID: widget.item.id,
        name: _nameController.text.trim(),
        price: double.parse(_priceController.text.trim()),
        desc: _descController.text.trim(),
        shortDesc: _shortDescController.text.trim(),
        stock: int.parse(_stockController.text.trim()),
        isPublic: _isPublic,
        imageFile: _imageFile,
      );

      if (!mounted) return;
      context.pop(true);
    } catch (e) {
      if (!mounted) return;
      AuthErrorSnackBar.show(
        ScaffoldMessenger.of(context),
        'Failed to edit listing: $e',
        Theme.of(context).colorScheme.error,
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _fillInFields() {
    Item item = widget.item;

    _nameController.text      = item.name;
    _shortDescController.text = item.shortDesc;
    _descController.text      = item.desc;
    _priceController.text     = item.price.toString();
    _stockController.text     = item.stock.toString();
    _isPublic                 = item.isPublic;
  }


  void _showConfirmationBox(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Item'),
          content: Text('Are you sure you want to delete ${widget.item.name}?'),
          actions: [
            TextButton(
              onPressed: () {
                context.pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                context.pop(true);

                ListingHandler.deleteList(
                  sellerID: widget.item.sellerID,
                  itemID: widget.item.id
                );
                context.pop(true);
              },
              child: Text('Confirm'),
            ),
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);


    return Scaffold(
      appBar: AppBar(title: const Text('Edit Listing')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildImagePicker(theme),
              const SizedBox(height: 20),

              _buildFormCard(theme),
              const SizedBox(height: 20),

              _buildSubmitButton(theme),
              const SizedBox(height: 16),

              _buildDeleteButton(theme),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker(ThemeData theme) {
    return Center(
      child: SizedBox(
        height: 200,
        width: 200,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: theme.colorScheme.outline,
                    width: 3,
                  ),
                ),
                child: _buildThumbnailPreview(theme),
              ),
            ),

            (_imageFile == null && _thumbnailDeleted)
            ? SizedBox()
            : ThumbnailPicker.buildDeleteButton(
                () => setState(() {
                    _imageFile = null;
                    _thumbnailDeleted = true;
                  }
                )
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnailPreview(ThemeData theme) {
    if (_imageFile != null) {
      return ThumbnailPicker.buildThumbnailPreview(_imageFile!);
    }

    if (_thumbnailDeleted) {
      return ThumbnailPicker.buildNoThumbnailPreview(theme);
    }

    return Image.network(
      CatalogHandler.fetchImageUrl(widget.item.sellerID, widget.item.id),
      width: 120,
      height: 120,
      fit: BoxFit.contain,

      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;

        return const Center(child: CircularProgressIndicator());
      },

      errorBuilder: (context, error, stackTrace) {
        debugPrint("Error when fetching image: $error");
        debugPrint("Stack Trace: $stackTrace");

        return const Icon(Icons.broken_image);
      }
    );
  }

  Widget _buildFormCard(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          AuthTextField(
            controller: _nameController,
            label: 'Item Name',
            icon: Icons.sell_outlined,
            validator: (v) =>
                v == null || v.trim().isEmpty ? 'Required' : null,
          ),
          const SizedBox(height: 16),

          AuthTextField(
            controller: _priceController,
            label: 'Price (RM)',
            icon: Icons.monetization_on_outlined,
            keyboardType: TextInputType.number,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Required';
              final price = double.tryParse(v.trim());
              if (price == null || price <= 0) return 'Enter a valid price';
              return null;
            },
          ),
          const SizedBox(height: 16),

          AuthTextField(
            controller: _stockController,
            label: 'Stock',
            icon: Icons.inventory_2_outlined,
            keyboardType: TextInputType.number,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Required';
              final stock = int.tryParse(v.trim());
              if (stock == null || stock < 0) return 'Enter a valid stock';
              return null;
            },
          ),
          const SizedBox(height: 16),

          AuthTextField(
            controller: _shortDescController,
            label: 'Short Description',
            icon: Icons.short_text,
            validator: (v) =>
                v == null || v.trim().isEmpty ? 'Required' : null,
          ),
          const SizedBox(height: 16),

          TextFormField(
            controller: _descController,
            maxLines: 3,
            validator: (v) =>
                v == null || v.trim().isEmpty ? 'Required' : null,
            decoration: const InputDecoration(
              labelText: 'Full Description',
              prefixIcon: Icon(Icons.description_outlined),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),

          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: (_isPublic)
              ? const Text("Public")
              : const Text("Private"),
            subtitle: (_isPublic)
              ? const Text("Visible to everyone")
              : const Text("Only visible to you"),
            value: _isPublic,
            activeTrackColor: theme.colorScheme.primary,
            onChanged: (v) => setState(() => _isPublic = v),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(ThemeData theme) {
    return FilledButton(
      onPressed: _isSubmitting ? null : _onSubmit,
      style: FilledButton.styleFrom(
        backgroundColor: theme.colorScheme.primary,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: (_isSubmitting)
        ? const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : const Text(
            'Update Listing',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
    );
  }

  Widget _buildDeleteButton(ThemeData theme) {
    return OutlinedButton(
      onPressed: () => _showConfirmationBox(context),
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.red,
        side: BorderSide(color: Colors.red, width: 2),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        )
      ),

      child: Text("Delete Listing"),
    );
  }
}

