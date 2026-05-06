import 'dart:io';
import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

enum NotificationType {
  dailyReminder,
  funSocial,
  comebackEmotional,
  challengeMessage,
}

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  static const String _lastOpenTimeKey = 'notification_last_open_time';
  static const String _lastMessageIndexKey = 'notification_last_message_index';

  static const int _dailyNotificationId = 100;
  static const int _inactive24hNotificationId = 101;
  static const int _inactive48hNotificationId = 102;
  static const int _inactive72hNotificationId = 103;

  static const String _channelId = 'smart_engagement_channel';
  static const String _channelName = 'Smart Engagement';
  static const String _channelDescription =
      'Daily and inactivity engagement notifications';

  static const int _dailyHour = 20;
  static const int _jitterMinutes = 30;

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  final Random _random = Random();

  final Map<NotificationType, List<String>> _messagesByType =
      <NotificationType, List<String>>{
        NotificationType.dailyReminder: <String>[
          '😏 مين فيكم الجاسوس؟',
          '😏 Who is the spy today?',
          '🔥 جاهز لجولة سريعة؟',
          '🔥 Ready for a quick round?',
        ],
        NotificationType.funSocial: <String>[
          '👀 في حد بيكدب… تعال اكتشفه',
          '👀 Someone is lying… find them!',
          '😂 اللعبة مش ممتعة من غيرك',
          '😂 The game is not fun without you',
        ],
        NotificationType.comebackEmotional: <String>[
          '😱 شكلك أنت الجاسوس!',
          '😱 You might be the spy!',
          'أصحابك مستنيينك… الجولة ناقصها واحد',
          'Your friends are waiting... one player is missing',
        ],
        NotificationType.challengeMessage: <String>[
          'التحدي مستنيك اليوم… تقدر تكشف الجاسوس؟',
          'A challenge awaits... can you expose the spy?',
          'رجعتك تعني جولة أمتع للجميع',
          'Your comeback makes every round better',
        ],
      };

  Future<void> initNotifications() async {
    if (!Platform.isAndroid) {
      return;
    }

    tz.initializeTimeZones();

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/launcher_icon');
    const InitializationSettings initSettings =
        InitializationSettings(android: androidSettings);

    await _plugin.initialize(settings: initSettings);

    final AndroidFlutterLocalNotificationsPlugin? androidPlugin =
        _plugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.requestNotificationsPermission();

    await androidPlugin?.createNotificationChannel(
      const AndroidNotificationChannel(
        _channelId,
        _channelName,
        description: _channelDescription,
        importance: Importance.high,
        playSound: true,
      ),
    );
  }

  Future<void> handleAppLaunch() async {
    if (!Platform.isAndroid) {
      return;
    }

    await updateLastOpenTime();
    await _cancelManagedNotifications();
    await scheduleDailyNotification();
    await scheduleInactiveNotification();
  }

  Future<void> updateLastOpenTime() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
      _lastOpenTimeKey,
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  Future<bool> shouldSendNotification() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int? lastOpenMillis = prefs.getInt(_lastOpenTimeKey);
    if (lastOpenMillis == null) {
      return true;
    }

    final DateTime lastOpen = DateTime.fromMillisecondsSinceEpoch(
      lastOpenMillis,
    );
    final DateTime now = DateTime.now();
    return !_isSameDay(lastOpen, now);
  }

  Future<void> scheduleDailyNotification() async {
    if (!Platform.isAndroid) {
      return;
    }

    final DateTime now = DateTime.now();
    final bool openedToday = !(await shouldSendNotification());

    DateTime target = DateTime(now.year, now.month, now.day, _dailyHour);
    if (openedToday || !target.isAfter(now)) {
      target = target.add(const Duration(days: 1));
    }

    final String message = await getRandomMessage(
      NotificationType.dailyReminder,
    );

    await _scheduleZoned(
      id: _dailyNotificationId,
      title: _titleForType(NotificationType.dailyReminder),
      body: message,
      scheduledDateTime: _withRandomJitter(target),
    );
  }

  Future<void> scheduleInactiveNotification() async {
    if (!Platform.isAndroid) {
      return;
    }

    final DateTime now = DateTime.now();

    await _scheduleZoned(
      id: _inactive24hNotificationId,
      title: _titleForType(NotificationType.funSocial),
      body: await getRandomMessage(NotificationType.funSocial),
      scheduledDateTime:
          _withRandomJitter(now.add(const Duration(hours: 24))),
    );

    await _scheduleZoned(
      id: _inactive48hNotificationId,
      title: _titleForType(NotificationType.comebackEmotional),
      body: await getRandomMessage(NotificationType.comebackEmotional),
      scheduledDateTime:
          _withRandomJitter(now.add(const Duration(hours: 48))),
    );

    await _scheduleZoned(
      id: _inactive72hNotificationId,
      title: _titleForType(NotificationType.challengeMessage),
      body: await getRandomMessage(NotificationType.challengeMessage),
      scheduledDateTime:
          _withRandomJitter(now.add(const Duration(hours: 72))),
    );
  }

  Future<String> getRandomMessage(NotificationType type) async {
    final List<String> pool = _messagesByType[type] ?? <String>[];
    if (pool.isEmpty) {
      return '';
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int previousIndex = prefs.getInt(_lastMessageIndexKey) ?? -1;

    int selectedIndex;
    if (pool.length == 1) {
      selectedIndex = 0;
    } else {
      do {
        selectedIndex = _random.nextInt(pool.length);
      } while (selectedIndex == previousIndex);
    }

    await prefs.setInt(_lastMessageIndexKey, selectedIndex);
    return pool[selectedIndex];
  }

  Future<void> showInstantNotification({
    required NotificationType type,
    String? title,
    String? body,
  }) async {
    if (!Platform.isAndroid) {
      return;
    }

    final String resolvedBody = body ?? await getRandomMessage(type);
    await _plugin.show(
      id: 999,
      title: title ?? _titleForType(type),
      body: resolvedBody,
      notificationDetails: _notificationDetails(),
    );
  }

  Future<void> _cancelManagedNotifications() async {
    await _plugin.cancel(id: _dailyNotificationId);
    await _plugin.cancel(id: _inactive24hNotificationId);
    await _plugin.cancel(id: _inactive48hNotificationId);
    await _plugin.cancel(id: _inactive72hNotificationId);
  }

  Future<void> _scheduleZoned({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDateTime,
  }) async {
    await _plugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: tz.TZDateTime.from(scheduledDateTime, tz.local),
      notificationDetails: _notificationDetails(),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  NotificationDetails _notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDescription,
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
      ),
    );
  }

  String _titleForType(NotificationType type) {
    switch (type) {
      case NotificationType.dailyReminder:
        return 'وقت اللعب';
      case NotificationType.funSocial:
        return 'الجولة بدأت!';
      case NotificationType.comebackEmotional:
        return 'اشتقنالك';
      case NotificationType.challengeMessage:
        return 'تحدي جديد';
    }
  }

  DateTime _withRandomJitter(DateTime base) {
    final int offsetMinutes =
        _random.nextInt((_jitterMinutes * 2) + 1) - _jitterMinutes;
    return base.add(Duration(minutes: offsetMinutes));
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
