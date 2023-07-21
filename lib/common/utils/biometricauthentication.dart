// ignore_for_file: unused_field, avoid_print

import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class Biometric {
  final LocalAuthentication _auth = LocalAuthentication();
  bool _isAuthenticating = false;
  String _authorized = 'Not Authorized';

  // 检查设备是否支持生物识别
  Future<bool> isDeviceSupported() async {
    bool isSupported;
    try {
      isSupported = await _auth.isDeviceSupported();
    } on PlatformException catch (e) {
      isSupported = false;
      print(e);
    }
    return isSupported;
  }

  // 获取可用的生物识别技术
  Future<String> getAvailableBiometrics() async {
    late List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await _auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      availableBiometrics = <BiometricType>[];
      print(e);
    }
    print('支持的生物验证$availableBiometrics');
    return availableBiometrics[0].toString().split('.').last;
  }

  // 进行身份验证（指纹或面部）
  Future<bool> authenticate() async {
    bool authenticated = false;
    try {
      _isAuthenticating = true;
      _authorized = 'Authenticating';
      authenticated = await _auth.authenticate(
        localizedReason: '请输入密码',
      );
      _isAuthenticating = false;
    } on PlatformException catch (e) {
      print(e);
      _isAuthenticating = false;
      _authorized = 'Error - ${e.message}';
      return false;
    }

    _authorized = authenticated ? 'Authorized' : 'Not Authorized';
    print(_authorized);
    return authenticated;
  }

  // 取消认证
  Future<void> cancelAuthentication() async {
    await _auth.stopAuthentication();
    _isAuthenticating = false;
  }

  // 获取认证结果
  String get authorized => _authorized;
}
