import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:i_bazaar/services/listing_handler.dart';
import 'package:i_bazaar/widgets/auth/auth_text_field.dart';
import 'package:i_bazaar/widgets/auth/snack_bar.dart';
import 'package:image_picker/image_picker.dart';

class CreateListingScreen extends StatefulWidget {
  const CreateListingScreen({super.key});

  @override
  State<CreateListingScreen> createState() => _CreateListingScreenState();
}

class _CreateListingScreenState extends State<CreateListingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _shortDescController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController(text: '1');
  bool _isPublic = true;
  XFile? _imageFile;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _shortDescController.dispose();
    _descController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
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
    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      await ListingHandler.createListing(
        name: _nameController.text.trim(),
        price: double.parse(_priceController.text.trim()),
        desc: _descController.text.trim(),
        shortDesc: _shortDescController.text.trim(),
        stock: int.parse(_stockController.text.trim()),
        isPublic: _isPublic,
        imageFile: _imageFile!,
      );

      if (!mounted) return;
      context.pop(true);
    } catch (e) {
      if (!mounted) return;
      AuthErrorSnackBar.show(
        ScaffoldMessenger.of(context),
        'Failed to create listing: $e',
        Colors.red,
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Create Listing')),
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
              const SizedBox(height: 24),
              _buildSubmitButton(theme),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker(ThemeData theme) {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: const Color(0xFF2D2A5E),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF7F77DD).withAlpha(80),
            width: 2,
          ),
        ),
        child: _imageFile != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.file(
                  File(_imageFile!.path),
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_photo_alternate_outlined,
                    size: 48,
                    color: const Color(0xFF7F77DD),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap to add image',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: const Color(0xFFCECBF6),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildFormCard(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2D2A5E),
        borderRadius: BorderRadius.circular(16),
      ),
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
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Public'),
            subtitle: const Text('Visible to everyone'),
            value: _isPublic,
            activeTrackColor: const Color(0xFF7F77DD),
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
        backgroundColor: const Color(0xFF7F77DD),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: _isSubmitting
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Text(
              'Create Listing',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
    );
  }
}
