import 'package:flutter/material.dart';

import '../../../core/services/weather_service.dart';

class WeatherCard extends StatefulWidget {

  final double latitude;
  final double longitude;

  const WeatherCard({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  @override
  State<WeatherCard> createState() =>
      _WeatherCardState();
}

class _WeatherCardState
    extends State<WeatherCard> {

  final service = WeatherService();

  Map<String, dynamic>? weather;

  @override
  void initState() {
    super.initState();

    loadWeather();
  }

  Future<void> loadWeather() async {

    weather = await service.getWeather(
      widget.latitude,
      widget.longitude,
    );

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {

    if (weather == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final current = weather!["current"];

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [

              Image.network(
                "https:${current["condition"]["icon"]}",
              ),

              const SizedBox(width: 20),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    Text(
                      "${current["temp_c"]}°C",
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Text(
                      current["condition"]["text"],
                    ),

                    const SizedBox(height: 6),

                    Text(
                      "Humidity : ${current["humidity"]}%",
                    ),

                    Text(
                      "Wind : ${current["wind_kph"]} km/h",
                    ),

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