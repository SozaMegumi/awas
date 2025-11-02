import 'package:flutter/material.dart';

/// Minimal WeatherProvider used by the weather alert screen.
/// This provides a synchronous mock fetch for local testing and analysis.
class WeatherProvider extends ChangeNotifier {
	bool loading = false;
	String? error;
	Map<String, dynamic>? data;

	/// Mock fetch: in a real app this would call a weather API.
	Future<void> fetch(double lat, double lon) async {
		loading = true;
		error = null;
		data = null;
		notifyListeners();

		try {
			// Simulate network delay
			await Future.delayed(const Duration(seconds: 1));
			data = {
				'current': {
					'temp': 28.5,
					'weather': [
						{'main': 'Clear', 'description': 'clear sky'}
					]
				},
				'alerts': [],
			};
		} catch (e) {
			error = e.toString();
		}

		loading = false;
		notifyListeners();
	}
}