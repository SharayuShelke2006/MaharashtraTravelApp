import 'package:flutter/material.dart';

class HiddenGemHeader extends StatelessWidget {
  const HiddenGemHeader({super.key});

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
            "Discover",
            style: Theme.of(context)
                .textTheme
                .headlineLarge,
          ),

          const SizedBox(height: 6),

          Text(
            "Hidden Gems",
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(
                  color: Colors.green.shade700,
                  fontWeight:
                      FontWeight.bold,
                ),
          ),

          const SizedBox(height: 14),

          Text(
            "Secret places waiting to be explored around Maharashtra.",
            style: Theme.of(context)
                .textTheme
                .bodyMedium,
          ),

        ],
      ),
    );
  }
}