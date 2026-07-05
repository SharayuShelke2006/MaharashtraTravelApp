import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../core/services/location_service.dart';
import '../../widgets/responsive_scaffold.dart';

import '../home/widgets/category_chips.dart';
import '../home/widgets/search_bar_widget.dart';

import '../explore/widgets/distance_filter.dart';

import 'hidden_gem_header.dart';
import 'hidden_gem_card.dart';
import 'view_map_card.dart';
import 'package:go_router/go_router.dart';

class HiddenGemScreen extends StatefulWidget {
  const HiddenGemScreen({super.key});

  @override
  State<HiddenGemScreen> createState() =>
      _HiddenGemScreenState();
}

class _HiddenGemScreenState
    extends State<HiddenGemScreen> {

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
      currentIndex: 2,

      onTap: (index) {

        switch (index) {

          case 0:
            GoRouter.of(context).go("/home");
            break;

          case 1:
            GoRouter.of(context).go("/explore");
            break;

          case 2:
            GoRouter.of(context).go("/hidden-gems");
            break;

          case 3:
            GoRouter.of(context).go('/blogs');
            break;

          case 4:
            GoRouter.of(context).go('/profile');
            break;
        }
      },

      child: SafeArea(

        child: StreamBuilder<QuerySnapshot>(

          stream: FirebaseFirestore.instance
              .collection("hidden_gems")
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

              final matchesSearch =
                  data["name"]
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
                  child: HiddenGemHeader(),
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding:
                        const EdgeInsets.fromLTRB(
                            20,
                            20,
                            20,
                            0),
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
                        const EdgeInsets.only(
                            top: 22),
                    child: CategoryChips(
                      selected:
                          selectedCategory,
                      onSelected: (value) {
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
                    child: DistanceFilter(
                      selectedRadius:
                          selectedRadius,
                      onChanged: (value) {
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
                          "Nearby Hidden Gems",
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
                            color: Colors.green
                                .withValues(alpha: .12),
                            borderRadius:
                                BorderRadius.circular(30),
                          ),
                          child: Text(
                            "${docs.length} Gems",
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight:
                                  FontWeight.w600,
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
                            Icons.diamond_outlined,
                            size: 70,
                            color: Colors.grey.shade400,
                          ),

                          const SizedBox(height: 20),

                          Text(
                            selectedRadius == -1
                                ? "No Hidden Gems Found"
                                : "No Hidden Gems within ${selectedRadius.toInt()} km",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center,
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

                            child: HiddenGemCard(

                              data: docs[index]
                                      .data()
                                  as Map<String,
                                      dynamic>,

                              isClosest:
                                  index == 0,

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