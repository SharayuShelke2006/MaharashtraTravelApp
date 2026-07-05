import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart'; // 👈 Safe Image Embed logic loading ke liye
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/blog_model.dart';
import '../../core/services/blog_service.dart';
import 'comment_screen.dart'; // File path check framework matching match kar diya

class BlogDetailScreen extends StatefulWidget {
  final String blogId;

  const BlogDetailScreen({
    super.key,
    required this.blogId,
  });

  @override
  State<BlogDetailScreen> createState() => _BlogDetailScreenState();
}

class _BlogDetailScreenState extends State<BlogDetailScreen> {
  final BlogService service = BlogService();
  final user = FirebaseAuth.instance.currentUser!;
  
  BlogModel? blog;
  bool loading = true;
  bool liked = false;
  String? _avatarUrl;

  // 🔽 FIX: Initialize class variable early to safeguard the layout context engine loop
  QuillController? _quillController;

  @override
  void initState() {
    super.initState();
    loadBlog();
  }

  @override
  void dispose() {
    // FIX: Free up controller resources cleanly
    _quillController?.dispose();
    super.dispose();
  }

  Future<void> loadBlog() async {
    blog = await service.getBlog(widget.blogId);
    await _loadAuthorAvatar();
    liked = await service.isLiked(widget.blogId, user.uid);

    if (blog != null) {
      // 🔽 FIX: Configure the controller exactly ONCE inside the async thread, not in the build method
      _quillController = QuillController(
        document: Document.fromJson(blog!.content),
        selection: const TextSelection.collapsed(offset: 0),
        readOnly: true, // Ensured explicit display-only locking constraints
      );
    }

    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> _loadAuthorAvatar() async {
    if (blog == null) return;

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null &&
        currentUser.uid == blog!.authorId &&
        currentUser.photoURL != null &&
        currentUser.photoURL!.trim().isNotEmpty) {
      if (mounted) {
        setState(() => _avatarUrl = currentUser.photoURL!.trim());
      }
      return;
    }

    final fallback = blog!.authorPhoto?.trim();
    if (fallback != null && fallback.isNotEmpty) {
      if (mounted) setState(() => _avatarUrl = fallback);
      return;
    }

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(blog!.authorId)
          .get();

      final url = doc.data()?['profileImage']?.toString().trim();
      if (mounted) {
        setState(() => _avatarUrl = (url != null && url.isNotEmpty) ? url : null);
      }
    } catch (_) {
      if (mounted) setState(() => _avatarUrl = null);
    }
  }

  bool _isValidUrl(String? value) {
    if (value == null || value.trim().isEmpty) return false;
    final trimmed = value.trim();
    return trimmed.startsWith('http://') || trimmed.startsWith('https://');
  }

  Future<void> likeBlog() async {
    await service.toggleLike(widget.blogId, user.uid);
    final updatedBlog = await service.getBlog(widget.blogId);
    final updatedLiked = await service.isLiked(widget.blogId, user.uid);

    if (mounted) {
      setState(() {
        blog = updatedBlog;
        liked = updatedLiked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading || _quillController == null || blog == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ---------------- EXTENDED COVER HEADER ----------------
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            stretch: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    blog!.coverImage,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: .65),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 20,
                    right: 20,
                    bottom: 25,
                    child: Text(
                      blog!.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ---------------- RENDER BODY SECTION ----------------
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Author Info Block Card
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundImage: _isValidUrl(_avatarUrl ?? blog!.authorPhoto)
                            ? NetworkImage(_avatarUrl ?? blog!.authorPhoto!)
                            : null,
                        child: !_isValidUrl(_avatarUrl ?? blog!.authorPhoto)
                            ? const Icon(Icons.person)
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              blog!.authorName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                            Text(
                              blog!.category,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.share),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // ---------------- THE SAFE QUILL VIEWER ----------------
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade100),
                    ),
                    child: QuillEditor.basic(
                      controller: _quillController!,
                      config: QuillEditorConfig(
                        scrollable: false, // Integrated safely inside sliver scroll bounds
                        autoFocus: false,
                        expands: false,
                        // 🔽 FIX: Enabled the layout manager to securely parse inside images
                        embedBuilders: FlutterQuillEmbeds.editorBuilders(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Divider(),
                  const SizedBox(height: 20),

                  // ---------------- ENGAGEMENT BUTTON ROW ----------------
                  Row(
                    children: [
                      IconButton(
                        onPressed: likeBlog,
                        icon: Icon(
                          liked ? Icons.favorite : Icons.favorite_border,
                          color: liked ? Colors.red : null,
                        ),
                      ),
                      Text("${blog!.likes}"),
                      const SizedBox(width: 20),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CommentsScreen(blogId: blog!.id),
                            ),
                          );
                        },
                        icon: const Icon(Icons.mode_comment_outlined),
                      ),
                      Text("${blog!.comments}"),
                    ],
                  ),
                  const SizedBox(height: 25),

                  const Text(
                    "Related Blogs",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Related blogs placeholder widget structure mapping
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}