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
    final current = w