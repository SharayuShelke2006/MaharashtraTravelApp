import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../widgets/distance_text.dart';
import 'package:url_launcher/url_launcher.dart';


class NearbyPlaceCard extends StatelessWidget {
  final Map<String, dynamic> data;
final bool isClosest;
  const NearbyPlaceCard({
    super.key,
    required this.data,
    required this.isClosest,
  });

  @override
  Widget build(BuildContext context) {

    final image = data["coverImage"];

    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () {
        context.push(
          "/place",
          extra: data,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .05),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [

              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  image,
                  width: 95,
                  height: 95,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    Text(
                      data["name"],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      data["address"],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                    ),

                    const SizedBox(height: 10),

                    DistanceText(
                      latitude: (data["latitude"] as num)
                          .toDouble(),
                      longitude: (data["longitude"] as num)
                          .toDouble(),
                    ),

                    const SizedBox(height: 12),

                    Wrap(
                      spacing: 10,
                      runSpacing: 8,
                      children: [

                        FilledButton.icon(
                          onPressed: () async {

  final url = Uri.parse(
    "https://www.google.com/maps/search/?api=1&query=${data["latitude"]},${data["longitude"]}",
  );

  await launchUrl(
    url,
    mode: LaunchMode.externalApplication,
  );
},
                          icon: const Icon(Icons.explore),
                          label: const Text("Explore"),
                        ),

                        OutlinedButton.icon(
                          onPressed: () {
                            context.push(
                              "/place",
                              extra: data,
                            );
                          },
                          icon: const Icon(Icons.map),
                          label: const Text("Directions"),
                        ),

                      ],
                    )

                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}