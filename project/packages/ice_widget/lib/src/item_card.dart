
import 'package:flutter/material.dart';
import 'package:badges/badges.dart';

class ItemCard extends StatelessWidget {
  final String _label;
  final IconData? _iconData;
  final EdgeInsetsGeometry? _padding;
  final bool _isNeedChevronRight;
  final String? _badgeValue;

  const ItemCard(
      {Key? key,
      required String label,
      IconData? iconData,
      EdgeInsetsGeometry? padding,
      bool isNeedChevronRight = true,
      bool isLabelCenter = false,
      String? badgeValue})
      : _label = label,
        _padding = padding,
        _iconData = iconData,
        _badgeValue = badgeValue,
        _isNeedChevronRight = isNeedChevronRight,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.grey[200],
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Card(
                  child: Container(
                      padding: _padding ?? const EdgeInsets.fromLTRB(1, 20, 15, 20),
                      child: Row(children: <Widget>[
                        const SizedBox(width: 20),
                        if (_iconData != null)
                          Icon(
                            _iconData,
                          ),
                        const SizedBox(width: 20),
                        Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                              Text(_label,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    // fontWeight: FontWeight.w500
                                  ))
                            ])),
                        if (_badgeValue != null && _badgeValue != '0')
                          Badge(
                            elevation: 0,
                            shape: BadgeShape.circle,
                            padding: const EdgeInsets.all(7),
                            badgeContent: Text(
                              _badgeValue!,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        if (_isNeedChevronRight) const Icon(Icons.chevron_right)
                      ])))
            ]));
  }
}
