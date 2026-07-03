import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAll;

  const SectionTitle({
    super.key,
    required this.title,
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [

        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .headlineMedium!
              .copyWith(
                fontSize: 24,
              ),
        ),

        const Spacer(),

        if (onSeeAll != null)
          TextButton(
            onPressed: onSeeAll,
            child: const Text("See All"),
          )

      ],
    );
  }
}