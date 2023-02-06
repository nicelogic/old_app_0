import 'package:flutter/material.dart';

class LabelCard extends StatelessWidget {
  final String _label;
  final Color? _color;

  const LabelCard({Key? key, required String label, Color? color})
      : _label = label,
        _color = color,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.grey[200],
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Card(
                  child: Container(
                      padding: const EdgeInsets.fromLTRB(1, 15, 20, 15),
                      child: Row(children: <Widget>[
                        const SizedBox(width: 20),
                        Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                              Text(_label,
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: _color ??
                                          Theme.of(context).primaryColorDark
                                      // fontWeight: FontWeight.w500
                                      ))
                            ])),
                      ])))
            ]));
  }
}
