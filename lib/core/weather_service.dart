import 'dart:convert';
import 'package:http/http.dart' as http;
import 'location_service.dart';
import '../utils/constants.dart';


class WeatherService {
  Future<Map<String, dynamic>?> fetchByCoords(double lat, double lon) async {
    final uri = Uri.parse(kOpenWeatherEndpoint).replace(queryParameters: {
      'lat': lat.toString(),
      'lon': lon.toString(),
      'exclude': 'minutely',
      'units': 'metric',
      'appid': kOpenWeatherApiKey,
    });
    final res = await http.get(uri);
    if (res.statusCode == 200) return json.decode(res.body) as Map<String, dynamic>;
    return null;
  }


  Future<Map<String, dynamic>?> fetchLocal() async {
    final pos = await LocationService().getCurrentPosition();
    if (pos == null) return null;
    return fetchByCoords(pos.latitude, pos.longitude);
  }
}


final weatherService = WeatherService();