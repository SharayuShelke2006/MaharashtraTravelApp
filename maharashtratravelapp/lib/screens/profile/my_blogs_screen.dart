import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/blog_model.dart';
import '../blogs/blog_detail_screen.dart';
import '../blogs/create_blog_screen.dart';
import 'edit_blog_screen.dart';
import 'widgets/my_blog_card.dart';

class MyBlogsScreen extends StatelessWidget {
  const MyBlogsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      return const Scaffold(
        body: Center(
          child: Text('Please sign in to view your blogs.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Blogs'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CreateBlogScreen(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('New Blog'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('blogs')
            .where('authorId', isEqualTo: uid)
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, size: 48),
                    const SizedBox(height: 12),
                    Text('Could not load your blogs.\n${snapshot.error}'),
                  ],
                ),
              ),
            );
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return const Center(
              child: Text("You haven't published any blogs yet."),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final blog = BlogModel.fromFirestore(docs[index]);

              return MyBlogCard(
                blog: blog,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlogDetailScreen(blogId: blog.id),
                    ),
                  );
                },
                onEdit: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditBlogScreen(blog: blog),
                    ),
                  );
                },
                onDelete: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Delete Blog'),
                      content: const Text('Are you sure you want to delete this blog?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
                        FilledButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  );

                  if (confirm != true) return;

                  await FirebaseFirestore.instance
                      .collection('blogs')
                      .doc(blog.id)
                      .delete();
                },
              );
            },
          );
        },
      ),
    );
  }
}