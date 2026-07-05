import 'package:flutter/material.dart';

class CategoryDropdown extends StatelessWidget {
  final String? value;
  final ValueChanged<String?> onChanged;

  const CategoryDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    // 🔽 SPECIFIED CATEGORIES ONLY
    final List<String> categories = [
      "Fort",
      "Beach",
      "Hill Station",
      "Waterfall",
      "Temple",
      "Wildlife",
      "City",
      "Cave",
    ];

    // FIX: Shield against runtime crash if database contains a category not present in this list
    final String? safeValue = categories.contains(value) ? value : null;

    return DropdownButtonFormField<String>(
      value: safeValue,
      hint: const Text("Select Travel Category"),
      decoration: InputDecoration(
        labelText: "Category",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      items: categories
          .map(
            (e) => DropdownMenuItem<String>(
              value: e,
              child: Text(e),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }
}