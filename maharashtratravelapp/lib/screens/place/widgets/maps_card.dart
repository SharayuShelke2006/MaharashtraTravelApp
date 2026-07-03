import 'package:flutter/material.dart';

class MapsCard extends StatelessWidget {
  const MapsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          // TODO:
          // Launch Google Maps
        },
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .05),
                blurRadius: 12,
              )
            ],
          ),
          child: const Row(
            children: [

              Icon(Icons.map_outlined),

              SizedBox(width: 12),

              Expanded(
                child: Text(
                  "Open in Google Maps",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              Icon(Icons.arrow_forward_ios, size: 18),

            ],
          ),
        ),
      ),
    );
  }
}