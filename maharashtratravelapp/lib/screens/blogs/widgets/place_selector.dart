import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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

  List<QueryDocumentSnapshot<Map<String, dynamic>>> places = [];

  bool loading = false;

  Future<void> searchPlaces(String keyword) async {
    keyword = keyword.trim();

    if (keyword.isEmpty) {
      setState(() {
        places = [];
      });
      return;
    }

    setState(() {
      loading = true;
    });

    final placesSnapshot = await FirebaseFirestore.instance
        .collection("places")
        .get();

    final gemsSnapshot = await FirebaseFirestore.instance
        .collection("hidden_gems")
        .get();

    final allPlaces = [
      ...placesSnapshot.docs,
      ...gemsSnapshot.docs,
    ];

    places = allPlaces.where((doc) {
      final data = doc.data();

      return (data["name"] ?? "")
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

        if (widget.selectedPlace != null &&
            widget.selectedPlace!.isNotEmpty)
          Chip(
            avatar: const Icon(
              Icons.place,
              size: 18,
            ),
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
              border: Border.all(
                color: Colors.grey.shade300,
              ),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: places.length,
              itemBuilder: (context, index) {
                final data = places[index].data();

                final isHiddenGem =
                    places[index].reference.parent.id ==
                        "hidden_gems";

                return ListTile(
                  leading: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(8),
                    child: Image.network(
                      data["coverImage"] ?? "",
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (_, __, ___) =>
                              Container(
                        width: 50,
                        height: 50,
                        color: Colors.grey.shade200,
                        child: const Icon(
                          Icons.image,
                        ),
                      ),
                    ),
                  ),

                  title: Text(
                    data["name"] ?? "",
                  ),

                  subtitle: Row(
                    children: [
                      Text(
                        data["category"] ?? "",
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: isHiddenGem
                              ? Colors.orange
                                  .withOpacity(.15)
                              : Colors.green
                                  .withOpacity(.15),
                          borderRadius:
                              BorderRadius.circular(
                                  20),
                        ),
                        child: Text(
                          isHiddenGem
                              ? "Hidden Gem"
                              : "Place",
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight:
                                FontWeight.w600,
                            color: isHiddenGem
                                ? Colors.orange
                                : Colors.green,
                          ),
                        ),
                      ),
                    ],
                  ),

                  onTap: () {
                    widget.onPlaceSelected(
                      places[index].id,
                      data["name"],
                    );

                    searchController.text =
                        data["name"];

                    setState(() {
                      places = [];
                    });
                  },
                );
              },
            ),
          ),

        if (!loading &&
            places.isEmpty &&
            searchController.text
                .trim()
                .isNotEmpty)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(
              top: 10,
            ),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius:
                  BorderRadius.circular(14),
              border: Border.all(
                color: Colors.green.shade200,
              ),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.travel_explore,
                  size: 45,
                  color: Colors.green,
                ),

                const SizedBox(height: 12),

                Text(
                  "Couldn't find this place",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(
                        fontWeight:
                            FontWeight.bold,
                      ),
                ),

                const SizedBox(height: 8),

                Text(
                  "\"${searchController.text}\" doesn't exist yet.",
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 16),

                FilledButton.icon(
                  onPressed: () {
                    GoRouter.of(context).push(
                      "/hidden-gem-form",
                      extra: {
                        "name": searchController.text,
                      },
                    );
                  },
                  icon: const Icon(
                    Icons.add_location_alt,
                  ),
                  label: const Text(
                    "Add as Hidden Gem",
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}