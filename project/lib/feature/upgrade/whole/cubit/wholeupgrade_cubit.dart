import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bugly/flutter_bugly.dart';

part 'wholeupgrade_state.dart';

class WholeUpgradeCubit extends Cubit<WholeUpgradeState> {
  final String _buglyAppId;

  WholeUpgradeCubit({required final String buglyAppId})
      : _buglyAppId = buglyAppId,
        super(WholeUpgradeInitial());
  init() async {
    if (!kIsWeb) {
      await FlutterBugly.init(
        androidAppId: _buglyAppId,
        iOSAppId: "your app id",
        // autoDownloadOnWifi: true,
        customUpgrade: false, // 调用Android原生升级方式
      );

      FlutterBugly.onCheckUpgrade.listen((_upgradeInfo) {
        log('new app url: {${_upgradeInfo.apkUrl}}');
      });

      FlutterBugly.setUserId("user id");
      FlutterBugly.putUserData(key: "key", value: "value");
      int tag = 9527;
      FlutterBugly.setUserTag(tag);
    }
  }

  @override
  close() async {
    FlutterBugly.dispose();
    await super.close();
  }
}
