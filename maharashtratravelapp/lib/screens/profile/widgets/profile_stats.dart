import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProfileStats extends StatelessWidget {
  final String uid;

  const ProfileStats({
    super.key,
    required this.uid,
  });

  Stream<int> _count(String collection) {
    return FirebaseFirestore.instance
        .collection(collection)
        .where("authorId", isEqualTo: uid)
        .snapshots()
        .map((e) => e.docs.length);
  }

  Stream<int> _savedCount() {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("saved_places")
        .snapshots()
        .map((e) => e.docs.length);
  }

  Stream<int> _likesReceived() {
    return FirebaseFirestore.instance
        .collection("blogs")
        .where("authorId", isEqualTo: uid)
        .snapshots()
        .map((snapshot) {
      int total = 0;

      for (final doc in snapshot.docs) {
        total += (doc["likes"] ?? 0) as int;
      }

      return total;
    });
  }

  Widget statCard(
    BuildContext context,
    String title,
    Stream<int> stream,
    IconData icon,
  ) {
    return Expanded(
      child: StreamBuilder<int>(
        stream: stream,
        builder: (context, snapshot) {
          final value = snapshot.data ?? 0;

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 6),
            padding: const EdgeInsets.symmetric(vertical: 18),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              children: [
                Icon(
                  icon,
                  color: Colors.green.shade700,
                ),
                const SizedBox(height: 8),
                Text(
                  value.toString(),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 13),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        children: [
          statCard(
            context,
            "Blogs",
            _count("blogs"),
            Icons.article,
          ),
          statCard(
            context,
            "Saved",
            _savedCount(),
            Icons.bookmark,
          ),
          statCard(
            context,
            "Hidden\nGems",
            _count("hidden_gems"),
            Icons.location_on,
          ),
          statCard(
            context,
            "Likes",
            _likesReceived(),
            Icons.favorite,
          ),
        ],
      ),
    );
  }
}