import 'package:flutter/material.dart';

class DistanceFilter extends StatelessWidget {
  final double selectedRadius;
  final ValueChanged<double> onChanged;

  const DistanceFilter({
    super.key,
    required this.selectedRadius,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            "Distance",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),

          const SizedBox(height: 12),

          Wrap(
  spacing: 10,
  runSpacing: 10,
  children: [

    _chip(20),

    _chip(50),

    _chip(100),

    _allChip(),

  ],
),

          const SizedBox(height: 18),

          Slider(
            value: selectedRadius == -1
                ? 300
                : selectedRadius,
            min: 5,
            max: 300,
            divisions: 59,
            label: selectedRadius == -1
                ? "All"
                : "${selectedRadius.toInt()} km",
            onChanged: (value) {
              onChanged(value);
            },
          ),

          Center(
  child: Container(
    padding: const EdgeInsets.symmetric(
      horizontal: 14,
      vertical: 8,
    ),
    decoration: BoxDecoration(
      color: Theme.of(context)
          .colorScheme
          .primary
          .withValues(alpha: .1),
      borderRadius: BorderRadius.circular(30),
    ),
    child: Text(
      selectedRadius == -1
          ? "Showing All Places"
          : "Within ${selectedRadius.toInt()} km",
      style: TextStyle(
        color: Theme.of(context).colorScheme.primary,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
),

        ],
      ),
    );
  }

  Widget _chip(double value) {
    return Builder(
      builder: (context) {
        return ChoiceChip(
          label: Text("${value.toInt()} km"),
          selected: selectedRadius == value,
          onSelected: (_) {
            onChanged(value);
          },
        );
      },
    );
  }

  Widget _allChip() {
    return Builder(
      builder: (context) {
        return ChoiceChip(
          label: const Text("All"),
          selected: selectedRadius == -1,
          onSelected: (_) {
            onChanged(-1);
          },
        );
      },
    );
  }
}