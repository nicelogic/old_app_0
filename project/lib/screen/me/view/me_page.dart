import 'package:flutter/material.dart';
import 'package:ice_widget/ice_widget.dart';
import 'person_profile_form.dart';
import 'settings_form.dart';

class MePage extends StatefulWidget {
  const MePage({Key? key}) : super(key: key);

  @override
  _MePageState createState() => _MePageState();
}

class _MePageState extends State<MePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
                color: Colors.grey[200],
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: const <Widget>[
                      PersonProfileForm(),
                      heightBox1,
                      SettingsForm()
                    ]))));
  }
}
