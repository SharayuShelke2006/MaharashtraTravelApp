import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EmptySavedPlaces extends StatelessWidget {
  const EmptySavedPlaces({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border_rounded,
              size: 90,
              color: Colors.green.shade400,
            ),

            const SizedBox(height: 24),

            Text(
              "No Saved Places Yet",
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),

            const SizedBox(height: 12),

            Text(
              "Tap the ❤ icon on any place to save it here and plan your future trips.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 30),

            FilledButton.icon(
              onPressed: () {
                GoRouter.of(context).go("/home");
              },
              icon: const Icon(Icons.explore),
              label: const Text("Explore Places"),
            ),
          ],
        ),
      ),
    );
  }
}