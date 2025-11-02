import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/crop_provider.dart';
import '../models/crop_model.dart';


class CropDetailScreen extends StatelessWidget {
  final String cropId;
  const CropDetailScreen({Key? key, required this.cropId}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<CropProvider>(context);
    final CropModel? crop = prov.byId(cropId);


    if (prov.loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (crop == null) return Scaffold(body: Center(child: Text('Crop not found')));


    return Scaffold(
      appBar: AppBar(title: Text(crop.name)),
      body: ListView(padding: const EdgeInsets.all(12), children: [
        if (crop.image.isNotEmpty) Image.network(crop.image, height: 200, fit: BoxFit.cover),
        const SizedBox(height: 12),
        Text(crop.name, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text('Best season: ${crop.bestSeason}'),
        const SizedBox(height: 8),
        Text('Watering: ${crop.watering}'),
        const SizedBox(height: 12),
        Card(child: Padding(padding: const EdgeInsets.all(12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Economics', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height:8),
          Text('Average cost: RM ${crop.avgCost.toStringAsFixed(2)}'),
          Text('Average revenue: RM ${crop.avgRevenue.toStringAsFixed(2)}'),
          Text('Profit margin: ${crop.profitMargin.toStringAsFixed(1)}%'),
        ]))),
        const SizedBox(height: 12),
        Card(child: Padding(padding: const EdgeInsets.all(12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Common diseases', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height:8),
          ...crop.diseases.map((d) => Text('• $d'))
        ]))),
      ]),
    );
  }
}