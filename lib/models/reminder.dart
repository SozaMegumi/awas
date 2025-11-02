class ReminderModel {
  final String id; final String text; final DateTime createdAt;
  ReminderModel({required this.id, required this.text, required this.createdAt});
  factory ReminderModel.fromMap(String id, Map<String,dynamic> m) => ReminderModel(id: id, text: m['text'] ?? '', createdAt: DateTime.parse(m['createdAt']));
}