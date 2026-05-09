import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tzdata;
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

  bool get _supportsLocalNotifications =>
      !kIsWeb && (Platform.isAndroid || Platform.isIOS);

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

  Future<void> _configureLocalTimeZone() async {
    tzdata.initializeTimeZones();
    try {
      final TimezoneInfo info = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(info.identifier));
    } catch (_) {
      tz.setLocalLocation(tz.UTC);
    }
  }

  Future<void> initNotifications() async {
    if (!_supportsLocalNotifications) {
      return;
    }

    await _configureLocalTimeZone();

    const DarwinInitializationSettings darwinSettings =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/launcher_icon');
    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
    );

    await _plugin.initialize(settings: initSettings);

    if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidPlugin =
          _plugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

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
  }

  /// Runs after the first frame so Android has an [Activity] for the
  /// notification permission prompt, then schedules engagement notifications.
  Future<void> ensurePermissionsAndScheduleEngagementNotifications() async {
    if (!_supportsLocalNotifications) {
      return;
    }

    if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? android =
          _plugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      await android?.requestNotificationsPermission();
    } else if (Platform.isIOS) {
      await _plugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    }

    await handleAppLaunch();
  }

  /// Prompts for notification permission when the OS reports it is not granted
  /// yet (e.g. after a round). Reschedules engagement notifications if granted.
  Future<void> requestNotificationPermissionIfDenied() async {
    if (!_supportsLocalNotifications) {
      return;
    }

    if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? android =
          _plugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      if (android == null) {
        return;
      }
      final bool? enabled = await android.areNotificationsEnabled();
      if (enabled == true) {
        return;
      }
      await android.requestNotificationsPermission();
      if (await android.areNotificationsEnabled() == true) {
        await handleAppLaunch();
      }
      return;
    }

    if (Platform.isIOS) {
      final IOSFlutterLocalNotificationsPlugin? ios =
          _plugin.resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>();
      if (ios == null) {
        return;
      }
      final NotificationsEnabledOptions? opts = await ios.checkPermissions();
      final bool granted = opts != null &&
          (opts.isEnabled || opts.isProvisionalEnabled) &&
          opts.isAlertEnabled;
      if (granted) {
        return;
      }
      final bool? accepted = await ios.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      if (accepted == true) {
        await handleAppLaunch();
      }
    }
  }

  Future<void> handleAppLaunch() async {
    if (!_supportsLocalNotifications) {
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
    if (!_supportsLocalNotifications) {
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
    if (!_supportsLocalNotifications) {
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
    if (!_supportsLocalNotifications) {
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
    return NotificationDetails(
      android: const AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDescription,
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
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
