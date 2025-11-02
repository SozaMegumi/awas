
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/crop_model.dart';

class CropProvider with ChangeNotifier {
  final List<CropModel> _crops = [];
  bool loading = false;

  List<CropModel> get crops => _crops;

  CropProvider() {
    fetchCrops();
  }

  Future<void> fetchCrops() async {
    loading = true;
    notifyListeners();
    try {
      final snapshot = await FirebaseFirestore.instance.collection('crops').get();
      _crops.clear();
      for (var doc in snapshot.docs) {
        _crops.add(CropModel.fromFirestore(doc));
      }
    } catch (e) {
      debugPrint('Error fetching crops: $e');
    }
    loading = false;
    notifyListeners();
  }

  CropModel? byId(String id) {
    try {
      return _crops.firstWhere((crop) => crop.id == id);
    } catch (e) {
      return null;
    }
  }
}
