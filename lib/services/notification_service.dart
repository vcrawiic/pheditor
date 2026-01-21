import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._();
  static NotificationService get instance => _instance;

  NotificationService._();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  Future<void> _ensureInitialized() async {
    if (_initialized) return;

    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(iOS: iosSettings);
    await _notifications.initialize(initSettings);

    await _notifications
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    _initialized = true;
  }

  Future<void> showSaveSuccessNotification() async {
    await _ensureInitialized();

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(iOS: iosDetails);

    await _notifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      'Сохранено',
      'Изображение успешно сохранено',
      details,
    );
  }
}
