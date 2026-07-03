import 'package:flutter/material.dart';

class TopNavbar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const TopNavbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 35),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.95),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 12,
          ),
        ],
      ),
      child: Row(
        children: [

          Image.asset(
            "assets/images/logo.png",
            height: 48,
          ),

          const SizedBox(width: 12),

          Text(
            "Vatruhi",
            style: Theme.of(context).textTheme.headlineSmall,
          ),

          const Spacer(),

          _item(context, 0, "Home", primary),
          _item(context, 1, "Explore", primary),
          _item(context, 2, "Hidden Gems", primary),
          _item(context, 3, "Blogs", primary),
          _item(context, 4, "Profile", primary),

        ],
      ),
    );
  }

  Widget _item(
    BuildContext context,
    int index,
    String text,
    Color primary,
  ) {
    final selected = currentIndex == index;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextButton(
        onPressed: () => onTap(index),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: selected ? primary : Colors.black87,
          ),
        ),
      ),
    );
  }
}