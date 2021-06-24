import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainModel extends ChangeNotifier {
  int counter;
  int lensStock;
  int washerStock;
  DateTime today = DateTime.now();
  String startYear;
  String startMonth;
  String startDay;
  DateTime startDate;
  DateTime goalDate;
  String startDateText;
  String goalDateText;
  DateFormat outputFormatYMD = DateFormat('y年MM月dd日');
  bool isLoading = false;

  void startLoading() {
    this.isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    this.isLoading = false;
    notifyListeners();
  }

  void getStartDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (startDateText == null) initializeDate();
    this.startDateText = prefs.getString('startDate');
    this.goalDateText = prefs.getString('goalDate');
    notifyListeners();
  }

  void initializeDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateFormat outputFormatYMD = DateFormat('y年MM月dd日');
    startDate = today;
    goalDate = startDate.add(Duration(days: 13));
    // print(goalDate);
    this.startDateText = outputFormatYMD.format(startDate);
    this.goalDateText = outputFormatYMD.format(goalDate);
/*    print(goalDateText);*/
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
    notifyListeners();
  }

  void initializeStartDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    today = DateTime.now();
    DateFormat outputFormatYMD = DateFormat('y年MM月dd日');
    startDateText = outputFormatYMD.format(today);
    await prefs.setString('startDate', startDateText);
    // this.startDateText = prefs.getString('startDate') ?? startDateText;
  }

  void initializeGoalDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    goalDate = today.add(new Duration(days: 13));
    DateFormat outputFormatYMD = DateFormat('y年MM月dd日');
    this.goalDateText = outputFormatYMD.format(goalDate);
    await prefs.setString('goalDate', goalDateText);
    // this.startDateText = prefs.getString('goalDate') ?? goalDateText;
  }

  void reload() async {
    notifyListeners();
  }

  void getCounter() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    this.counter = prefs.getInt('counter') ?? 14;

    notifyListeners();
  }

  void resetCounter() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('counter', 14);
    this.counter = prefs.getInt('counter') ?? 0;
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
}
