
import 'package:cloud_firestore/cloud_firestore.dart';

class CropModel {
  final String id;
  final String name;
  final String image;
  final String bestSeason;
  final String watering;
  final double avgCost;
  final double avgRevenue;
  final double profitMargin;
  final List<String> diseases;

  CropModel({
    required this.id,
    required this.name,
    required this.image,
    required this.bestSeason,
    required this.watering,
    required this.avgCost,
    required this.avgRevenue,
    required this.profitMargin,
    required this.diseases,
  });

  factory CropModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return CropModel(
      id: doc.id,
      name: data['name'] ?? '',
      image: data['image'] ?? '',
      bestSeason: data['bestSeason'] ?? '',
      watering: data['watering'] ?? '',
      avgCost: (data['avgCost'] ?? 0.0).toDouble(),
      avgRevenue: (data['avgRevenue'] ?? 0.0).toDouble(),
      profitMargin: (data['profitMargin'] ?? 0.0).toDouble(),
      diseases: List<String>.from(data['diseases'] ?? []),
    );
  }
}
