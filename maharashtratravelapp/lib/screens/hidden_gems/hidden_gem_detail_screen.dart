import 'package:flutter/material.dart';

import '../place/widgets/weather_card.dart';
import '../place/widgets/maps_card.dart';


class HiddenGemDetailScreen extends StatelessWidget {
  final Map<String, dynamic> data;

  const HiddenGemDetailScreen({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: CustomScrollView(

        slivers: [

          SliverAppBar(

            expandedHeight: 280,

            pinned: true,

            elevation: 0,

            backgroundColor:
                Theme.of(context)
                    .colorScheme
                    .primary,

            flexibleSpace: FlexibleSpaceBar(

              title: Text(
                data["name"],
              ),

              background: Image.network(
                data["coverImage"],
                fit: BoxFit.cover,
              ),
            ),
          ),

          SliverToBoxAdapter(

            child: Padding(

              padding:
                  const EdgeInsets.all(20),

              child: Column(

                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  Row(

                    children: [

                      Expanded(

                        child: Text(

                          data["name"],

                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontWeight:
                                    FontWeight.bold,
                              ),
                        ),
                      ),

                      Container(

                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 7,
                        ),

                        decoration: BoxDecoration(

                          color: Colors.green
                              .withValues(alpha: .12),

                          borderRadius:
                              BorderRadius.circular(
                                  30),
                        ),

                        child: Text(

                          data["category"],

                          style: const TextStyle(

                            color: Colors.green,

                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ),

                    ],
                  ),

                  const SizedBox(height: 12),

                  Row(

                    children: [

                      const Icon(
                        Icons.location_on,
                        color: Colors.grey,
                      ),

                      const SizedBox(width: 6),

                      Expanded(

                        child: Text(
                          data["address"],
                        ),
                      ),

                    ],
                  ),

                  const SizedBox(height: 25),

                  Text(

                    "About",

                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(
                          fontWeight:
                              FontWeight.bold,
                        ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    data["description"],
                    style: const TextStyle(
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 28),
                                    Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: .08),
                      borderRadius:
                          BorderRadius.circular(18),
                    ),
                    child: Row(
                      children: [

                        const Icon(
                          Icons.star_rounded,
                          color: Colors.amber,
                          size: 34,
                        ),

                        const SizedBox(width: 14),

                        Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [

                            const Text(
                              "Rating",
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),

                            Text(
                              "${data["rating"]}",
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),

                          ],
                        ),

                      ],
                    ),
                  ),

                  const SizedBox(height: 22),

                  WeatherCard(
                    latitude:
                        (data["latitude"] as num)
                            .toDouble(),
                    longitude:
                        (data["longitude"] as num)
                            .toDouble(),
                  ),

                  const SizedBox(height: 22),

                  MapsCard(
                    latitude:
                        (data["latitude"] as num)
                            .toDouble(),
                    longitude:
                        (data["longitude"] as num)
                            .toDouble(),
                    placeName: data["name"],
                  ),

                  const SizedBox(height: 22),

                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius:
                          BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black
                              .withValues(alpha: .05),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [

                        Row(
                          children: [

                            const Icon(
                              Icons.calendar_month,
                              color: Colors.green,
                            ),

                            const SizedBox(width: 12),

                            const Expanded(
                              child: Text(
                                "Best Season",
                              ),
                            ),

                            Text(
                              data["bestSeason"] ??
                                  "-",
                              style: const TextStyle(
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),

                          ],
                        ),

                        const Divider(height: 28),

                        Row(
                          children: [

                            const Icon(
                              Icons.payments,
                              color: Colors.green,
                            ),

                            const SizedBox(width: 12),

                            const Expanded(
                              child: Text(
                                "Entry Fee",
                              ),
                            ),

                            Text(
                              data["entryFee"] ??
                                  "Free",
                              style: const TextStyle(
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),

                          ],
                        ),

                        const Divider(height: 28),

                        Row(
                          children: [

                            const Icon(
                              Icons.access_time,
                              color: Colors.green,
                            ),

                            const SizedBox(width: 12),

                            const Expanded(
                              child: Text(
                                "Opening Time",
                              ),
                            ),

                            Text(
                              data["openingTime"] ??
                                  "-",
                              style: const TextStyle(
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),

                          ],
                        ),

                      ],
                    ),
                  ),

                  const SizedBox(height: 35),
                                  ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}