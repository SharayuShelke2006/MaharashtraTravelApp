import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/blog_model.dart';
import '../edit_blog_screen.dart';

class MyBlogCard extends StatefulWidget {
  final BlogModel blog;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const MyBlogCard({
    super.key,
    required this.blog,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<MyBlogCard> createState() => _MyBlogCardState();
}

class _MyBlogCardState extends State<MyBlogCard> {
  String? _avatarUrl;

  @override
  void initState() {
    super.initState();
    _loadAuthorAvatar();
  }

  @override
  void didUpdateWidget(covariant MyBlogCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.blog.authorId != widget.blog.authorId) {
      _loadAuthorAvatar();
    }
  }

  Future<void> _loadAuthorAvatar() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null &&
        currentUser.uid == widget.blog.authorId &&
        currentUser.photoURL != null &&
        currentUser.photoURL!.trim().isNotEmpty) {
      if (mounted) {
        setState(() => _avatarUrl = currentUser.photoURL!.trim());
      }
      return;
    }

    final fallback = widget.blog.authorPhoto?.trim();
    if (fallback != null && fallback.isNotEmpty) {
      if (mounted) setState(() => _avatarUrl = fallback);
      return;
    }

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.blog.authorId)
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

  @override
  Widget build(BuildContext context) {
    final coverImage = widget.blog.coverImage.trim();
    final title = widget.blog.title.trim().isEmpty ? 'Untitled Blog' : widget.blog.title.trim();
    final category = widget.blog.category.trim().isEmpty ? 'Travel' : widget.blog.category.trim();
    final authorName = widget.blog.authorName.trim().isEmpty ? 'Unknown author' : widget.blog.authorName.trim();
    final avatarUrl = _avatarUrl ?? widget.blog.authorPhoto?.trim();

    final hasValidImageUrl = coverImage.isNotEmpty &&
        (coverImage.startsWith('http://') || coverImage.startsWith('https://'));

    return InkWell(
      onTap: widget.onTap,
      borderRadius: BorderRadius.circular(22),
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
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(22),
              ),
              child: hasValidImageUrl
                  ? Image.network(
                      coverImage,
                      width: double.infinity,
                      height: 220,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return SizedBox(
                          height: 220,
                          child: Center(
                            child: CircularProgressIndicator(
                              value: progress.expectedTotalBytes != null
                                  ? progress.cumulativeBytesLoaded / progress.expectedTotalBytes!
                                  : null,
                            ),
                          ),
                        );
                      },
                      errorBuilder: (_, __, ___) => Container(
                        height: 220,
                        color: Colors.grey.shade200,
                        child: const Center(
                          child: Icon(
                            Icons.image,
                            size: 60,
                          ),
                        ),
                      ),
                    )
                  : Container(
                      height: 220,
                      color: Colors.grey.shade200,
                      child: const Center(
                        child: Icon(
                          Icons.image,
                          size: 60,
                        ),
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withValues(alpha: .10),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          category,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Spacer(),
                      PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'edit') {
                            widget.onEdit();
                          } else {
                            widget.onDelete();
                          }
                        },
                        itemBuilder: (_) => const [
                          PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(Icons.edit),
                                SizedBox(width: 10),
                                Text('Edit'),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete, color: Colors.red),
                                SizedBox(width: 10),
                                Text(
                                  'Delete',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: _isValidUrl(avatarUrl)
                            ? NetworkImage(avatarUrl!)
                            : null,
                        child: !_isValidUrl(avatarUrl)
                            ? const Icon(Icons.person)
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              authorName,
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Text(
                              DateFormat('dd MMM yyyy').format(widget.blog.createdAt.toDate()),
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      const Icon(Icons.favorite, color: Colors.red, size: 20),
                      const SizedBox(width: 6),
                      Text('${widget.blog.likes}'),
                      const SizedBox(width: 24),
                      const Icon(Icons.mode_comment_outlined, size: 20),
                      const SizedBox(width: 6),
                      Text('${widget.blog.comments}'),
                      const Spacer(),
                      FilledButton.icon(
                        onPressed: widget.onEdit,
                        icon: const Icon(Icons.edit, size: 18),
                        label: const Text('Edit'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}