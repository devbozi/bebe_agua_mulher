import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import '../models/hydration_settings.dart';
import '../theme/app_theme.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized) return;

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    _initialized = true;
  }

  static void _onNotificationTapped(NotificationResponse response) {
    // Aqui você pode adicionar lógica para quando a notificação é tocada
    debugPrint('Notificação tocada: ${response.payload}');
  }

  static Future<void> scheduleReminders(HydrationSettings settings) async {
    if (!settings.notificationsEnabled) return;

    // Cancelar notificações existentes
    await cancelAllNotifications();

    final now = DateTime.now();
    final startTime = DateTime(now.year, now.month, now.day, settings.startHour);
    final endTime = DateTime(now.year, now.month, now.day, settings.endHour);

    // Se o horário de início já passou hoje, começar amanhã
    DateTime currentTime = startTime.isBefore(now) 
        ? startTime.add(const Duration(days: 1))
        : startTime;

    int notificationId = 1;

    while (currentTime.isBefore(endTime.add(const Duration(days: 1)))) {
      // Se passou do horário de fim, pular para o próximo dia
      if (currentTime.hour >= settings.endHour && currentTime.day != startTime.day) {
        currentTime = DateTime(currentTime.year, currentTime.month, currentTime.day + 1, settings.startHour);
        continue;
      }

      await _scheduleNotification(
        id: notificationId++,
        scheduledTime: currentTime,
        message: settings.customMessage.isNotEmpty 
            ? settings.customMessage 
            : AppTheme.notificationMessages[notificationId % AppTheme.notificationMessages.length],
      );

      currentTime = currentTime.add(Duration(minutes: settings.reminderInterval));
    }
  }

  static Future<void> _scheduleNotification({
    required int id,
    required DateTime scheduledTime,
    required String message,
  }) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'hydration_reminders',
      'Lembretes de Hidratação',
      channelDescription: 'Notificações para lembrar de beber água',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      icon: '@mipmap/ic_launcher',
      color: Color(0xFFE91E63),
      playSound: true,
      enableVibration: true,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      id,
      'Hora de se hidratar! 💧',
      message,
      details,
    );
  }

  static Future<void> showImmediateNotification(String message) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'immediate_reminder',
      'Lembrete Imediato',
      channelDescription: 'Lembrete imediato para beber água',
      importance: Importance.max,
      priority: Priority.max,
      showWhen: true,
      icon: '@mipmap/ic_launcher',
      color: Color(0xFFE91E63),
      playSound: true,
      enableVibration: true,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      'Hora de se hidratar! 💧',
      message,
      details,
    );
  }

  static Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  static Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  static Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notifications.pendingNotificationRequests();
  }
}
