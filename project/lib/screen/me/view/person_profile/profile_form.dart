import 'package:flutter/material.dart';

class ProfileForm extends StatelessWidget {
  final String profileName;
  final Widget profileWidget;
  final VoidCallback? onTap;

  const ProfileForm(
      {Key? key,
      this.profileName = '',
      this.profileWidget = const Text(''),
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: Card(
            child: Container(
                padding: const EdgeInsets.fromLTRB(1, 20, 15, 20),
                child: Row(children: <Widget>[
                  const SizedBox(width: 20),
                  Text(profileName),
                  const SizedBox(width: 20),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[profileWidget])),
                  const SizedBox(width: 10),
                  const Icon(Icons.chevron_right)
                ]))));
  }
}
