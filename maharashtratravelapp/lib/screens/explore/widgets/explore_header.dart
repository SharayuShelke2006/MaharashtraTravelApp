import 'package:flutter/material.dart';

class ExploreHeader extends StatelessWidget {
  const ExploreHeader({super.key});

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        25,
        20,
        0,
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [

          Text(
            "Explore",
            style: Theme.of(context)
                .textTheme
                .headlineLarge,
          ),

          const SizedBox(height: 5),

          Text(
            "Near You",
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .primary,
                ),
          ),

          const SizedBox(height: 14),

          Text(
            "Discover nearby forts, beaches, temples and hidden gems around your current location.",
            style: Theme.of(context)
                .textTheme
                .bodyMedium,
          ),

        ],
      ),
    );
  }
}