
import 'package:flutter/material.dart';
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageStatus createState() => _HomePageStatus();
}

class _HomePageStatus extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
        "主页",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    ));
  }
}
