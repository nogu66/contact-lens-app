import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsModel extends ChangeNotifier {
  int counter;
  int stock;
  DateTime today = DateTime.now();
  DateTime goalDays;
  String todayText;

  Future<Null> selectDate(BuildContext context) async {
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
    DateFormat outputFormat = DateFormat('yyyy年MM月dd日');
    todayText = outputFormat.format(today);
    await prefs.setString('todayText', todayText);
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

  void incrementCounter() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    counter = (prefs.getInt('counter') ?? 0) + 1;
    await prefs.setInt('counter', counter);

    notifyListeners();
  }

  void decrementCounter() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (counter >= 1) {
      counter = (prefs.getInt('counter') ?? 0) - 1;
    }
    await prefs.setInt('counter', counter);
    if (counter == 0) {
      decrementStock();
    }
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
    stock = (prefs.getInt('stock') ?? 0) - 1;
    await prefs.setInt('stock', stock);
    notifyListeners();
  }

  void resetStock() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('stock', 10);
    this.stock = prefs.getInt('stock') ?? 0;
    notifyListeners();
  }

  void getStock() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.stock = prefs.getInt('stock') ?? 0;
    notifyListeners();
  }
}
