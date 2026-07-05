import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../home/widgets/place_card.dart';
import 'widgets/empty_saved_places.dart';

class SavedPlacesScreen extends StatelessWidget {
  const SavedPlacesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Saved Places"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(uid)
            .collection("saved_places")
            .orderBy("savedAt", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData ||
              snapshot.data!.docs.isEmpty) {
            return const EmptySavedPlaces();
          }

          final savedDocs = snapshot.data!.docs;

          return ListView.separated(
            padding: const EdgeInsets.all(18),
            separatorBuilder: (_, __) =>
                const SizedBox(height: 18),
            itemCount: savedDocs.length,
            itemBuilder: (context, index) {
              final saved = savedDocs[index].data()
                  as Map<String, dynamic>;

              final placeId = saved["placeId"];
              final type = saved["type"];

              final collection =
                  type == "hidden_gem"
                      ? "hidden_gems"
                      : "places";

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection(collection)
                    .doc(placeId)
                    .get(),
                builder: (context, placeSnapshot) {
                  if (!placeSnapshot.hasData) {
                    return const SizedBox(
                      height: 170,
                      child: Center(
                        child:
                            CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (!placeSnapshot.data!.exists) {
                    return const SizedBox.shrink();
                  }

                  final place =
                      placeSnapshot.data!.data()
                          as Map<String, dynamic>;

                  return PlaceCard(
                    data: {
                      ...place,
                      "id": placeSnapshot.data!.id,
                    },
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