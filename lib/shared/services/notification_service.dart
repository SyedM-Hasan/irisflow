import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService instance = NotificationService._();
  NotificationService._();

  final _plugin = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
      macOS: darwinSettings,
    );
    await _plugin.initialize(settings);

    // Request POST_NOTIFICATIONS permission on Android 13+
    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  // Single ID so every new notification replaces the previous one.
  static const _notificationId = 0;

  Future<void> showFocusComplete() => _show(
    title: 'Focus Session Complete!',
    body: 'Great work! Time for a well-deserved break.',
  );

  Future<void> showRestComplete() =>
      _show(title: "Break's Over!", body: "Ready to focus again? Let's go!");

  Future<void> _show({required String title, required String body}) async {
    const androidDetails = AndroidNotificationDetails(
      'irisflow_timer',
      'Timer Notifications',
      channelDescription: 'Notifications for focus and rest timer events',
      importance: Importance.high,
      priority: Priority.high,
    );
    const darwinDetails = DarwinNotificationDetails();
    const details = NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
      macOS: darwinDetails,
    );
    await _plugin.show(_notificationId, title, body, details);
  }
}
