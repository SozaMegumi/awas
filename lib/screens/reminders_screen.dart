import 'package:flutter/material.dart';
import '../core/firebase_service.dart';
import '../core/notification_service.dart';


class RemindersScreen extends StatefulWidget {
  const RemindersScreen({super.key});

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}


class _RemindersScreenState extends State<RemindersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reminders')),
      body: const Center(
        child: Text('Reminders screen (placeholder)'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: implement add reminder / schedule notification
        },
        child: const Icon(Icons.add_alarm),
      ),
    );
  }
}