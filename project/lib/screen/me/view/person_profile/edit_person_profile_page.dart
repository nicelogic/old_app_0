import 'dart:developer';

import 'package:app/feature/account/account.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:account_repository/account_repository.dart';
import 'package:app/config/config.dart';
import 'package:ice_widget/ice_widget.dart';

class EditPersonProfilePage extends StatefulWidget {
  final String _inputLabel;
  final String _accountJsonKey;

  const EditPersonProfilePage(
      {Key? key, required String inputLabel, required String accountJsonKey})
      : _inputLabel = inputLabel,
        _accountJsonKey = accountJsonKey,
        super(key: key);

  @override
  _EditPersonProfilePageState createState() => _EditPersonProfilePageState();
}

class _EditPersonProfilePageState extends State<EditPersonProfilePage> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(color: Colors.white),
          title: Text(Config.instance().changeProfile),
          actions: [
            TextButton(
                onPressed: null, child: Text(Config.instance().save)),
            IconButton(
              icon: const Icon(Icons.save),
              color: Colors.white,
              onPressed: () async {
                final authenticationRepository =
                    context.read<AuthenticationRepository>();
                final accountBloc = context.read<AccountBloc>();
                final newValue = _controller.text;
                final newValueJson =
                    '{"${widget._accountJsonKey}": "$newValue"}';
                final id = await authenticationRepository.getId();
                try {
                  await accountBloc.updateAccount(
                      id: id, info: newValueJson);
                } on AccountFailure catch (e) {
                  if (e.errorCode == AccountErrorCode.UserUndefined) {
                    await accountBloc.createAccount(id);
                  }
                } catch (e) {
                  log(e.toString());
                }
                context.popRoute();
              },
            )
          ],
        ),
        body: Container(
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
            child: TextForm(
              inputLabel: widget._inputLabel,
              controller: _controller,
              validator: (name) =>
                  name != null && name.isNotEmpty ? name : null,
            )));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
