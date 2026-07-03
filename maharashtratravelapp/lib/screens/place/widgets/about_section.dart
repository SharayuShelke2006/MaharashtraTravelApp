import 'package:flutter/material.dart';

class AboutSection extends StatelessWidget {
  final String description;

  const AboutSection({
    super.key,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [

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
            description,
            style: Theme.of(context)
                .textTheme
                .bodyLarge,
          ),

        ],
      ),
    );
  }
}