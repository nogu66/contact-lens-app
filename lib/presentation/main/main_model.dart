import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainModel extends ChangeNotifier {
  int counter;
  DateTime today = DateTime.now();
  DateTime goalDays;
  String todayText;

  Future getCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.counter = prefs.getInt('counter') ?? 0;
    notifyListeners();
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

  void getDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateFormat outputFormat = DateFormat('yyyy年MM月dd日');
    today = DateTime.now();
    todayText = outputFormat.format(today);
    this.todayText = prefs.getString('todayText') ?? todayText;
    notifyListeners();
  }
}
