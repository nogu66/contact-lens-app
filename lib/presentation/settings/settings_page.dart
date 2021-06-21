import 'package:contact_lens_app/presentation/settings/settings_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SettingsModel>(
      create: (_) => SettingsModel()
        ..getCounter()
        ..getStock()
        ..getDate()
        ..getSlidingLimit()
        ..getPushTime(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('設定'),
          automaticallyImplyLeading: false,
          // leading: Consumer<SettingsModel>(
          //   builder: (context, model, child) {
          //     return IconButton(
          //       icon: Icon(Icons.arrow_back),
          //       onPressed: () async {
          //         Navigator.pop(context, true);
          //       },
          //     );
          //   },
          // ),
        ),
        body: Consumer<SettingsModel>(
          builder: (context, model, child) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: const Border(
                            bottom: const BorderSide(
                              color: Colors.grey,
                              width: 0.5,
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('開始日'),
                                  Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          model.selectDate(context);
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade300,
                                            // border:
                                            //     Border.all(color: Colors.grey),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Text(
                                            '${model.startYear}年${model.startMonth}月${model.startDay}日',
                                            style: TextStyle(fontSize: 15),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              // ElevatedButton(
                              //   child: Text('日付選択'),
                              //   onPressed: () {
                              //     model.selectDate(context);
                              //   },
                              // ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: const Border(
                            bottom: const BorderSide(
                              color: Colors.grey,
                              width: 0.5,
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('使用期限'),
                                  SizedBox(
                                    width: 220,
                                    child: CupertinoSlidingSegmentedControl(
                                      children: model.logoWidgets,
                                      groupValue: model.theirGroupValue,
                                      onValueChanged: (changeFormGroupValue) {
                                        model.slidingLimitControl(
                                          changeFormGroupValue,
                                        );
                                      },
                                    ),
                                  )
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        0, 16.0, 0, 16.0),
                                    child: ButtonBar(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            model.decrementCounter();
                                          },
                                          child: Container(
                                            width: 40,
                                            height: 30,
                                            decoration: ShapeDecoration(
                                              color: Colors.lightBlue,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(8.0)),
                                              ),
                                            ),
                                            child: Icon(
                                              Icons.remove,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 20,
                                          child: Text(
                                            '${model.counter}',
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            model.incrementCounter();
                                          },
                                          child: Container(
                                            width: 40,
                                            height: 30,
                                            decoration: ShapeDecoration(
                                              color: Colors.lightBlue,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(8.0),
                                                ),
                                              ),
                                            ),
                                            child: Icon(
                                              Icons.add,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: const Border(
                        bottom: const BorderSide(
                          color: Colors.grey,
                          width: 0.5,
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('在庫数'),
                              Column(
                                children: [
                                  ButtonBar(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          model.decrementStock();
                                        },
                                        child: Container(
                                          width: 40,
                                          height: 30,
                                          decoration: ShapeDecoration(
                                            color: Colors.lightBlue,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8.0)),
                                            ),
                                          ),
                                          child: Icon(
                                            Icons.remove,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 20,
                                        child: Text(
                                          '${model.stock}',
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          model.incrementStock();
                                        },
                                        child: Container(
                                          width: 40,
                                          height: 30,
                                          decoration: ShapeDecoration(
                                            color: Colors.lightBlue,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8.0)),
                                            ),
                                          ),
                                          child: Icon(
                                            Icons.add,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('通知機能'),
                              // Switch(
                              //   value: model.pushOn,
                              //   activeColor: Colors.green,
                              //   activeTrackColor: Colors.grey.shade300,
                              //   inactiveThumbColor: Colors.white,
                              //   inactiveTrackColor: Colors.grey,
                              //   onChanged: model.changeSwitch,
                              // ),
                              CupertinoSwitch(
                                value: model.pushOn,
                                onChanged: (value) {
                                  model.changeSwitch();
                                  // model.changeSwitch();
                                },
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 16.0, 0, 0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: () {
                                    showCupertinoModalPopup(
                                        context: context,
                                        builder: (_) => Container(
                                              height: 500,
                                              color: Color.fromARGB(
                                                  255, 255, 255, 255),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    height: 400,
                                                    child: CupertinoDatePicker(
                                                        initialDateTime:
                                                            model.pushTime,
                                                        onDateTimeChanged:
                                                            (DateTime value) {
                                                          model.chosenDateTime(
                                                              value);
                                                        }),
                                                  ),

                                                  // Close the modal
                                                  CupertinoButton(
                                                    child: Text('OK'),
                                                    onPressed: () =>
                                                        Navigator.of(context)
                                                            .pop(),
                                                  )
                                                ],
                                              ),
                                            ));
                                  },
                                  child: Text(
                                    // '${model.pushHour} : ${model.pushMinutes}',
                                    '${model.pushTimeText}',
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
