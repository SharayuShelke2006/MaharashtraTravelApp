import 'package:flutter/material.dart';

class CategoryList extends StatelessWidget {
  final String selected;
  final Function(String) onSelected;

  const CategoryList({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  static const categories = [
    {
      "name": "All",
      "icon": Icons.explore,
    },
    {
      "name": "Fort",
      "icon": Icons.fort,
    },
    {
      "name": "Beach",
      "icon": Icons.beach_access,
    },
    {
      "name": "Hill Station",
      "icon": Icons.landscape,
    },
    {
      "name": "Waterfall",
      "icon": Icons.water,
    },
    {
      "name": "Temple",
      "icon": Icons.temple_hindu,
    },
    {
      "name": "Wildlife",
      "icon": Icons.pets,
    },
    {
      "name": "City",
      "icon": Icons.location_city,
    },
    {
      "name": "Cave",
      "icon": Icons.terrain,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 95,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          final item = categories[index];
          final isSelected = selected == item["name"];

          return GestureDetector(
            onTap: () => onSelected(item["name"] as String),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 78,
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xff2563EB)
                    : Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.12),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    item["icon"] as IconData,
                    color: isSelected
                        ? Colors.white
                        : const Color(0xff2563EB),
                    size: 28,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item["name"] as String,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
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
      ),
    );
  }
}