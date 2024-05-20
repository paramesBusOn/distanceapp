// mobile_network_info.dart
import 'package:flutter/services.dart';

class MobileNetworkInfo {
  static const platform = MethodChannel('your_channel_name');

  Future<String?> getMobileNetworkName() async {
    try {
      return await platform.invokeMethod('getMobileNetworkName');
    } on PlatformException catch (e) {
      print("Failed to get mobile network name: ${e.message}");
      return null;
    }
  }
  Future<String?> GetIncommingCallNumber() async {
    try {
      return await platform.invokeMethod('getMobileIncommingcall');
    } on PlatformException catch (e) {
      print("Failed to get mobile getMobileIncommingcall: ${e.message}");
      return null;
    }
  }
}
