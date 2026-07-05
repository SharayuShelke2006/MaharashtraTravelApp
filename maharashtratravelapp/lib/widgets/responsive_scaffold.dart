import 'package:flutter/material.dart';

import 'bottom_navbar.dart';
import 'top_navbar.dart';

class ResponsiveScaffold extends StatelessWidget {
  final Widget child;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final Widget? floatingActionButton;

  const ResponsiveScaffold({
    super.key,
    required this.child,
    required this.currentIndex,
    required this.onTap,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    // MOBILE
    if (width < 900) {
      return Scaffold(
        body: child,
        bottomNavigationBar: BottomNavbar(
          currentIndex: currentIndex,
          onTap: onTap,
        ),
      );
    }

    // DESKTOP / WEB
    return Scaffold(
      body: Column(
        children: [
          TopNavbar(
            currentIndex: currentIndex,
            onTap: onTap,
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}