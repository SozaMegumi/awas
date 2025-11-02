class CropInfo {
  final String id; final String name; final String tips;
  CropInfo({required this.id, required this.name, required this.tips});
  factory CropInfo.fromMap(String id, Map<String,dynamic> m) => CropInfo(id: id, name: m['name'] ?? '', tips: m['tips'] ?? '');
}