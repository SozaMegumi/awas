import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import '../providers/weather_provider.dart';


class WeatherAlertScreen extends StatefulWidget {
  const WeatherAlertScreen({Key? key}) : super(key: key);

  @override
  State<WeatherAlertScreen> createState() => _WeatherAlertScreenState();
}


class _WeatherAlertScreenState extends State<WeatherAlertScreen> {
  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<WeatherProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(children: [
        ElevatedButton.icon(
          onPressed: () async {
            final pos = await _determinePosition();
            if (pos == null) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Location permission denied')));
              return;
            }
            await prov.fetch(pos.latitude, pos.longitude);
          },
          icon: const Icon(Icons.my_location),
          label: const Text('Fetch Local Weather & Alerts'),
        ),
        const SizedBox(height: 12),
        if (prov.loading) const CircularProgressIndicator(),
        if (prov.error != null) Text('Error: ${prov.error}'),
        if (prov.data != null) Expanded(child: _buildWeatherView(prov.data!)),
      ]),
    );
  }

  Widget _buildWeatherView(Map<String,dynamic> w) {
    final current = w['current'] as Map<String, dynamic>? ?? {};
    final temp = current['temp']?.toString() ?? '-';
    final weather = ((current['weather'] as List?)?.firstWhere((_) => true, orElse: () => null) ?? {}) as Map<String, dynamic>?;
    final descr = weather?['description'] ?? '-';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Current temperature: $temp °C', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Conditions: $descr'),
            const SizedBox(height: 8),
            if ((w['alerts'] as List?)?.isNotEmpty ?? false) ...[
              const Divider(),
              const Text('Alerts:', style: TextStyle(fontWeight: FontWeight.bold)),
              for (final a in (w['alerts'] as List)) Text(a.toString()),
            ],
          ],
        ),
      ),
    );
  }

  Future<Position?> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return null;
    }

    return await Geolocator.getCurrentPosition();
  }
}