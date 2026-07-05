import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'widgets/home_header.dart';
import 'widgets/search_bar_widget.dart';
import 'widgets/category_chips.dart';
import 'widgets/featured_place_card.dart';
import 'widgets/place_card.dart';
import 'widgets/section_title.dart';
import '../../widgets/responsive_scaffold.dart';
import '../../core/routes/app_router.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final searchController = TextEditingController();

  String selectedCategory = "All";

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      currentIndex: 0,
      onTap: (index) {
  switch (index) {
    case 0:
      break;

    case 1:
      context.go("/explore");
      break;

    case 2:
      context.go("/hidden-gems");
      break;

    case 3:
      context.go("/blogs");
      break;

    case 4:
      context.go("/profile");
      break;
  }
},
      child: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("places")
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            List docs = snapshot.data!.docs;

            docs = docs.where((doc) {
              final data = doc.data() as Map<String, dynamic>;

              final name =
                  data["name"].toString().toLowerCase();

              final category =
                  data["category"].toString();

              final search =
                  searchController.text.toLowerCase();

              final matchesSearch =
                  name.contains(search);

              final matchesCategory =
                  selectedCategory == "All" ||
                      category == selectedCategory;

              return matchesSearch &&
                  matchesCategory;
            }).toList();

            return CustomScrollView(
              slivers: [

                const SliverToBoxAdapter(
                  child: HomeHeader(),
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding:
                        const EdgeInsets.fromLTRB(
                            20, 20, 20, 0),
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
                            top: 24),
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

                if (docs.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding:
                          const EdgeInsets.all(
                              20),
                      child: FeaturedPlaceCard(
                        data: docs.first.data()
                            as Map<String,
                                dynamic>,
                      ),
                    ),
                  ),

                const SliverToBoxAdapter(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(
                            horizontal: 20),
                    child: SectionTitle(
                      title:
                          "Popular Destinations",
                    ),
                  ),
                ),

                SliverLayoutBuilder(
  builder: (context, constraints) {
    final isDesktop = constraints.crossAxisExtent >= 900;

    if (isDesktop) {
      return SliverPadding(
        padding: const EdgeInsets.all(20),
        sliver: SliverGrid(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final data =
    docs[index].data() as Map<String, dynamic>;

return PlaceCard(
  data: {
    ...data,
    "id": docs[index].id,
  },

);
            },
            childCount: docs.length,
          ),
          gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 2.3,
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.all(20),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
           final data =
    docs[index].data() as Map<String, dynamic>;

return Padding(
  padding: const EdgeInsets.only(bottom: 18),
  child: PlaceCard(
    data: {
      ...data,
      "id": docs[index].id,
    },
  ),
);
          },
          childCount: docs.length,
        ),
      ),
    );
  },
),
              ],
            );
          },
        ),
      ),
    );
  }
}