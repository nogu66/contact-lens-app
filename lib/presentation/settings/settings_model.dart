import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class SettingsModel extends ChangeNotifier {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  int counter;
  int stock;
  DateTime today = DateTime.now();
  DateTime goalDays;
  String startYear;
  String startMonth;
  String startDay;
  String goalDay;
  int pushHour = 18;
  int pushMinutes = 40;
  bool isPressed = false;
  bool pushOn = true;
  final Map<int, Widget> logoWidgets = const <int, Widget>{
    0: Text("2Weeks"),
    1: Text("1Month"),
    2: Text("3Months")
  };
  int theirGroupValue = 0;
  DateTime pushTime;
  String pushTimeText;

  void pressedButton() {
    isPressed = !isPressed;
    notifyListeners();
  }

  void changeSwitch() {
    pushOn = !pushOn;
    print(pushOn);
    // if (pushOn) scheduleDailyTenAMNotification();
    notifyListeners();
  }

  Future selectDate(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: today,
      firstDate: new DateTime.now().add(new Duration(days: -365)),
      lastDate: new DateTime.now().add(new Duration(days: 365)),
    );

    if (picked != null) {
      today = picked;
    }
    formatDate(today);
    await prefs.setString('startYear', startYear);
    await prefs.setString('startMonth', startMonth);
    await prefs.setString('startDay', startDay);
    notifyListeners();
  }

  void getDate() async {
    if (startYear == null && startMonth == null && startDay == null)
      initializeDate();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    today = DateTime.now();
    this.startYear = prefs.getString('startYear') ?? startYear;
    this.startMonth = prefs.getString('startMonth') ?? startMonth;
    this.startDay = prefs.getString('startDay') ?? startDay;
    notifyListeners();
  }

  void initializeDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    today = DateTime.now();
    DateFormat outputFormatYear = DateFormat('yyyy');
    DateFormat outputFormatMonth = DateFormat('MM');
    DateFormat outputFormatDay = DateFormat('dd');
    startYear = outputFormatYear.format(today);
    startMonth = outputFormatMonth.format(today);
    startDay = outputFormatDay.format(today);
    await prefs.setString('startYear', startYear);
    await prefs.setString('startMonth', startMonth);
    await prefs.setString('startDay', startDay);
    this.startYear = prefs.getString('startYear') ?? startYear;
    this.startMonth = prefs.getString('startMonth') ?? startMonth;
    this.startDay = prefs.getString('startDay') ?? startDay;
  }

  void formatDate(DateTime day) async {
    DateFormat outputFormatYear = DateFormat('yyyy');
    DateFormat outputFormatMonth = DateFormat('MM');
    DateFormat outputFormatDay = DateFormat('dd');
    startYear = outputFormatYear.format(day);
    startMonth = outputFormatMonth.format(day);
    startDay = outputFormatDay.format(day);
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

  void incrementCounter() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    counter = (prefs.getInt('counter') ?? 0) + 1;
    await prefs.setInt('counter', counter);
    notifyListeners();
  }

  void decrementCounter() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (counter > 0) counter = (prefs.getInt('counter') ?? 0) - 1;
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

  void getCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.counter = prefs.getInt('counter') ?? 0;
    this.goalDays = DateTime.now();
    notifyListeners();
  }

  void incrementStock() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    stock = (prefs.getInt('stock') ?? 0) + 1;
    await prefs.setInt('stock', stock);
    notifyListeners();
  }

  void decrementStock() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (stock > 0) stock = (prefs.getInt('stock') ?? 0) - 1;
    await prefs.setInt('stock', stock);
    notifyListeners();
  }

  void getStock() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.stock = prefs.getInt('stock') ?? 0;
    notifyListeners();
  }

  void getPushTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.pushTimeText = prefs.getString('pushTimeText');
  }

  void chosenDateTime(DateTime value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateFormat outputFormatHm = DateFormat('Hm');
    pushTime = value;
    pushTimeText = outputFormatHm.format(value);
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
