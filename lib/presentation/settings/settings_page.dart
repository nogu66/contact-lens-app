import 'package:contact_lens_app/presentation/settings/settings_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SettingsModel>(
      create: (_) => SettingsModel()
        ..getCounter()
        ..getSlidingLimit()
        ..getNotifications()
        ..getStartDate()
        ..getLensStock()
        ..getWasherStock(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('設定'),
          automaticallyImplyLeading: false,
          leading: Consumer<SettingsModel>(
            builder: (context, model, child) {
              return IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () async {
                  Navigator.pop(context, true);
                },
              );
            },
          ),
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
                                            '${model.startDateText}',
                                            style: TextStyle(fontSize: 15),
                                          ),
                                        ),
                                        onTap: () async {
                                          Picker(
                                                  adapter:
                                                      DateTimePickerAdapter(
                                                    type:
                                                        PickerDateTimeType.kYMD,
                                                    value: model.startDate,
                                                    // customColumnType: [3, 4],
                                                    isNumberMonth: true,
                                                    yearSuffix: "年",
                                                    monthSuffix: "月",
                                                    daySuffix: "日",
                                                    // minValue: DateTime.now();
                                                    minValue: DateTime.now()
                                                        .add(new Duration(
                                                            days: -365)),
                                                    // minuteInterval: 30,
                                                    minHour: 1,
                                                    maxHour: 23,
                                                  ),
                                                  title: Text('Select Time'),
                                                  onConfirm: (Picker picker,
                                                      List value) {
                                                    model.setStartDay(
                                                        picker,
                                                        (picker.adapter
                                                                as DateTimePickerAdapter)
                                                            .value);
                                                  },
                                                  onSelect: (Picker picker,
                                                      int index,
                                                      List<int> selected) {
                                                    // print(picker.adapter);
                                                  })
                                              .showModal(context);
                                        },
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
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      SizedBox(
                                        width: 220,
                                        child: CupertinoSlidingSegmentedControl(
                                          children: model.logoWidgets,
                                          groupValue: model.theirGroupValue,
                                          onValueChanged:
                                              (changeFormGroupValue) {
                                            model.slidingLimitControl(
                                              changeFormGroupValue,
                                            );
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 16.0, 0, 0),
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
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                8.0)),
                                                  ),
                                                ),
                                                child: Icon(
                                                  Icons.remove,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 50,
                                              child: InkWell(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      decoration:
                                                          ShapeDecoration(
                                                        color: Colors
                                                            .grey.shade300,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5.0)),
                                                        ),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                12.0,
                                                                8.0,
                                                                12.0,
                                                                8.0),
                                                        child: Text(
                                                          '${model.counter}',
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                onTap: () {
                                                  Picker(
                                                      adapter:
                                                          NumberPickerAdapter(
                                                              data: [
                                                            NumberPickerColumn(
                                                              begin: 1,
                                                              end: 100,
                                                            ),
                                                          ]),
                                                      delimiter: [
                                                        PickerDelimiter(
                                                            child: Container(
                                                          width: 30,
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text('日'),
                                                        ))
                                                      ],
                                                      hideHeader: true,
                                                      selectedTextStyle:
                                                          TextStyle(
                                                              color:
                                                                  Colors.blue),
                                                      onConfirm: (Picker picker,
                                                          List value) {
                                                        // print(value);
                                                        model
                                                            .pickCounter(value);
                                                      }).showDialog(context);
                                                },
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
                                                    borderRadius:
                                                        BorderRadius.all(
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
                              Text('残レンズ数'),
                              Column(
                                children: [
                                  ButtonBar(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          model.decrementStock();
                                        },
                                        child: Container(
                                          width: 42,
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
                                        width: 50,
                                        child: InkWell(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                decoration: ShapeDecoration(
                                                  color: Colors.grey.shade300,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                5.0)),
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          12.0, 8.0, 12.0, 8.0),
                                                  child: Text(
                                                    '${model.lensStock}',
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          onTap: () {
                                            Picker(
                                                adapter:
                                                    NumberPickerAdapter(data: [
                                                  NumberPickerColumn(
                                                    begin: 0,
                                                    end: 100,
                                                  ),
                                                ]),
                                                delimiter: [
                                                  PickerDelimiter(
                                                      child: Container(
                                                    width: 30,
                                                    alignment: Alignment.center,
                                                    child: Text('個'),
                                                  ))
                                                ],
                                                hideHeader: true,
                                                selectedTextStyle: TextStyle(
                                                    color: Colors.blue),
                                                onConfirm: (Picker picker,
                                                    List value) {
                                                  // print(value);
                                                  model.pickStock(value);
                                                }).showDialog(context);
                                          },
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          model.incrementStock(1);
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
                                  ButtonBar(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          model.incrementStock(5);
                                        },
                                        child: Container(
                                          width: 70,
                                          height: 30,
                                          decoration: ShapeDecoration(
                                            color: Colors.lightBlue,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(8.0),
                                              ),
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              '＋5',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          model.incrementStock(10);
                                        },
                                        child: Container(
                                          width: 70,
                                          height: 30,
                                          decoration: ShapeDecoration(
                                            color: Colors.lightBlue,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(8.0),
                                              ),
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              '＋10',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
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
                              Text('洗浄液'),
                              Column(
                                children: [
                                  ButtonBar(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          model.decrementWasher();
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
                                        width: 50,
                                        child: InkWell(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                decoration: ShapeDecoration(
                                                  color: Colors.grey.shade300,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                5.0)),
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          12.0, 8.0, 12.0, 8.0),
                                                  child: Text(
                                                    '${model.washerStock}',
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          onTap: () {
                                            Picker(
                                                adapter:
                                                    NumberPickerAdapter(data: [
                                                  NumberPickerColumn(
                                                    begin: 0,
                                                    end: 100,
                                                  ),
                                                ]),
                                                delimiter: [
                                                  PickerDelimiter(
                                                      child: Container(
                                                    width: 30,
                                                    alignment: Alignment.center,
                                                    child: Text('個'),
                                                  ))
                                                ],
                                                hideHeader: true,
                                                selectedTextStyle: TextStyle(
                                                    color: Colors.blue),
                                                onConfirm: (Picker picker,
                                                    List value) {
                                                  // print(value);
                                                  model.pickWasher(value);
                                                }).showDialog(context);
                                          },
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          model.incrementWasher(1);
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
                                  ButtonBar(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          model.incrementWasher(5);
                                        },
                                        child: Container(
                                          width: 70,
                                          height: 30,
                                          decoration: ShapeDecoration(
                                            color: Colors.lightBlue,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(8.0),
                                              ),
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              '＋5',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          model.incrementWasher(10);
                                        },
                                        child: Container(
                                          width: 70,
                                          height: 30,
                                          decoration: ShapeDecoration(
                                            color: Colors.lightBlue,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(8.0),
                                              ),
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              '＋10',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
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
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 8.0, 0, 8.0),
                                child: CupertinoSwitch(
                                  value: model.pushOn,
                                  onChanged: (value) {
                                    model.changeSwitch();
                                  },
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 16.0, 0, 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('通知日'),
                                SizedBox(
                                  width: 150,
                                  child: CupertinoSlidingSegmentedControl(
                                    children: model.pushDateSet,
                                    groupValue: model.pushDateValue,
                                    onValueChanged: (changeFormGroupValue) {
                                      model.slidingPushDateControl(
                                        changeFormGroupValue,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('通知時間'),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      child: Text(
                                        // '${model.pushHour} : ${model.pushMinutes}',
                                        '${model.pushTimeText}',
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                      onTap: () async {
                                        Picker(
                                          adapter: DateTimePickerAdapter(
                                              type: PickerDateTimeType.kHM,
                                              value: model.pushTime,
                                              customColumnType: [3, 4]),
                                          title: Text('Select Time'),
                                          onConfirm:
                                              (Picker picker, List value) {
                                            model.setPushTime(picker, value);
                                          },
                                        ).showModal(context);
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
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
