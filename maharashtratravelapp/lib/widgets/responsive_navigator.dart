import 'package:flutter/material.dart';

import 'bottom_navbar.dart';
import 'top_navbar.dart';

class ResponsiveNavigation extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const ResponsiveNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    final width = MediaQuery.of(context).size.width;

    if (width >= 900) {
      return TopNavbar(
        currentIndex: currentIndex,
        onTap: onTap,
      );
    }

    return BottomNavbar(
      currentIndex: currentIndex,
      onTap: onTap,
    );
  }
}