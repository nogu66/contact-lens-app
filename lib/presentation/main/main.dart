import 'dart:io';

import 'package:contact_lens_app/presentation/settings/settings_page.dart';
import 'package:flutter/cupertino.dart';
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
                model.getNotifications();
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('${model.startDateText}〜${model.goalDateText}'),
                      Text('残り${model.counter}日'),
                      Text('レンズ：残り${model.lensStock}個'),
                      Text('洗浄液：残り${model.washerStock}個'),
                      ElevatedButton(
                        onPressed: () async {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return CupertinoAlertDialog(
                                  title: Text("レンズの交換確認"),
                                  content: Text('レンズを交換しますか？'),
                                  actions: <Widget>[
                                    CupertinoDialogAction(
                                      child: Text('キャンセル'),
                                      isDefaultAction: true,
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                    CupertinoDialogAction(
                                      child: Text('OK'),
                                      onPressed: () async {
                                        model.resetCounter();
                                        await Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                );
                              });
                        },
                        child: Text('レンズを交換する'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Consumer<MainModel>(
            builder: (context, model, child) {
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
