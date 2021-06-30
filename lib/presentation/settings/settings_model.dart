import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class SettingsModel extends ChangeNotifier {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  bool isInitDate = false;
  int counter;
  int lensStock;
  int washerStock;
  int difference;
  DateTime today = DateTime.now();

  // String startYear;
  // String startMonth;
  // String startDay;
  int startTimeStamp;
  int goalTimeStamp;
  DateTime startDate;
  String startDateText;
  DateTime goalDate;
  String goalDateText;
  bool isPressed = false;
  bool pushOn = false;
  String number;
  final Map<int, Widget> logoWidgets = const <int, Widget>{
    0: Text("2Weeks"),
    1: Text("1Month"),
    2: Text("3Months")
  };
  final Map<int, Widget> pushDateSet = const <int, Widget>{
    0: Text("前日"),
    1: Text("最終日"),
  };
  int theirGroupValue = 0;
  int pushDateValue = 0;
  DateTime pushTime;
  DateTime pushDate;
  int pushHour = 18;
  int pushMin = 00;

  String pushTimeText = '18:00';
  String notificationBody;
  DateFormat outputFormatYMD = DateFormat('MM月dd日');

  void pressedButton() {
    isPressed = !isPressed;
    notifyListeners();
  }

  void initialize() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.startDateText = outputFormatYMD.format(startDate);
    this.goalDateText = outputFormatYMD.format(goalDate);
    await prefs.setString('startDate', startDateText);
    await prefs.setString('goalDate', goalDateText);
  }

  void getStartDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    startTimeStamp = prefs.getInt('startTimeStamp');
    goalTimeStamp = prefs.getInt('goalTimeStamp');
    this.startDate = DateTime.fromMillisecondsSinceEpoch(startTimeStamp);
    this.goalDate = DateTime.fromMillisecondsSinceEpoch(goalTimeStamp);
    if (goalDate == null) {
      initialize();
    }
    this.startDateText = prefs.getString('startDate');
    this.goalDateText = prefs.getString('goalDate');
    notifyListeners();
  }

  void changeSwitch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    pushOn = !pushOn;
    print(pushOn);
    // if (pushOn) scheduleDailyTenAMNotification();
    if (pushOn == true) {
      resetNotification(goalDate, pushHour, pushMin);
      print('通知します');
    } else if (pushOn == false) {
      await flutterLocalNotificationsPlugin.cancelAll();
      print('キャンセル');
    }
    prefs.setBool('pushOn', pushOn);
    notifyListeners();
  }

  void setStartDay(Picker picker, DateTime value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.startDate = value;
    this.goalDate = startDate.add(new Duration(days: (counter - 1)));
    startDateText = outputFormatYMD.format(startDate);
    goalDateText = outputFormatYMD.format(goalDate);
    startTimeStamp = startDate.millisecondsSinceEpoch;
    goalTimeStamp = goalDate.millisecondsSinceEpoch;
    await prefs.setInt('startTimeStamp', startTimeStamp);
    await prefs.setInt('goalTimeStamp', goalTimeStamp);
    await prefs.setString('startDate', startDateText);
    await prefs.setString('goalDate', goalDateText);
    this.startDateText = prefs.getString('startDate');
    if (pushOn) resetNotification(goalDate, pushHour, pushMin);
    notifyListeners();
  }

  void getSlidingLimit() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    this.theirGroupValue = prefs.getInt('limit') ?? 0;
  }

  void slidingLimitControl(changeFormGroupValue) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    this.theirGroupValue = changeFormGroupValue;
    switch (theirGroupValue) {
      case 0:
        setLimitCounter(14);
        await prefs.setInt('limit', 0);
        break;
      case 1:
        setLimitCounter(30);
        await prefs.setInt('limit', 1);
        break;
      case 2:
        setLimitCounter(90);
        await prefs.setInt('limit', 2);
        break;
    }
    this.counter = prefs.getInt('counter');
    notifyListeners();
  }

  void setLimitCounter(counter) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('counter', counter);
    this.goalDate = startDate.add(new Duration(days: (counter - 1)));
    this.goalDateText = outputFormatYMD.format(goalDate);
    startTimeStamp = startDate.millisecondsSinceEpoch;
    goalTimeStamp = goalDate.millisecondsSinceEpoch;
    await prefs.setInt('startTimeStamp', startTimeStamp);
    await prefs.setInt('goalTimeStamp', goalTimeStamp);
    await prefs.setString('goalDate', goalDateText);
    if (pushOn) resetNotification(goalDate, pushHour, pushMin);
    notifyListeners();
  }

  void getCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (counter == 0) {
      counter = 14;
      await prefs.setInt('counter', counter);
      this.counter = prefs.getInt('counter') ?? 14;
    } else {
      this.counter = prefs.getInt('counter') ?? 14;
    }
    notifyListeners();
  }

  void pickCounter(List value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    counter = value[0] + 1;
    this.goalDate = startDate.add(new Duration(days: (counter - 1)));
    this.goalDateText = outputFormatYMD.format(goalDate);
    startTimeStamp = startDate.millisecondsSinceEpoch;
    goalTimeStamp = goalDate.millisecondsSinceEpoch;
    await prefs.setInt('startTimeStamp', startTimeStamp);
    await prefs.setInt('goalTimeStamp', goalTimeStamp);
    await prefs.setInt('counter', counter);
    await prefs.setString('goalDate', goalDateText);
    if (pushOn) resetNotification(goalDate, pushHour, pushMin);
    notifyListeners();
  }

  void incrementCounter() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    counter = (prefs.getInt('counter') ?? 0) + 1;
    this.goalDate = startDate.add(new Duration(days: (counter - 1)));
    startTimeStamp = startDate.millisecondsSinceEpoch;
    goalTimeStamp = goalDate.millisecondsSinceEpoch;
    await prefs.setInt('startTimeStamp', startTimeStamp);
    await prefs.setInt('goalTimeStamp', goalTimeStamp);
    this.goalDateText = outputFormatYMD.format(goalDate);
    await prefs.setInt('counter', counter);
    await prefs.setString('goalDate', goalDateText);
    if (pushOn) resetNotification(goalDate, pushHour, pushMin);
    notifyListeners();
  }

  void decrementCounter() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (counter > 1) counter = (prefs.getInt('counter') ?? 0) - 1;
    this.goalDate = startDate.add(new Duration(days: (counter - 1)));
    startTimeStamp = startDate.millisecondsSinceEpoch;
    goalTimeStamp = goalDate.millisecondsSinceEpoch;
    await prefs.setInt('startTimeStamp', startTimeStamp);
    await prefs.setInt('goalTimeStamp', goalTimeStamp);
    this.goalDateText = outputFormatYMD.format(goalDate);
    await prefs.setString('goalDate', goalDateText);
    await prefs.setInt('counter', counter);
    if (pushOn) resetNotification(goalDate, pushHour, pushMin);
    notifyListeners();
  }

  void resetCounter() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('counter', 14);
    this.counter = prefs.getInt('counter') ?? 0;
    notifyListeners();
  }

  void pickStock(List value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    this.lensStock = value[0];
    await prefs.setInt('stock', lensStock);
    notifyListeners();
  }

  void incrementStock(int num) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    lensStock = (prefs.getInt('stock') ?? 0) + num;
    await prefs.setInt('stock', lensStock);
    notifyListeners();
  }

  void decrementStock() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (lensStock > 0) lensStock = (prefs.getInt('stock') ?? 0) - 1;
    await prefs.setInt('stock', lensStock);
    notifyListeners();
  }

  void getLensStock() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.lensStock = prefs.getInt('stock') ?? 6;
    notifyListeners();
  }

  void pickWasher(List value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    this.washerStock = value[0];
    await prefs.setInt('washer', washerStock);
    notifyListeners();
  }

  void incrementWasher(int num) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    washerStock = (prefs.getInt('washer') ?? 0) + num;
    await prefs.setInt('washer', washerStock);
    notifyListeners();
  }

  void incrementNumberWasher(int num) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    washerStock = (prefs.getInt('washer') ?? 0) + num;
    await prefs.setInt('washer', washerStock);
    notifyListeners();
  }

  void decrementWasher() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (washerStock > 0) washerStock = (prefs.getInt('washer') ?? 0) - 1;
    await prefs.setInt('washer', washerStock);
    notifyListeners();
  }

  void getWasherStock() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.washerStock = prefs.getInt('washer') ?? 3;
    notifyListeners();
  }

  void getNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.pushOn = prefs.getBool('pushOn') ?? pushOn;
    this.pushTimeText = prefs.getString('pushTimeText') ?? pushTimeText;
    this.pushDateValue = prefs.getInt('pushDate') ?? pushDateValue;
    this.pushHour = prefs.getInt('pushHour') ?? pushHour;
    this.pushMin = prefs.getInt('pushMin') ?? pushMin;
  }

  void setPushTime(Picker picker, List value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateFormat outputFormatHm = DateFormat('Hm');
    pushTime = DateTime.utc(0, 0, 0, value[0], value[1], 0);
    pushTimeText = outputFormatHm.format(pushTime);
    await prefs.setString('pushTimeText', pushTimeText);
    this.pushTimeText = prefs.getString('pushTimeText');
    this.pushHour = value[0];
    this.pushMin = value[1];
    await prefs.setInt('pushTimeHour', pushHour);
    await prefs.setInt('pushTimeMin', pushMin);
    if (pushOn) resetNotification(goalDate, pushHour, pushMin);
    notifyListeners();
  }

  void slidingPushDateControl(changeFormGroupValue) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    this.pushDateValue = changeFormGroupValue;
    switch (pushDateValue) {
      case 0:
        await prefs.setInt('pushDate', 0);
        break;
      case 1:
        await prefs.setInt('pushDate', 1);
        break;
    }
    resetNotification(goalDate, pushHour, pushMin);
    notifyListeners();
  }

  void setPushDate(counterValue) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    DateFormat outputFormatYMD = DateFormat('y年MM月dd日');
    counter = counterValue;
    await prefs.setInt('counter', counter);
    this.goalDate = startDate.add(new Duration(days: counter));
    this.goalDateText = outputFormatYMD.format(goalDate);
    await prefs.setString('goalDate', goalDateText);
    notifyListeners();
  }

  void resetNotification(DateTime goalDate, int pushHour, int pushMin) async {
    await flutterLocalNotificationsPlugin.cancelAll();
    scheduleGoalDateNotification(goalDate, pushHour, pushMin);
  }

  void scheduleGoalDateNotification(
      DateTime goalDate, int pushHour, int pushMin) async {
    if (pushDateValue == 0) {
      notificationBody = '明日でレンズの期限が切れます';
      pushDate = goalDate.add(Duration(days: -1));
    } else if (pushDateValue == 1) {
      notificationBody = '今日でレンズの期限が切れます';
      pushDate = goalDate;
    }

    await _configureLocalTimeZone();
    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        '使用期限通知',
        notificationBody,
        _nextInstanceOfGoalDate(pushDate),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'notification channel id',
            'notification channel name',
            'notification description',
          ),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time);
  }

  tz.TZDateTime _nextInstanceOfGoalDate(DateTime pushDate) {
    // final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    // year, month, day, hour, minutes, second
    //TODO 指定した日時に設定する
    // tz.TZDateTime scheduledDate =
    //     tz.TZDateTime(tz.local, now.year, now.month, now.day, 1, 33);
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, pushDate.year,
        pushDate.month, pushDate.day, pushHour, pushMin);
    // if (scheduledDate.isBefore(now)) {
    //   scheduledDate = scheduledDate.add(const Duration(days: 1));
    // }
    return scheduledDate;
  }

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  void initializePlatformSpecifics() {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: false,
      onDidReceiveLocalNotification: (id, title, body, payload) async {
        // your call back to the UI
      },
    );

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String payload) async {
      //onNotificationClick(payload); // your call back to the UI
    });
  }
}
