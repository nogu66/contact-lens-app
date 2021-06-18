import 'package:contact_lens_app/presentation/settings/settings_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SettingsModel>(
        create: (_) => SettingsModel()
          ..getCounter()
          ..getStock()
          ..getDate(),
        child: Scaffold(
          appBar: AppBar(
            title: Text('設定'),
            automaticallyImplyLeading: false,
            leading: Consumer<SettingsModel>(builder: (context, model, child) {
              return IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () async {
                  Navigator.pop(context, true);
                },
              );
            }),
          ),
          body: Consumer<SettingsModel>(
            builder: (context, model, child) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('開始日'),
                                Column(
                                  children: [
                                    Text(
                                      '${model.todayText}',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    ElevatedButton(
                                      child: Text('日付選択'),
                                      onPressed: () {
                                        model.selectDate(context);
                                      },
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('使用期限'),
                                    Text('${model.counter}'),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                      child: Icon(Icons.chevron_left),
                                      onPressed: () {
                                        model.decrementCounter();
                                      },
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          8.0, 0, 8.0, 0),
                                      child: SizedBox(
                                        height: 100,
                                      ),
                                    ),
                                    ElevatedButton(
                                      child: Icon(Icons.chevron_right),
                                      onPressed: () {
                                        model.incrementCounter();
                                      },
                                    ),
                                  ],
                                ),
                                ElevatedButton(
                                  child: Icon(Icons.refresh),
                                  onPressed: () {
                                    model.resetCounter();
                                  },
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
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    '${model.stock}',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  child: Icon(Icons.chevron_left),
                                  onPressed: () {
                                    model.decrementStock();
                                  },
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                                  child: SizedBox(
                                    height: 100,
                                  ),
                                ),
                                ElevatedButton(
                                  child: Icon(Icons.chevron_right),
                                  onPressed: () {
                                    model.incrementStock();
                                  },
                                ),
                              ],
                            ),
                            ElevatedButton(
                              onPressed: () {
                                model.resetStock();
                              },
                              child: Icon(Icons.refresh),
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
        ));
  }
}
