import 'dart:developer';

import 'package:flutter_test/flutter_test.dart';
import 'package:p2p_signaling_repository/p2p_signaling_repository.dart';

void main() {
  test('test signaling repositoy', () async {
    final signaling =
        P2pSignalingRepository(wsUrl: 'niceice.cn/rtc-signaling')
          ..connect();
    signaling.onSignalingStateChange = (SignalingState state) {
      switch (state) {
        case SignalingState.ConnectionClosed:
          log('signaling state close');
          break;
        case SignalingState.ConnectionError:
          log('signaling state error');
          break;
        case SignalingState.ConnectionOpen:
          log('signaling state open');
          break;
      }
    };

    while (true) {
      await Future.delayed(Duration(seconds: 10));
    }
  });
}
