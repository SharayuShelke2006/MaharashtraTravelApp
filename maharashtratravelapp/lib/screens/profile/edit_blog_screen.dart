import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/services/clodinary_service.dart';
import '../../models/blog_model.dart';
import '../blogs/widgets/blog_cover_picker.dart';
import '../blogs/widgets/blog_editor.dart';
import '../blogs/widgets/blog_image_embed.dart';
import '../blogs/widgets/category_dropdown.dart';
import '../blogs/widgets/place_selector.dart';
import '../blogs/widgets/publish_button.dart';

class EditBlogScreen extends StatefulWidget {
  final BlogModel blog;

  const EditBlogScreen({
    super.key,
    required this.blog,
  });

  @override
  State<EditBlogScreen> createState() =>
      _EditBlogScreenState();
}

class _EditBlogScreenState
    extends State<EditBlogScreen> {
  final titleController =
      TextEditingController();

  late QuillController
      quillController;

  final ImagePicker picker =
      ImagePicker();

  bool publishing = false;

  File? coverImage;

  Uint8List? coverImageBytes;

  String? networkCover;

  bool coverChanged = false;

  String? selectedCategory;

  String? selectedPlaceId;

  String? selectedPlaceName;

  @override
  void initState() {
    super.initState();

    titleController.text =
        widget.blog.title;

    networkCover =
        widget.blog.coverImage;

    selectedCategory =
        widget.blog.category;

    selectedPlaceId =
        widget.blog.relatedPlaceId;

    quillController =
        QuillController(
      document: Document.fromJson(
        widget.blog.content,
      ),
      selection:
          const TextSelection.collapsed(
        offset: 0,
      ),
    );

    loadPlaceName();
  }

  Future<void> loadPlaceName() async {
    if (selectedPlaceId == null) return;

    final doc =
        await FirebaseFirestore.instance
            .collection("places")
            .doc(selectedPlaceId)
            .get();

    if (!doc.exists) return;

    setState(() {
      selectedPlaceName =
          doc["name"];
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    quillController.dispose();
    super.dispose();
  }

  Future<void> pickCoverImage() async {
    final XFile? image =
        await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image == null) return;

    coverChanged = true;

    if (kIsWeb) {
      final bytes =
          await image.readAsBytes();

      setState(() {
        coverImageBytes = bytes;
      });
    } else {
      setState(() {
        coverImage =
            File(image.path);
      });
    }
  }

  Future<String?> uploadCover() async {
    if (!coverChanged) {
      return networkCover;
    }

    if (kIsWeb) {
      return await CloudinaryService
          .uploadImage(
        null,
        webBytes: coverImageBytes,
      );
    }

    return await CloudinaryService
        .uploadImage(
      coverImage,
    );
  }

  void showMessage(String msg) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(msg),
      ),
    );
  }

  Future<void> updateBlog() async {
    FocusScope.of(context).unfocus();

    if (titleController.text
        .trim()
        .isEmpty) {
      showMessage("Enter blog title");
      return;
    }

    if (selectedCategory == null) {
      showMessage("Select category");
      return;
    }

    if (selectedPlaceId == null) {
      showMessage("Select related place");
      return;
    }

    final delta =
        quillController.document.toDelta();

    if (delta.isEmpty ||
        quillController.document
            .toPlainText()
            .trim()
            .isEmpty) {
      showMessage(
          "Write something before updating");
      return;
    }

    setState(() {
      publishing = true;
    });

    try {
      final cover =
          await uploadCover();

      await FirebaseFirestore.instance
          .collection("blogs")
          .doc(widget.blog.id)
          .update({
        "title":
            titleController.text.trim(),
        "coverImage": cover,
        "content": delta.toJson(),
        "category":
            selectedCategory,
        "relatedPlaceId":
            selectedPlaceId,
        "updatedAt":
            Timestamp.now(),
      });

      if (!mounted) return;

      showMessage("Blog Updated 🎉");

      Navigator.pop(context, true);
            } catch (e) {
        showMessage(e.toString());
      }

      if (!mounted) return;

      setState(() {
        publishing = false;
      });
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Edit Travel Story",
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [

                BlogCoverPicker(
                  image: coverImage,
                  webImage: coverImageBytes,
                  //networkImage: networkCover,
                  onTap: pickCoverImage,
                ),

                const SizedBox(height: 25),

                TextField(
                  controller: titleController,
                  textCapitalization:
                      TextCapitalization.sentences,
                  decoration: InputDecoration(
                    hintText:
                        "Give your travel story a title",
                    labelText: "Title",
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(14),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                PlaceSelector(
                  selectedPlace:
                      selectedPlaceName,
                  onPlaceSelected:
                      (id, name) {
                    setState(() {
                      selectedPlaceId = id;
                      selectedPlaceName = name;
                    });
                  },
                ),

                const SizedBox(height: 20),

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
                  "Edit Story",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(
                        fontWeight:
                            FontWeight.bold,
                      ),
                ),

                const SizedBox(height: 15),

                QuillSimpleToolbar(
                  controller: quillController,
                  config:
                      const QuillSimpleToolbarConfig(
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
                  alignment:
                      Alignment.centerLeft,
                  child: FilledButton.icon(
                    onPressed: () async {
                      await BlogImageEmbed
                          .insertImage(
                        quillController,
                      );
                    },
                    icon:
                        const Icon(Icons.image),
                    label: const Text(
                      "Insert Image",
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                Container(
                  constraints:
                      const BoxConstraints(
                    minHeight: 450,
                  ),
                  padding:
                      const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(18),
                    border: Border.all(
                      color:
                          Colors.grey.shade300,
                    ),
                  ),
                  child: BlogEditor(
                    controller:
                        quillController,
                  ),
                ),

                const SizedBox(height: 30),

                PublishButton(
                  loading: publishing,
                  onPressed: updateBlog,
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      );
    }
}