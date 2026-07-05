import 'dart:io';
import 'package:flutter/foundation.dart'; // 👈 Needed for kIsWeb check
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/blog_model.dart';
import '../../core/services/blog_service.dart';
import '../../../core/services/clodinary_service.dart';
import 'widgets/blog_cover_picker.dart';
import 'widgets/blog_editor.dart';
import 'widgets/category_dropdown.dart';
import 'widgets/place_selector.dart';
import 'widgets/publish_button.dart';
import 'widgets/blog_image_embed.dart';

class CreateBlogScreen extends StatefulWidget {
  const CreateBlogScreen({super.key});

  @override
  State<CreateBlogScreen> createState() => _CreateBlogScreenState();
}

class _CreateBlogScreenState extends State<CreateBlogScreen> {
  final titleController = TextEditingController();
  final BlogService blogService = BlogService();
  final FirebaseAuth auth = FirebaseAuth.instance;
  
  late final QuillController quillController;
  final ImagePicker picker = ImagePicker();

  bool publishing = false;
  File? coverImage;
  Uint8List? coverImageBytes; // 👈 FIX: Added state container for web runtime previews
  String? selectedCategory;
  String? selectedPlaceId;
  String? selectedPlaceName;
  
  final uuid = const Uuid();

  @override
  void initState() {
    super.initState();
    quillController = QuillController.basic();
  }

  @override
  void dispose() {
    titleController.dispose();
    quillController.dispose();
    super.dispose();
  }

  Future<void> pickCoverImage() async {
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image == null) return;

    if (kIsWeb) {
      final bytes = await image.readAsBytes();
      setState(() {
        coverImageBytes = bytes;
      });
    } else {
      setState(() {
        coverImage = File(image.path);
      });
    }
  }

  Future<String?> uploadCoverImage() async {
    if (kIsWeb) {
      if (coverImageBytes == null) return null;
      return await CloudinaryService.uploadImage(null, webBytes: coverImageBytes);
    } else {
      if (coverImage == null) return null;
      return await CloudinaryService.uploadImage(coverImage!);
    }
  }

  Future<void> publishBlog() async {
    FocusScope.of(context).unfocus();

    if (titleController.text.trim().isEmpty) {
      _showSnackBar("Enter blog title");
      return;
    }
    if (kIsWeb ? (coverImageBytes == null) : (coverImage == null)) {
      _showSnackBar("Select cover image");
      return;
    }
    if (selectedCategory == null) {
      _showSnackBar("Select category");
      return;
    }
    if (selectedPlaceId == null) {
      _showSnackBar("Select related place");
      return;
    }

    final delta = quillController.document.toDelta();
    if (delta.isEmpty || quillController.document.toPlainText().trim().isEmpty) {
      _showSnackBar("Write something before publishing");
      return;
    }

    setState(() {
      publishing = true;
    });

    try {
      final uploadedUrl = await uploadCoverImage();
      if (uploadedUrl == null) {
        throw Exception("Failed to upload cover image.");
      }

      final user = auth.currentUser;
      if (user == null) {
        throw Exception("User session not found. Please log in again.");
      }

      final blogId = uuid.v4();

      final blog = BlogModel(
        id: blogId,
        title: titleController.text.trim(),
        coverImage: uploadedUrl,
        content: delta.toJson(), 
        category: selectedCategory!,
        relatedPlaceId: selectedPlaceId,
        authorId: user.uid,
        authorName: user.displayName ?? "Traveler",
        authorPhoto: user.photoURL,
        likes: 0,
        comments: 0,
        createdAt: Timestamp.now(),
        updatedAt: Timestamp.now(),
      );

      await blogService.publishBlog(blog);

      if (!mounted) return;
      _showSnackBar("Blog Published 🎉");
      Navigator.pop(context);
      
    } catch (e) {
      if (!mounted) return;
      _showSnackBar(e.toString());
      
      setState(() {
        publishing = false;
      });
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Write Travel Story"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---------------- COVER IMAGE ----------------
              // FIX: Now securely routing both runtime options to match component parameters
              BlogCoverPicker(
                image: coverImage,
                webImage: coverImageBytes,
                onTap: pickCoverImage,
              ),
              const SizedBox(height: 25),

              // ---------------- TITLE ----------------
              TextField(
                controller: titleController,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: "Give your travel story a title",
                  labelText: "Title",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // ---------------- RELATED PLACE ----------------
              PlaceSelector(
                selectedPlace: selectedPlaceName,
                onPlaceSelected: (id, name) {
                  setState(() {
                    selectedPlaceId = id;
                    selectedPlaceName = name;
                  });
                },
              ),
              const SizedBox(height: 20),

              // ---------------- CATEGORY ----------------
              CategoryDropdown(
                value: selectedCategory,
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value;
                  });
                },
              ),
              const SizedBox(height: 30),

              Text(
                "Write Your Story",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 15),

              // ---------------- TOOLBAR ----------------
              QuillSimpleToolbar(
                controller: quillController,
                config: const QuillSimpleToolbarConfig(
                  multiRowsDisplay: false,
                  showAlignmentButtons: true,
                  showBoldButton: true,
                  showItalicButton: true,
                  showUnderLineButton: true,
                  showStrikeThrough: false,
                  showInlineCode: false,
                  showCodeBlock: false,
                  showColorButton: false,
                  showBackgroundColorButton: false,
                  showDirection: false,
                  showFontFamily: false,
                  showFontSize: false,
                  showListBullets: true,
                  showListNumbers: true,
                  showQuote: true,
                  showUndo: true,
                  showRedo: true,
                  showSearchButton: false,
                ),
              ),
              const SizedBox(height: 12),

              Align(
                alignment: Alignment.centerLeft,
                child: FilledButton.icon(
                  onPressed: () async {
                    await BlogImageEmbed.insertImage(quillController);
                  },
                  icon: const Icon(Icons.image),
                  label: const Text("Insert Image"),
                ),
              ),
              const SizedBox(height: 15),

              // ---------------- EDITOR ----------------
              Container(
                constraints: const BoxConstraints(
                  minHeight: 450,
                ),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: Colors.grey.shade300,
                  ),
                ),
                child: BlogEditor(
                  controller: quillController,
                ),
              ),
              const SizedBox(height: 30),

              // ---------------- PUBLISH ----------------
              PublishButton(
                loading: publishing,
                onPressed: publishBlog,
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}