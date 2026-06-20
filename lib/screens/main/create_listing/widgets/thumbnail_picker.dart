import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ThumbnailPicker {
  static Widget buildNoThumbnailPreview(ThemeData theme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.add_photo_alternate_outlined,
          size: 48,
          color: theme.colorScheme.secondary,
        ),
        const SizedBox(height: 8),
        Text(
          'Tap to add image',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }


  static Widget buildThumbnailPreview(XFile imageFile) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Image.file(
        File(imageFile.path),
        width: double.infinity,
        height: 200,
        fit: BoxFit.contain,
      ),
    );
  }


  static Widget buildDeleteButton(VoidCallback removeThumbnail) {
    return Positioned(
      top: -12,
      right: -12,
      child: Container(
        width: 36,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.red,
        ),

        child: IconButton(
          onPressed: removeThumbnail,
          icon: const Icon(Icons.delete),
          iconSize: 20.0,
          color: Colors.white,
        ),
      ),
    );
  }
}
