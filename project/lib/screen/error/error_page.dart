import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  final String _error;

  const ErrorPage({Key? key, required final String error})
      : _error = error,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('error'),
      ),
      body: Center(
        child: Text(_error),
      ),
    ));
  }
}
