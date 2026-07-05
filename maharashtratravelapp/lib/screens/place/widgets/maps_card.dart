import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../widgets/distance_text.dart';

class MapsCard extends StatelessWidget {
  final double latitude;
  final double longitude;
  final String placeName;

  const MapsCard({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.placeName,
  });

  Future<void> _openMaps() async {
    final Uri url = Uri.parse(
      "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude",
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: _openMaps,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .05),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [

              Container(
                height: 55,
                width: 55,
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: .10),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  Icons.map_rounded,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),

              const SizedBox(width: 18),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    const Text(
                      "Navigate",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
  "Open $placeName in Google Maps",
  maxLines: 2,
  overflow: TextOverflow.ellipsis,
  style: const TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 17,
  ),
),
                    const SizedBox(height: 8),

                    DistanceText(
                      latitude: latitude,
                      longitude: longitude,
                    ),
                  ],
                ),
              ),

              const Icon(Icons.arrow_forward_ios_rounded),
            ],
          ),
        ),
      ),
    );
  }
}