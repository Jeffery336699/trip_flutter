import 'package:flutter/material.dart';
import 'package:trip_flutter/util/screen_adapter_helper.dart';
import 'package:trip_flutter/util/view_util.dart';

class ScreenFixPage extends StatefulWidget {
  const ScreenFixPage({Key? key}) : super(key: key);

  @override
  State<ScreenFixPage> createState() => _ScreenFixPageState();
}

class _ScreenFixPageState extends State<ScreenFixPage> {
  @override
  Widget build(BuildContext context) {
    ScreenHelper.init(context);
    return MaterialApp(
        title: 'Flutter之旅',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          appBar: AppBar(),
          body: Column(
            children: [
              Center(
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: const BoxDecoration(color: Colors.blue),
                  child: const Text('默认大小'),
                ),
              ),
              hiSpace(height: 50),
              Center(
                  child: Container(
                width: 200.0.px,
                height: 200.px,
                decoration: const BoxDecoration(color: Colors.amber),
                child: const Text('适配后大小'),
              ))
            ],
          ),
        ));
  }
}
