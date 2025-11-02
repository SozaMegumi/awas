class LedgerEntry {
  final String id;
  final String crop;
  final double revenue;
  final double cost;
  final DateTime date;
  LedgerEntry({required this.id, required this.crop, required this.revenue, required this.cost, required this.date});


  double get profit => revenue - cost;


  Map<String, dynamic> toMap() => {'crop': crop, 'revenue': revenue, 'cost': cost, 'date': date.toIso8601String()};


  factory LedgerEntry.fromMap(String id, Map<String, dynamic> m) => LedgerEntry(
    id: id,
    crop: m['crop'] ?? '',
    revenue: (m['revenue'] ?? 0).toDouble(),
    cost: (m['cost'] ?? 0).toDouble(),
    date: DateTime.parse(m['date'] ?? DateTime.now().toIso8601String()),
  );
}