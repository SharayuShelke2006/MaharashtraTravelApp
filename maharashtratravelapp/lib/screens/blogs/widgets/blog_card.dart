import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/blog_model.dart';

class BlogCard extends StatefulWidget {
  final BlogModel blog;
  final VoidCallback onTap;

  const BlogCard({
    super.key,
    required this.blog,
    required this.onTap,
  });

  @override
  State<BlogCard> createState() => _BlogCardState();
}

class _BlogCardState extends State<BlogCard> {
  String? _avatarUrl;

  @override
  void initState() {
    super.initState();
    _loadAuthorAvatar();
  }

  @override
  void didUpdateWidget(covariant BlogCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the widget is reused for a different blog with a different author, reload the image
    if (oldWidget.blog.authorId != widget.blog.authorId) {
      _loadAuthorAvatar();
    }
  }

  Future<void> _loadAuthorAvatar() async {
    final authorId = widget.blog.authorId.trim();
    if (authorId.isEmpty) return;

    try {
      // Direct fetch from users collection using the authorId
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(authorId)
          .get();

      if (doc.exists && doc.data() != null) {
        final url = doc.data()?['profileImage']?.toString().trim();
        if (mounted) {
          setState(() {
            _avatarUrl = (url != null && url.isNotEmpty) ? url : null;
          });
        }
      }
    } catch (e) {
      debugPrint("Error fetching profile image for $authorId: $e");
      if (mounted) {
        setState(() => _avatarUrl = null);
      }
    }
  }

  bool _isValidUrl(String? value) {
    if (value == null || value.trim().isEmpty) return false;
    final trimmed = value.trim();
    return trimmed.startsWith('http://') || trimmed.startsWith('https://');
  }

  @override
  Widget build(BuildContext context) {
    final coverImage = widget.blog.coverImage.trim();
    final hasValidCoverUrl = _isValidUrl(coverImage);

    return InkWell(
      onTap: widget.onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        margin: const EdgeInsets.only(bottom: 22),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .05),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Cover Image ---
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
              child: hasValidCoverUrl
                  ? Image.network(
                      coverImage,
                      height: 220,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 220,
                        color: Colors.grey.shade200,
                        child: const Center(child: Icon(Icons.image, size: 60)),
                      ),
                    )
                  : Container(
                      height: 220,
                      color: Colors.grey.shade200,
                      child: const Center(child: Icon(Icons.image, size: 60)),
                    ),
            ),

            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Category Tag ---
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: .10),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      widget.blog.category.trim().isEmpty ? 'General' : widget.blog.category.trim(),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // --- Title ---
                  Text(
                    widget.blog.title.trim().isEmpty ? 'Untitled Blog' : widget.blog.title.trim(),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 21),
                  ),

                  const SizedBox(height: 10),

                  // --- Author Info Row ---
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundImage: _isValidUrl(_avatarUrl) ? NetworkImage(_avatarUrl!) : null,
                        child: !_isValidUrl(_avatarUrl) ? const Icon(Icons.person, size: 18) : null,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.blog.authorName.trim().isEmpty ? 'Unknown author' : widget.blog.authorName.trim(),
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Text(
                              DateFormat("dd MMM yyyy").format(widget.blog.createdAt.toDate()),
                              style: const TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // --- Footer Interactions ---
                  Row(
                    children: [
                      const Icon(Icons.favorite_border, size: 20),
                      const SizedBox(width: 6),
                      Text("${widget.blog.likes}"),
                      const SizedBox(width: 20),
                      const Icon(Icons.mode_comment_outlined, size: 20),
                      const SizedBox(width: 6),
                      Text("${widget.blog.comments}"),
                      const Spacer(),
                      const Icon(Icons.arrow_forward_ios, size: 16)
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}