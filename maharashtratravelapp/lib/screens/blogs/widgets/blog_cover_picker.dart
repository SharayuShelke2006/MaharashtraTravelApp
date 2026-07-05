import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class BlogCoverPicker extends StatelessWidget {
  final File? image;
  final Uint8List? webImage;
  final VoidCallback onTap;

  const BlogCoverPicker({
    super.key,
    required this.image,
    this.webImage,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 220,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: _buildImage(context),
      ),
    );
  }

  Widget _buildImage(BuildContext context) {

    if (kIsWeb) {

      if (webImage == null) {
        return const Center(
          child: Text("Choose Cover Image"),
        );
      }

      return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.memory(
          webImage!,
          fit: BoxFit.cover,
        ),
      );
    }

    if (image == null) {
      return const Center(
        child: Text("Choose Cover Image"),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Image.file(
        image!,
        fit: BoxFit.cover,
      ),
    );
  }
}