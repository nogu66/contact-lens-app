import 'package:flutter/cupertino.dart';

class MainModel extends ChangeNotifier {
  int displayDays = 14;

  void decrementDays() {
    displayDays--;
    notifyListeners();
  }

  void incrementDays() {
    displayDays++;
    notifyListeners();
  }

  void resetDays() {
    displayDays = 14;
    notifyListeners();
  }
}
