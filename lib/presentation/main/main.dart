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
      create: (_) => MainModel(),
      child: Scaffold(
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
        body: Consumer<MainModel>(builder: (context, model, child) {
          model.getDate();
          model.getCounter();
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  '${model.startYear}年${model.startMonth}月${model.startDay}日',
                ),
                Text('${model.counter}'),
                ElevatedButton(
                  onPressed: () async {
                    model.resetCounter();
                  },
                  child: Icon(Icons.refresh),
                ),
                ElevatedButton(
                  onPressed: () {
                    model.incrementCounter();
                  },
                  child: Icon(Icons.add),
                ),
              ],
            ),
          );
        }),
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
