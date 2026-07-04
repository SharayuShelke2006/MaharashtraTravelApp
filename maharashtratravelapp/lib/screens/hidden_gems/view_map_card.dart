import 'package:flutter/material.dart';

class ViewMapCard extends StatelessWidget {
  const ViewMapCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: 20),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: () {
          // TODO:
          // Open HiddenGemMapScreen
        },
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius:
                BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                    alpha: .05),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [

              Container(
                height: 55,
                width: 55,
                decoration: BoxDecoration(
                  color: Colors.green.withValues(
                      alpha: .12),
                  borderRadius:
                      BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.map,
                  color: Colors.green,
                ),
              ),

              const SizedBox(width: 18),

              const Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    Text(
                      "View Full Map",
                      style: TextStyle(
                        fontWeight:
                            FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),

                    SizedBox(height: 4),

                    Text(
                      "Explore all hidden gems on the map.",
                    ),

                  ],
                ),
              ),

              const Icon(
                Icons.arrow_forward_ios,
              ),

            ],
          ),
        ),
      ),
    );
  }
}