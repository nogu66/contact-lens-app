import 'dart:io';

import 'package:contact_lens_app/presentation/settings/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'main_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // primaryColor: Colors.grey.shade300,
        primaryColor: Colors.grey.shade300,
        buttonColor: Colors.grey.shade300,
      ),
      home: TopPage(),
    );
  }
}

class TopPage extends StatelessWidget {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      _requestIOSPermission();
      _initializePlatformSpecifics();
    }

    return ChangeNotifierProvider<MainModel>(
      create: (_) => MainModel()..initializeDate(),
      // ..startLoading(),
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              title: Text('コンタクトレンズ管理'),
              actions: [
                IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SettingsPage(),
                        // fullscreenDialog: true,
                      ),
                    );
                    // await Navigator.pop(context);
                  },
                )
              ],
              automaticallyImplyLeading: false,
            ),
            body: Consumer<MainModel>(
              builder: (context, model, child) {
                // model.getDate();
                model.getStartDate();
                model.getCounter();
                model.getLensStock();
                model.getWasherStock();
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // Text(
                      //   '${model.startYear}年${model.startMonth}月${model.startDay}日',
                      // ),
                      // Text('${model.startDateText}'),
                      // Text('${model.goalDateText}'),
                      // Text('${model.counter}'),
                      // Text('${model.lensStock}'),
                      // Text('${model.washerStock}'),
                      Text('開始日${model.startDateText}'),
                      Text('終了日${model.goalDateText}'),
                      Text('期間${model.counter}'),
                      Text('レンズの残り${model.lensStock}'),
                      Text('洗浄液の残り${model.washerStock}'),
                      ElevatedButton(
                        onPressed: () async {
                          model.resetCounter();
                        },
                        child: Icon(Icons.refresh),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Consumer<MainModel>(
            builder: (context, model, chilsd) {
              return model.isLoading
                  ? Container(
                      color: Colors.black.withOpacity(0.3),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : SizedBox();
            },
          ),
        ],
      ),
    );
  }

  void _requestIOSPermission() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        .requestPermissions(
          alert: false,
          badge: true,
          sound: false,
        );
  }

  void _initializePlatformSpecifics() {
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
