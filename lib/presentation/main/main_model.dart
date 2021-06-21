import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainModel extends ChangeNotifier {
  int counter;
  DateTime today = DateTime.now();
  String startYear;
  String startMonth;
  String startDay;

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

  void reload() async {
    notifyListeners();
  }

  void resetCounter() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('counter', 14);
    this.counter = prefs.getInt('counter') ?? 0;
    notifyListeners();
  }

  void incrementCounter() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    counter = (prefs.getInt('counter') ?? 0) + 1;

    await prefs.setInt('counter', counter);
    notifyListeners();
  }

  void getCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.counter = prefs.getInt('counter') ?? 0;
    // this.goalDays = DateTime.now();
    notifyListeners();
  }
}
