import 'package:flutter/material.dart';

class BottomNavbar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return SafeArea(
      minimum: const EdgeInsets.fromLTRB(18, 0, 18, 18),
      child: Container(
        height: 72,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .08),
              blurRadius: 20,
              offset: const Offset(0, 8),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [

            _item(
              context,
              0,
              Icons.home_rounded,
              "Home",
              primary,
            ),

            _item(
              context,
              1,
              Icons.explore_rounded,
              "Explore",
              primary,
            ),

            _item(
              context,
              2,
              Icons.diamond_outlined,
              "Hidden",
              primary,
            ),

            _item(
              context,
              3,
              Icons.article_outlined,
              "Blogs",
              primary,
            ),

            _item(
              context,
              4,
              Icons.person_outline,
              "Profile",
              primary,
            ),

          ],
        ),
      ),
    );
  }

  Widget _item(
    BuildContext context,
    int index,
    IconData icon,
    String label,
    Color primary,
  ) {
    final selected = currentIndex == index;

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => onTap(index),
      child: SizedBox(
        width: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Icon(
              icon,
              size: 24,
              color: selected ? primary : Colors.grey,
            ),

            const SizedBox(height: 4),

            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: selected ? primary : Colors.grey,
              ),
            ),

          ],
        ),
      ),
    );
  }
}