import 'package:app/gen/assets.gen.dart';
import 'package:yaml/yaml.dart';
import 'package:flutter/services.dart' as services;

class Config {
  Config._();
  late final YamlMap _configMap;
  static final _instance = Config._();
  factory Config.instance() => _instance;

  loadConfigs() async {
    final configYamlPath = Assets.configs.config.toString();
    final configs = await services.rootBundle.loadString(configYamlPath);
    _configMap = loadYaml(configs);
  }

  dynamic _appSection(final String name, {dynamic defaultVal = 'null'}) =>
      _configMap['app'][name] ?? defaultVal;
  String get serverUrl => _appSection('serverUrl');
  String get httpServerUrl => _appSection('httpServerUrl');
  String get accountServiceUrl => _appSection('accountServiceUrl');
  String get authenticationServiceUrl =>
      _appSection('authenticationServiceUrl');
  String get pubsubServiceUrl => _appSection('pubsubServiceUrl');
  String get pubsubServiceSubscriptionUrl =>
      _appSection('pubsubServiceSubscriptionUrl');
  String get messageServiceUrl => _appSection('messageServiceUrl');
  String get messageServiceSubscriptionUrl =>
      _appSection('messageServiceSubscriptionUrl');
  String get rtcSignalingServiceUrl => _appSection('rtcSignalingServiceUrl');
  double get horizontalPadding =>
      _appSection('horizontalPadding', defaultVal: 24.0);
  double get desktopLeastWidth =>
      _appSection('desktopLeastWidth', defaultVal: 360);
  int get failTimesToShowDisconnect =>
      _appSection('failTimesToShowDisconnect', defaultVal: 3);
  String get objectStorageAccessKey => _appSection('objectStorageAccessKey');
  String get objectStorageSecretKey => _appSection('objectStorageSecretKey');
  int get objectStoragePort =>
      _appSection('objectStoragePort', defaultVal: 9000);
  String get objectStorageUserAvatar => _appSection('objectStorageUserAvatar');
  String objectStorageUserAvatarUrl(String userId) {
    userId = userId.isEmpty ? 'ice' : userId;
    return 'https://niceice.cn:9000/user/$userId/avatar.png';
  }

  String get buglyAppId => _appSection('buglyAppId');
  String get lastVersionApkUrl => _appSection('lastVersionApkUrl');

  dynamic _nameSection(final String name, {dynamic defaultVal = 'null'}) =>
      _configMap['name'][name] ?? defaultVal;
  String get appName => _nameSection('appName');
  String get chatNavigation => _nameSection('chatNavigation');
  String get contactNavigation => _nameSection('contactNavigation');
  String get meNavigation => _nameSection('meNavigation');
  String get avatar => _nameSection('avatar');
  String get userName => _nameSection('userName');
  String get email => _nameSection('email');
  String get emailAuthCode => _nameSection('emailAuthCode');
  String get register => _nameSection('register');
  String get login => _nameSection('login');
  String get useWechatLogin => _nameSection('useWechatLogin');
  String get useFaceReconitionLogin => _nameSection('useFaceReconitionLogin');
  String get id => _nameSection('id');
  String get personProfile => _nameSection('personProfile');
  String get changeProfile => _nameSection('changeProfile');
  String get signature => _nameSection('signature');
  String get save => _nameSection('save');
  String get pleaseInputNewName => _nameSection('pleaseInputNewName');
  String get pleaseInputNewSignature => _nameSection('pleaseInputNewSignature');
  String get settings => _nameSection('settings');
  String get quit => _nameSection('quit');

  dynamic _promptSection(final String name, dynamic defaultVal) =>
      _configMap['prompt'][name] ?? defaultVal;
  String get tryReconnectPrompt => _promptSection('tryReconnect', 'null');
  String get authenticationFailedPromt =>
      _promptSection('authenticationFailed', 'null');
  String get authenticationSuccessPromt =>
      _promptSection('authenticationSuccess', 'null');
  String get authenticating => _promptSection('authenticating', 'null');
  String get getAccountFailed => _promptSection('getAccountFailed', 'null');
  String get canNotChange => _promptSection('canNotChange', 'null');
  String get idCanNotChange => _promptSection('idCanNotChange', 'null');

  dynamic _pathSection(final String name, dynamic defaultVal) =>
      _configMap['path'][name] ?? defaultVal;
  String get logoPath => _pathSection('logo', 'null');

  dynamic _limitSection(final String name, dynamic defaultVal) =>
      _configMap['limit'][name] ?? defaultVal;
  int get maxNameBytes => _limitSection('maxNameBytes', 20);
}
