import 'package:flutter/material.dart';

import 'widgets/place_header.dart';
import 'widgets/place_info.dart';
import 'widgets/about_section.dart';
import 'widgets/weather_card.dart';
import 'widgets/maps_card.dart';

class PlaceDetailScreen extends StatelessWidget {
  final Map<String, dynamic> data;

  const PlaceDetailScreen({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [

          SliverToBoxAdapter(
            child: PlaceHeader(
              image: data["coverImage"],
            ),
          ),

          SliverToBoxAdapter(
            child: PlaceInfo(
              data: data,
            ),
          ),

          SliverToBoxAdapter(
            child: AboutSection(
              description:
                  data["description"],
            ),
          ),
          const SliverToBoxAdapter(
  child: SizedBox(height: 24),
),

const SliverToBoxAdapter(
  child: WeatherCard(),
),

const SliverToBoxAdapter(
  child: SizedBox(height: 24),
),

const SliverToBoxAdapter(
  child: MapsCard(),
),

const SliverToBoxAdapter(
  child: SizedBox(height: 30),
),
          const SliverToBoxAdapter(
            child: SizedBox(height: 30),
          ),

        ],
      ),
    );
  }
}