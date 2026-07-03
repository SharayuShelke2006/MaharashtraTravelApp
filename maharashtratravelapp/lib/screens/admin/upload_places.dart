import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../data/places.dart';

class UploadPlacesScreen extends StatelessWidget {
  const UploadPlacesScreen({super.key});

  Future<void> uploadPlaces() async {

    final firestore = FirebaseFirestore.instance;

    for (final place in places) {

      await firestore
          .collection("places")
          .doc(place.id)
          .set(place.toMap());

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload Places"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {

            await uploadPlaces();

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Places Uploaded Successfully"),
              ),
            );

          },
          child: const Text("Upload All Places"),
        ),
      ),
    );
  }
}