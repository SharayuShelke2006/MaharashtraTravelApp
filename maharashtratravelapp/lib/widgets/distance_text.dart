import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../core/services/location_service.dart';

class DistanceText extends StatefulWidget {
  final double latitude;
  final double longitude;

  const DistanceText({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  @override
  State<DistanceText> createState() =>
      _DistanceTextState();
}

class _DistanceTextState
    extends State<DistanceText> {

  final locationService = LocationService();

  String distance = "...";

  @override
  void initState() {
    super.initState();

    loadDistance();
  }

  Future<void> loadDistance() async {

    Position? position =
        await locationService.getCurrentLocation();

    if (position == null) return;

    double km = locationService.getDistance(
      position.latitude,
      position.longitude,
      widget.latitude,
      widget.longitude,
    );

    setState(() {
      distance = "${km.toStringAsFixed(1)} km away";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [

        Icon(
          Icons.near_me,
          size: 16,
          color: Theme.of(context).colorScheme.primary,
        ),

        const SizedBox(width: 5),

        Text(
          distance,
          style: TextStyle(
            color: Colors.grey.shade700,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}