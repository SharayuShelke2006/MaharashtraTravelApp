import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WeatherService {

  static String apiKey = dotenv.get("WEATHER_API_KEY");

  Future<Map<String, dynamic>?> getWeather(
      double lat,
      double lon,
      ) async {

    final url = Uri.parse(
      "https://api.weatherapi.com/v1/current.json?key=$apiKey&q=$lat,$lon",
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    return null;
  }
}