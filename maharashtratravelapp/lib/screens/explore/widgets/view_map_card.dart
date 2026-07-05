import 'package:flutter/material.dart';

class ViewMapCard extends StatelessWidget {
  const ViewMapCard({super.key});

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: () {
          // TODO
          // Open Interactive Map
        },
        child: Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context)
                    .colorScheme
                    .primary
                    .withValues(alpha: .8),
              ],
            ),
            borderRadius: BorderRadius.circular(22),
          ),
          child: const Row(
            children: [

              Icon(
                Icons.map_rounded,
                color: Colors.white,
                size: 34,
              ),

              SizedBox(width: 18),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    Text(
                      "Explore on Map",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),

                    SizedBox(height: 4),

                    Text(
                      "View every place & hidden gem on an interactive map.",
                      style: TextStyle(
                        color: Colors.white70,
                      ),
                    ),

                  ],
                ),
              ),

              Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
              ),

            ],
          ),
        ),
      ),
    );
  }
}