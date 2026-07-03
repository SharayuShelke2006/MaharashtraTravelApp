import 'package:flutter/material.dart';

class CategoryChips extends StatelessWidget {
  final String selected;
  final Function(String) onSelected;

  const CategoryChips({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  static const categories = [
    ("All", Icons.explore),
    ("Fort", Icons.fort),
    ("Beach", Icons.beach_access),
    ("Hill Station", Icons.landscape),
    ("Waterfall", Icons.water),
    ("Temple", Icons.temple_hindu),
    ("Wildlife", Icons.pets),
    ("City", Icons.location_city),
    ("Cave", Icons.terrain),
  ];

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return SizedBox(
      height: 48,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final item = categories[index];

          final isSelected = selected == item.$1;

          return GestureDetector(
            onTap: () => onSelected(item.$1),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: isSelected ? primary : Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: isSelected
                      ? primary
                      : Colors.grey.shade300,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.04),
                    blurRadius: 10,
                  )
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    item.$2,
                    size: 18,
                    color: isSelected
                        ? Colors.white
                        : primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    item.$1,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? Colors.white
                          : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (_, __) =>
            const SizedBox(width: 12),
        itemCount: categories.length,
      ),
    );
  }
}