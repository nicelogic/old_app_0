import 'package:app/feature/authentication/authentication.dart';
import 'package:app/router/router/router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:app/config/local_config.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(color: Colors.white),
          title: Text(Config.instance().settings),
        ),
        body: Column(children: [
          InkWell(
              onTap: () {
                context
                    .read<AuthenticationBloc>()
                    .add(AuthenticationLogoutRequested());
                context.router.popUntilRoot();
                context.router.replace(const LoginRoute());
              },
              child: Card(
                  child: Container(
                      padding: const EdgeInsets.fromLTRB(1, 20, 15, 20),
                      child: Row(children: <Widget>[
                        Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                              Text(Config.instance().quit)
                            ])),
                      ]))))
        ]));
  }
}
