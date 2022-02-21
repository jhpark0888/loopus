import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:ios_utsname_ext/extension.dart';

import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

class UserDeviceInfo extends GetxController {
  static UserDeviceInfo get to => Get.find();
  DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  RxMap<String, dynamic> deviceData = <String, dynamic>{}.obs;
  RxMap<String, dynamic> appInfoData = <String, dynamic>{}.obs;

  Future<Map<String, dynamic>> _getAppInfo() async {
    try {
      PackageInfo info = await PackageInfo.fromPlatform();
      appInfoData.value = {"ver": info.version + ' + ' + info.buildNumber};
    } catch (error) {
      appInfoData.value = {"Error": "Failed to get app version."};
    }

    return appInfoData.value;
  }

  Future<Map<String, dynamic>> _getDeviceInfo() async {
    try {
      if (Platform.isAndroid) {
        deviceData.value =
            _readAndroidDeviceInfo(await deviceInfoPlugin.androidInfo);
      } else if (Platform.isIOS) {
        deviceData.value = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      }
    } catch (error) {
      deviceData.value = {"Error": "Failed to get platform version."};
    }

    return deviceData.value;
  }

  Map<String, dynamic> _readAndroidDeviceInfo(AndroidDeviceInfo info) {
    var release = info.version.release;
    var sdkInt = info.version.sdkInt;
    var manufacturer = info.manufacturer;
    var model = info.model;

    return {
      "OS 버전": "Android $release (SDK $sdkInt)",
      "기기": "$manufacturer $model"
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo info) {
    var systemName = info.systemName;
    var version = info.systemVersion;
    var machine = info.utsname.machine?.iOSProductName;

    return {"OS 버전": "$systemName $version", "기기": "$machine"};
  }

  @override
  void onInit() async {
    await _getDeviceInfo();
    await _getAppInfo();
    super.onInit();
  }
}






// 실행 코드
// Map<String, dynamic> deviceInfo = await _getDeviceInfo();
// print(deviceInfo);