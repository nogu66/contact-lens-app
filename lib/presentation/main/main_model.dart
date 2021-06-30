import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class MainModel extends ChangeNotifier {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  int counter;
  int lensStock;
  int washerStock;
  DateTime today = DateTime.now();
  String startYear;
  String startMonth;
  String startDay;
  DateTime startDate = DateTime.now();
  DateTime goalDate;
  String startDateText;
  String goalDateText;
  DateFormat outputFormatYMD = DateFormat('MM月dd日');
  bool isLoading = false;

  int theirGroupValue = 0;
  int pushDateValue;
  DateTime pushDate;
  bool pushOn;
  DateTime pushTime;
  int pushHour;
  int pushMin;
  String notificationBody;

  int startTimeStamp;
  int goalTimeStamp;

<<<<<<< HEAD
  int todayCounter = 14;
  double percentage = 0.7;

=======
  int todayCounter = 0;
  double percentage = 0.7;

  void startLoading() {
    this.isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    this.isLoading = false;
    notifyListeners();
  }

  void getNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.pushOn = prefs.getBool('pushOn') ?? pushOn;
    this.pushDateValue = prefs.getInt('pushDate') ?? pushDateValue;
    this.pushHour = prefs.getInt('pushHour') ?? pushHour;
    this.pushMin = prefs.getInt('pushMin') ?? pushMin;
  }

  void getStartDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (startDateText == null) initialize();
    this.startDateText = prefs.getString('startDate');
    this.goalDateText = prefs.getString('goalDate');
    notifyListeners();
  }

>>>>>>> master
  void initialize() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    startDate = today;
    startDate = DateTime(startDate.year, startDate.month, startDate.day);
    goalDate = startDate.add(Duration(days: 13));
    goalDate = DateTime(goalDate.year, goalDate.month, goalDate.day);
    startTimeStamp = startDate.millisecondsSinceEpoch;
    goalTimeStamp = goalDate.millisecondsSinceEpoch;
    await prefs.setInt('startTimeStamp', startTimeStamp);
    await prefs.setInt('goalTimeStamp', goalTimeStamp);

    this.startDateText = outputFormatYMD.format(startDate);
    this.goalDateText = outputFormatYMD.format(goalDate);

    await prefs.setString('startDate', startDateText);
    await prefs.setString('goalDate', goalDateText);
    // this.startDateText = prefs.getString('startDate') ?? startDateText;
    // this.goalDateText = prefs.getString('goalDate') ?? goalDateText;
    counter = goalDate.difference(startDate).inDays + 1;
    await prefs.setInt('counter', counter);
    this.counter = prefs.getInt('counter') ?? 13;

    lensStock = 6;
    await prefs.setInt('stock', lensStock);
    this.lensStock = prefs.getInt('stock') ?? 6;

    washerStock = 3;
    await prefs.setInt('washer', washerStock);
    this.counter = prefs.getInt('counter') ?? 3;

    pushOn = false;
    pushHour = 18;
    await prefs.setInt('pushHour', pushHour);
    this.pushHour = prefs.getInt('pushHour') ?? 18;
    pushMin = 0;
    await prefs.setInt('pushMin', pushMin);
    this.pushMin = prefs.getInt('pushMin') ?? 0;

    pushDateValue = 0;
    await prefs.setInt('pushDate', pushDateValue);
    this.pushDateValue = prefs.getInt('pushDate') ?? pushDateValue;
    notifyListeners();
  }

  void getNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.pushOn = prefs.getBool('pushOn') ?? pushOn;
    this.pushDateValue = prefs.getInt('pushDate') ?? pushDateValue;
    this.pushHour = prefs.getInt('pushHour') ?? pushHour;
    this.pushMin = prefs.getInt('pushMin') ?? pushMin;
  }

  void getStartDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (startDateText == null) initialize();
    this.startDateText = prefs.getString('startDate');
    this.goalDateText = prefs.getString('goalDate');
    notifyListeners();
  }

  void reload() async {
    notifyListeners();
  }

  void getCounter() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // this.counter = prefs.getInt('counter') ?? counter;
    startTimeStamp = prefs.getInt('startTimeStamp');
    this.startDate = DateTime.fromMillisecondsSinceEpoch(startTimeStamp);
    this.startDate = DateTime(startDate.year, startDate.month, startDate.day);
    goalTimeStamp = prefs.getInt('goalTimeStamp');
    this.goalDate = DateTime.fromMillisecondsSinceEpoch(goalTimeStamp);
    this.goalDate = DateTime(goalDate.year, goalDate.month, goalDate.day);
<<<<<<< HEAD
    this.today = DateTime(today.year, today.month, today.day);
    this.counter = prefs.getInt('counter') ?? 14;
    this.todayCounter = goalDate.difference(today).inDays + 1;
    this.percentage = (todayCounter / counter);
=======
    this.counter = prefs.getInt('counter');
    today = DateTime(today.year, today.month, today.day);
    this.todayCounter = (goalDate.difference(today).inDays + 1);
    this.percentage = todayCounter / counter;
>>>>>>> master
    prefs.setDouble('percentage', percentage);
    await prefs.setInt('counter', counter);
    this.theirGroupValue = prefs.getInt('limit') ?? theirGroupValue;
    notifyListeners();
  }

  void resetCounter() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    this.theirGroupValue = prefs.getInt('limit') ?? 0;
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
    if (pushOn) resetNotification(goalDate, pushHour, pushMin);
    notifyListeners();
  }

  void setLimitCounter(counterValue) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    this.counter = counterValue;
    await prefs.setInt('counter', counter);
    this.startDate = today;
    this.goalDate = startDate.add(new Duration(days: (counter - 1)));
    this.startDateText = outputFormatYMD.format(startDate);
    this.goalDateText = outputFormatYMD.format(goalDate);
    await prefs.setString('startDate', startDateText);
    await prefs.setString('goalDate', goalDateText);
    startTimeStamp = startDate.millisecondsSinceEpoch;
    goalTimeStamp = goalDate.millisecondsSinceEpoch;
    await prefs.setInt('startTimeStamp', startTimeStamp);
    await prefs.setInt('goalTimeStamp', goalTimeStamp);
    if (pushOn) resetNotification(goalDate, pushHour, pushMin);
    notifyListeners();
  }

  void getLensStock() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (lensStock == null) {
      //TODO nullの場合、stockに10をストレージに追加2222
      lensStock = 10;
    } else {
      this.lensStock = prefs.getInt('stock') ?? 10;
    }
    notifyListeners();
  }

  void getWasherStock() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (washerStock == null) {
      //TODO nullの場合、washerに３をストレージに追加
      this.washerStock = 3;
    } else {
      this.washerStock = prefs.getInt('washer') ?? 3;
    }
    notifyListeners();
  }

  void decrementWasher() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (washerStock > 0) washerStock = (prefs.getInt('washer') ?? 0) - 1;
    await prefs.setInt('washer', washerStock);
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
    return scheduledDate;
  }

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }
}
