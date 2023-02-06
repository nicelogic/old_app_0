import 'package:app/router/router/router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:ice_widget/ice_widget.dart';

class SettingsForm extends StatefulWidget {
  const SettingsForm({Key? key}) : super(key: key);

  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          context.router.push(const SettingsRoute());
        },
        child: const ItemCard(label: '设置', iconData: Icons.settings));
  }
}
