import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();


  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();


  Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final settings = InitializationSettings(android: android);
    await _plugin.initialize(settings);
  }


  Future<void> show(String title, String body) async {
    const androidDetails = AndroidNotificationDetails('agri_alerts', 'Agri Alerts', channelDescription: 'Weather and reminders');
    await _plugin.show(0, title, body, NotificationDetails(android: androidDetails));
  }
}