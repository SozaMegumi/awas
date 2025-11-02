import 'package:flutter/material.dart';
import '../core/firebase_service.dart';
import '../models/ledger_entry.dart';


class LedgerScreen extends StatefulWidget {
  const LedgerScreen({super.key});
  @override State<LedgerScreen> createState() => _LedgerScreenState();
}


class _LedgerScreenState extends State<LedgerScreen> {
  final cropCtl = TextEditingController();
  final revenueCtl = TextEditingController();
  final costCtl = TextEditingController();


  @override Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(children: [
        Row(children: [Expanded(child: TextField(controller: cropCtl, decoration: const InputDecoration(hintText: 'Crop'))), SizedBox(width: 8), SizedBox(width: 120, child: TextField(controller: revenueCtl, decoration: const InputDecoration(hintText: 'Revenue'))), SizedBox(width: 8), SizedBox(width: 120, child: TextField(controller: costCtl, decoration: const InputDecoration(hintText: 'Cost'))), IconButton(icon: const Icon(Icons.save), onPressed: () async { final crop = cropCtl.text.trim(); final rev = double.tryParse(revenueCtl.text) ?? 0.0; final cost = double.tryParse(costCtl.text) ?? 0.0; if (crop.isEmpty) return; await FirebaseService.instance.addLedger(LedgerEntry(id: '', crop: crop, revenue: rev, cost: cost, date: DateTime.now())); cropCtl.clear(); revenueCtl.clear(); costCtl.clear(); })]),
        const SizedBox(height: 12),
        Expanded(child: StreamBuilder<List<LedgerEntry>>(stream: FirebaseService.instance.ledgerStream(), builder: (context, snap) { if (!snap.hasData) return const Center(child: CircularProgressIndicator()); final entries = snap.data!; final pf = <String,double>{}; for (var e in entries) pf[e.crop] = (pf[e.crop] ?? 0) + e.profit; return ListView(children: [ const ListTile(title: Text('Profit per crop')), ...pf.entries.map((e) => ListTile(title: Text(e.key), trailing: Text('RM ' + e.value.toStringAsFixed(2)))), const Divider(), ...entries.map((en) => ListTile(title: Text(en.crop), subtitle: Text(en.date.toIso8601String()), trailing: Row(mainAxisSize: MainAxisSize.min, children: [Text('RM ' + en.profit.toStringAsFixed(2)), IconButton(icon: const Icon(Icons.delete), onPressed: () => FirebaseService.instance.deleteLedger(en.id))]))).toList()]); }))
      ]),
    );
  }
}