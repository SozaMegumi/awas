import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart'; // For debugPrint

import 'location_service.dart';
import '../utils/constants.dart';

/// Custom exception for errors related to the weather API.
class WeatherApiException implements Exception {
  final String message;
  WeatherApiException(this.message);

  @override
  String toString() => message;
}

/// Custom exception for errors related to the location service.
class LocationServiceException implements Exception {
  final String message;
  LocationServiceException(this.message);

  @override
  String toString() => message;
}

/// A service class to interact with the OpenWeatherMap API.
class WeatherService {
  /// Fetches weather data for a given latitude and longitude.
  ///
  /// Throws a [WeatherApiException] if the network request fails, returns a
  /// non-200 status code, or if there's an issue decoding the response.
  Future<Map<String, dynamic>> fetchByCoords({required double lat, required double lon}) async {
    // Construct the API request URI with query parameters.
    final uri = Uri.parse(kOpenWeatherEndpoint).replace(queryParameters: {
      'lat': lat.toString(),
      'lon': lon.toString(),
      'exclude': 'minutely', // Exclude minute-by-minute forecast data.
      'units': 'metric',     // Use metric units (Celsius).
      'appid': kOpenWeatherApiKey,
    });

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, then parse the JSON.
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        // If the server did not return a 200 OK response,
        // throw an exception with the status code.
        throw WeatherApiException('Failed to load weather data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Catches network errors (e.g., no internet) or other exceptions during the request.
      debugPrint('Error in fetchByCoords: $e');
      // Re-throw a more user-friendly exception.
      throw WeatherApiException('Failed to connect to the weather service. Please check your network connection.');
    }
  }

  /// Fetches weather for the user's current device location.
  ///
  /// This method first gets the current location and then calls [fetchByCoords].
  ///
  /// Throws a [LocationServiceException] if the location cannot be determined.
  /// Throws a [WeatherApiException] if the subsequent weather data fetch fails.
  Future<Map<String, dynamic>> fetchLocalWeather() async {
    // Instantiate location service to get the current position.
    final locationService = LocationService();

    try {
      // Get the current GPS position.
      final position = await locationService.getCurrentPosition();

      // The fetchByCoords method will handle its own errors, which will be
      // caught and propagated by the try-catch block here.
      return await fetchByCoords(lat: position.latitude, lon: position.longitude);

    } on LocationPermissionException catch (e) {
      // If getting the location fails due to permissions, throw a specific exception.
      throw LocationServiceException(e.toString());
    } catch (e) {
      // Catches other potential errors from LocationService or re-throws WeatherApiException.
      debugPrint('Error in fetchLocalWeather: $e');
      rethrow;
    }
  }
}

/// A global singleton instance of the WeatherService for easy access
/// throughout the app. This is a simple approach to service location.
final weatherService = WeatherService();
