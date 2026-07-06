import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/blog_model.dart';
import '../blogs/widgets/blog_card.dart';
import '../blogs/blog_detail_screen.dart';

class LikedBlogsScreen extends StatelessWidget {
  const LikedBlogsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Liked Blogs"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        // अब यह सीधे 'blogs' कलेक्शन से बिना किसी एरर के तुरंत डेटा लाएगा
        stream: FirebaseFirestore.instance
            .collection("blogs")
            .where("likedBy", arrayContains: uid) // चेक करेगा कि क्या इस लिस्ट में आपकी UID है
            .orderBy("createdAt", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("You haven't liked any blogs yet."),
            );
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final blog = BlogModel.fromFirestore(docs[index]);

              return BlogCard(
                blog: blog,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlogDetailScreen(blogId: blog.id),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}