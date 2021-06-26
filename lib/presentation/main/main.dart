import 'dart:io';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:contact_lens_app/presentation/gage/circle_painter.dart';
import 'package:contact_lens_app/presentation/settings/settings_page.dart';
import 'package:contact_lens_app/services/admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'main_model.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Admob.initialize();
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
  final size = 200.0;
  final percentage = 0.7;
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 60.0, 0, 40.0),
                        child: Container(
                          child: CustomPaint(
                            // painter: CirclePaint(),
                            painter: CircleLevelPainter(
                              percentage: model.percentage,
                              textCircleRadius: size * 0.5,
                            ),
                            child: Container(
                              padding: EdgeInsets.all(8.0),
                              child: Material(
                                borderRadius: BorderRadius.circular(size * 0.5),
                                child: Container(
                                  width: size,
                                  height: size,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('${model.startDateText}'),
                                      Text('~'),
                                      Text('${model.goalDateText}'),
                                      Text('残り${model.counter}日'),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Text('${model.startDateText}〜${model.goalDateText}'),
                      // Text('残り${model.counter}日'),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text('レンズ：残り${model.lensStock}個'),
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
                                            onPressed: () =>
                                                Navigator.pop(context),
                                          ),
                                          CupertinoDialogAction(
                                            child: Text('OK'),
                                            onPressed: () async {
                                              model.resetCounter();
                                              Navigator.pop(context);
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
                      ),

                      Column(
                        children: [
                          Text('洗浄液：残り${model.washerStock}個'),
                          ElevatedButton(
                            onPressed: () async {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return CupertinoAlertDialog(
                                      title: Text("洗浄液交換通知"),
                                      content: Text('洗浄液を交換しますか？'),
                                      actions: <Widget>[
                                        CupertinoDialogAction(
                                          child: Text('キャンセル'),
                                          isDefaultAction: true,
                                          onPressed: () =>
                                              Navigator.pop(context),
                                        ),
                                        CupertinoDialogAction(
                                          child: Text('OK'),
                                          onPressed: () async {
                                            model.decrementWasher();
                                            Navigator.pop(context);
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
                    ],
                  ),
                );
              },
            ),
            bottomNavigationBar: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                AdmobBanner(
                  adUnitId: AdMobService().getBannerAdUnitId(),
                  adSize: AdmobBannerSize(
                    width: MediaQuery.of(context).size.width.toInt(),
                    height: AdMobService().getHeight(context).toInt(),
                    name: 'SMART_BANNER',
                  ),
                ),
              ],
            ),
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
