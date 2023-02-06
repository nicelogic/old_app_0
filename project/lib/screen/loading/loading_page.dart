import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: const Text('Niceice'),
            ),
            body: Flex(direction: Axis.vertical, children: [
              const Expanded(
                  child: SizedBox(
                    height: 10,
                  ),
                  flex: 1),
              Expanded(
                  child: Column(children: const [
                    SpinKitPouringHourGlassRefined(color: Colors.blue),
                    SizedBox(
                      height: 10,
                    ),
                    Text('加载中...')
                  ]),
                  flex: 2),
            ])));
  }
}
