import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../core/services/location_service.dart';
import '../../widgets/responsive_scaffold.dart';

import '../home/widgets/category_chips.dart';
import '../home/widgets/search_bar_widget.dart';

import 'widgets/distance_filter.dart';
import 'widgets/explore_header.dart';
import 'widgets/nearby_place_card.dart';
import 'widgets/view_map_card.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() =>
      _ExploreScreenState();
}

class _ExploreScreenState
    extends State<ExploreScreen> {
  final searchController =
      TextEditingController();

  final locationService =
      LocationService();

  Position? currentPosition;

  String selectedCategory = "All";

  double selectedRadius = 100;

  @override
  void initState() {
    super.initState();
    loadLocation();
  }

  Future<void> loadLocation() async {
    currentPosition =
        await locationService
            .getCurrentLocation();

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      currentIndex: 1,
      onTap: (index) {
        // TODO
      },
      child: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("places")
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData ||
                currentPosition == null) {
              return const Center(
                child:
                    CircularProgressIndicator(),
              );
            }

            List docs =
                snapshot.data!.docs;

            docs = docs.where((doc) {
              final data =
                  doc.data()
                      as Map<String, dynamic>;

              final search =
                  searchController.text
                      .toLowerCase();

              final matchesSearch = data["name"]
                  .toString()
                  .toLowerCase()
                  .contains(search);

              final matchesCategory =
                  selectedCategory ==
                          "All" ||
                      data["category"] ==
                          selectedCategory;

              return matchesSearch &&
                  matchesCategory;
            }).toList();

            docs = docs.where((doc) {
              final data =
                  doc.data()
                      as Map<String, dynamic>;

              final distance =
                  locationService
                      .getDistance(
                currentPosition!.latitude,
                currentPosition!.longitude,
                (data["latitude"] as num)
                    .toDouble(),
                (data["longitude"] as num)
                    .toDouble(),
              );

              if (selectedRadius == -1) {
                return true;
              }

              return distance <=
                  selectedRadius;
            }).toList();

            docs.sort((a, b) {
              final da =
                  a.data()
                      as Map<String, dynamic>;

              final db =
                  b.data()
                      as Map<String, dynamic>;

              final distanceA =
                  locationService
                      .getDistance(
                currentPosition!.latitude,
                currentPosition!.longitude,
                (da["latitude"] as num)
                    .toDouble(),
                (da["longitude"] as num)
                    .toDouble(),
              );

              final distanceB =
                  locationService
                      .getDistance(
                currentPosition!.latitude,
                currentPosition!.longitude,
                (db["latitude"] as num)
                    .toDouble(),
                (db["longitude"] as num)
                    .toDouble(),
              );

              return distanceA.compareTo(
                  distanceB);
            });

            return CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(
                  child: ExploreHeader(),
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding:
                        const EdgeInsets
                            .fromLTRB(
                      20,
                      20,
                      20,
                      0,
                    ),
                    child: SearchBarWidget(
                      controller:
                          searchController,
                      onChanged: (_) {
                        setState(() {});
                      },
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding:
                        const EdgeInsets
                            .only(top: 22),
                    child: CategoryChips(
                      selected:
                          selectedCategory,
                      onSelected:
                          (value) {
                        setState(() {
                          selectedCategory =
                              value;
                        });
                      },
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(
                            top: 20),
                    child:
                        DistanceFilter(
                      selectedRadius:
                          selectedRadius,
                      onChanged:
                          (value) {
                        setState(() {
                          selectedRadius =
                              value;
                        });
                      },
                    ),
                  ),
                ),
                                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      20,
                      25,
                      20,
                      15,
                    ),
                    child: Row(
                      children: [
                        Text(
                          "Nearby Places",
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                fontWeight:
                                    FontWeight.bold,
                              ),
                        ),

                        const SizedBox(width: 10),

                        Container(
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withValues(alpha: .12),
                            borderRadius:
                                BorderRadius.circular(30),
                          ),
                          child: Text(
                            "${docs.length} Places",
                            style: TextStyle(
                              fontWeight:
                                  FontWeight.w600,
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                if (docs.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [

                          Icon(
                            Icons.location_off_rounded,
                            size: 70,
                            color: Colors.grey.shade400,
                          ),

                          const SizedBox(height: 20),

                          Text(
                            selectedRadius == -1
                                ? "No places found."
                                : "No places found within ${selectedRadius.toInt()} km.",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    sliver: SliverList(
                      delegate:
                          SliverChildBuilderDelegate(
                        (context, index) {
                          return Padding(
                            padding:
                                const EdgeInsets.only(
                              bottom: 18,
                            ),
                            
                            child: NearbyPlaceCard(
                              data: docs[index].data()
                                  as Map<String,
                                      dynamic>,

                              // first card nearest
                              isClosest: index == 0,
                            ),
                          );
                        },
                        childCount: docs.length,
                      ),
                    ),
                  ),

                if (docs.isNotEmpty)
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 10),
                  ),

                if (docs.isNotEmpty)
                  const SliverToBoxAdapter(
                    child: ViewMapCard(),
                  ),

                const SliverToBoxAdapter(
                  child: SizedBox(height: 30),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}