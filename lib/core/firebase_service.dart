import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/ledger_entry.dart';


class FirebaseService {
  FirebaseService._();
  static final instance = FirebaseService._();


  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;


  User? get user => _auth.currentUser;


  Future<void> initAndSignIn() async {
    if (_auth.currentUser == null) {
      await _auth.signInAnonymously();
    }
  }


  CollectionReference<Map<String, dynamic>> ledgerRef() =>
      _db.collection('users').doc(user!.uid).collection('ledger');


  CollectionReference<Map<String, dynamic>> remindersRef() =>
      _db.collection('users').doc(user!.uid).collection('reminders');


  CollectionReference<Map<String, dynamic>> knowledgeRef() =>
      _db.collection('knowledge_base');


  Stream<List<LedgerEntry>> ledgerStream() =>
      ledgerRef().orderBy('date', descending: true).snapshots().map((s) =>
          s.docs.map((d) => LedgerEntry.fromMap(d.id, d.data())).toList());


  Future<void> addLedger(LedgerEntry e) async => await ledgerRef().add(e.toMap());
  Future<void> deleteLedger(String id) async => await ledgerRef().doc(id).delete();


  Stream<List<Map<String, dynamic>>> remindersStream() =>
      remindersRef().orderBy('createdAt', descending: true).snapshots().map((s) => s.docs.map((d) => {'id': d.id, ...d.data()}).toList());


  Future<void> addReminder(String text) async => await remindersRef().add({'text': text, 'createdAt': DateTime.now().toIso8601String()});
  Future<void> deleteReminder(String id) async => await remindersRef().doc(id).delete();


  Future<List<Map<String, dynamic>>> getKnowledge() async {
    final snap = await knowledgeRef().get();
    return snap.docs.map((d) => {'id': d.id, ...d.data()}).toList();
  }
  Future<void> addKnowledge(Map<String,dynamic> data) async => await knowledgeRef().add(data);
}