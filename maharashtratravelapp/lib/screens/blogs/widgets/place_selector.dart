import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PlaceSelector extends StatefulWidget {
  final String? selectedPlace;
  final Function(String id, String name) onPlaceSelected;

  const PlaceSelector({
    super.key,
    required this.selectedPlace,
    required this.onPlaceSelected,
  });

  @override
  State<PlaceSelector> createState() => _PlaceSelectorState();
}

class _PlaceSelectorState extends State<PlaceSelector> {
  final searchController = TextEditingController();

  List<QueryDocumentSnapshot> places = [];

  bool loading = false;

  Future<void> searchPlaces(String keyword) async {
    if (keyword.trim().length < 2) {
      setState(() {
        places = [];
      });
      return;
    }

    setState(() {
      loading = true;
    });

    final snapshot = await FirebaseFirestore.instance
        .collection("places")
        .limit(10)
        .get();

    places = snapshot.docs.where((doc) {
      final data = doc.data();

      return data["name"]
          .toString()
          .toLowerCase()
          .contains(keyword.toLowerCase());
    }).toList();

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: "Search related place...",
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          onChanged: searchPlaces,
        ),

        const SizedBox(height: 10),

        if (widget.selectedPlace != null)
          Chip(
            avatar: const Icon(Icons.place, size: 18),
            label: Text(widget.selectedPlace!),
            deleteIcon: const Icon(Icons.close),
            onDeleted: () {
              widget.onPlaceSelected("", "");
              searchController.clear();
              setState(() {
                places = [];
              });
            },
          ),

        if (loading)
          const Padding(
            padding: EdgeInsets.all(15),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),

        if (!loading && places.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 10),
            constraints: const BoxConstraints(
              maxHeight: 260,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: places.length,
              itemBuilder: (context, index) {
                final data =
                    places[index].data() as Map<String, dynamic>;

                return ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      data["coverImage"] ?? "",
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,

                      errorBuilder:
                          (_, __, ___) => Container(
                        width: 50,
                        height: 50,
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.image),
                      ),
                    ),
                  ),

                  title: Text(data["name"] ?? ""),

                  subtitle: Text(
                    data["category"] ?? "",
                  ),

                  onTap: () {
                    widget.onPlaceSelected(
                      places[index].id,
                      data["name"],
                    );

                    searchController.text = data["name"];

                    setState(() {
                      places = [];
                    });
                  },
                );
              },
            ),
          ),
      ],
    );
  }
}