import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; 
import '../../../core/services/clodinary_service.dart';

class BlogImageEmbed {
  static Future<void> insertImage(QuillController controller) async {
    final ImagePicker picker = ImagePicker();
    
    // 1. Safely pick the image across platforms
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image == null) return;

    try {
      String? imageUrl;

      // 2. Platform ke hisab se upload trigger karein
      if (kIsWeb) {
        // 🌐 Web: Read direct file memory bytes array
        final Uint8List bytes = await image.readAsBytes();
        
        // Pass file as null and inject memory bytes into the named parameter
        imageUrl = await CloudinaryService.uploadImage(null, webBytes: bytes);
      } else {
        // 📱 Mobile: Use traditional dart:io path wrapper safely
        // Inline standard platform separation
        imageUrl = await CloudinaryService.uploadImage(File(image.path));
      }

      // 3. Check if upload failed
      if (imageUrl == null || imageUrl.isEmpty) {
        throw Exception("Cloudinary did not return a valid secure URL.");
      }

      // 4. Safely insert into Quill document without structural corruption
      final index = controller.selection.baseOffset;
      
      // Document block clean appending format
      controller.document.insert(index, '\n');
      controller.document.insert(index + 1, BlockEmbed.image(imageUrl));
      controller.document.insert(index + 2, '\n');
      
      // Advance cursor focus point
      controller.updateSelection(
        TextSelection.collapsed(offset: index + 3),
        ChangeSource.local,
      );

    } catch (e) {
      debugPrint("Error inserting rich-text image component: $e");
    }
  }
}