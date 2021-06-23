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
  int counter;
  int lensStock;
  int washerStock;
  int difference;
  DateTime today = DateTime.now();
  // String startYear;
  // String startMonth;
  // String startDay;
  DateTime startDate;
  String startDateText;
  DateTime goalDate;
  String goalDateText;
  bool isPressed = false;
  bool pushOn = false;
  final Map<int, Widget> logoWidgets = const <int, Widget>{
    0: Text("2Weeks"),
    1: Text("1Month"),
    2: Text("3Months")
  };
  int theirGroupValue = 0;
  DateTime pushTime;
  String pushTimeText = '18:00';
  DateFormat outputFormatYMD = DateFormat('y年MM月dd日');

  void differenceDate() async {
    final difference = goalDate.difference(startDate).inDays;
    print(difference);
    print(startDate);
    print(goalDate);
  }

  void pressedButton() {
    isPressed = !isPressed;
    notifyListeners();
  }

  void initialize() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateFormat outputFormatYMD = DateFormat('y年MM月dd日');
    this.startDate = today;
    this.goalDate = startDate.add(new Duration(days: 13));
    this.startDateText = outputFormatYMD.format(startDate);
    this.goalDateText = outputFormatYMD.format(goalDate);
    // difference = goalDate.difference(startDate).inDays + 1;
    await prefs.setString('startDate', startDateText);
    await prefs.setString('goalDate', goalDateText);
    // await prefs.setInt('counter', difference);
  }

  void getStartDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (startDate == null) {
      initialize();
    }
    this.startDateText = prefs.getString('startDate');
    notifyListeners();
  }

  void changeSwitch() {
    pushOn = !pushOn;
    print(pushOn);
    // if (pushOn) scheduleDailyTenAMNotification();
    notifyListeners();
  }

  void setStartDay(Picker picker, DateTime value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateFormat outputFormatYMD = DateFormat('y年MM月dd日');
    startDate = value;
    startDateText = outputFormatYMD.format(startDate);
    this.goalDate = startDate.add(new Duration(days: counter));
    startDateText = outputFormatYMD.format(startDate);
    goalDateText = outputFormatYMD.format(goalDate);
    await prefs.setString('startDate', startDateText);
    await prefs.setString('goalDate', goalDateText);
    this.startDateText = prefs.getString('startDate');
    // this.goalDateText = prefs.getString('goalDate');
    notifyListeners();
  }

  void getSlidingLimit() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    this.theirGroupValue = prefs.getInt('limit') ?? 0;
  }

  void slidingLimitControl(changeFormGroupValue) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    this.theirGroupValue = changeFormGroupValue;
    // print(theirGroupValue);
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
    notifyListeners();
  }

  void setLimitCounter(counterValue) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    counter = counterValue;
    await prefs.setInt('counter', counter);
    notifyListeners();
  }

  void getCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (counter == 0) {
      counter = 14;
      print('なはなは');
      await prefs.setInt('counter', counter);
      this.counter = prefs.getInt('counter') ?? 14;
    } else {
      this.counter = prefs.getInt('counter') ?? 14;
    }
    notifyListeners();
  }

  void incrementCounter() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    counter = (prefs.getInt('counter') ?? 0) + 1;
    this.goalDate = startDate.add(new Duration(days: counter));
    this.goalDateText = outputFormatYMD.format(goalDate);
    await prefs.setInt('counter', counter);
    await prefs.setString('goalDate', goalDateText);
    notifyListeners();
  }

  void decrementCounter() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (counter > 1) counter = (prefs.getInt('counter') ?? 0) - 1;
    this.goalDate = startDate.add(new Duration(days: counter));
    this.goalDateText = outputFormatYMD.format(goalDate);
    await prefs.setString('goalDate', goalDateText);
    await prefs.setInt('counter', counter);
    notifyListeners();
  }

  // Future<int> getPrefCount() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return (prefs.getInt('counter') ?? 0);
  // }

  void resetCounter() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('counter', 14);
    this.counter = prefs.getInt('counter') ?? 0;
    notifyListeners();
  }

  void incrementStock() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    lensStock = (prefs.getInt('stock') ?? 0) + 1;
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
    if (lensStock == null) {
      lensStock = 10;
    } else {
      this.lensStock = prefs.getInt('stock') ?? 10;
    }
    notifyListeners();
  }

  void incrementWasher() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    washerStock = (prefs.getInt('washer') ?? 0) + 1;
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
    if (lensStock == null) {
      this.washerStock = 3;
    } else {
      this.washerStock = prefs.getInt('washer') ?? 3;
    }
    notifyListeners();
  }

  void getPushTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.pushTimeText = prefs.getString('pushTimeText') ?? pushTimeText;
  }

  void setPushTime(Picker picker, List value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateFormat outputFormatHm = DateFormat('Hm');
    pushTime = DateTime.utc(0, 0, 0, value[0], value[1], 0);
    pushTimeText = outputFormatHm.format(pushTime);
    await prefs.setString('pushTimeText', pushTimeText);
    this.pushTimeText = prefs.getString('pushTimeText');
    notifyListeners();
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

  void scheduleDailyTenAMNotification() async {
    await _configureLocalTimeZone();
    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'daily scheduled notification title',
        'daily scheduled notification body',
        _nextInstanceOfTenAM(),
        const NotificationDetails(
          android: AndroidNotificationDetails(
              'daily notification channel id',
              'daily notification channel name',
              'daily notification description'),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time);
  }

  tz.TZDateTime _nextInstanceOfTenAM() {
    // final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    // year, month, day, hour, minutes, second
    //TODO 指定した日時に設定する
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, 22, 58);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }
}
