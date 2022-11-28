import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:new_version_plus/new_version_plus.dart';

class CustomNewVersionPlus extends NewVersionPlus {
  CustomNewVersionPlus({
    String? androidId,
    String? iOSId,
    String? iOSAppStoreCountry,
    String? forceAppVersion,
  }) : super(
            androidId: androidId,
            iOSId: iOSId,
            iOSAppStoreCountry: iOSAppStoreCountry,
            forceAppVersion: forceAppVersion);

  void _updateActionFunc({
    required String appStoreLink,
    required bool allowDismissal,
    required BuildContext context,
  }) {
    launchAppStore(appStoreLink);
    if (allowDismissal) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  @override
  void showUpdateDialog({
    required BuildContext context,
    required VersionStatus versionStatus,
    String dialogTitle = 'Update Available',
    String? dialogText,
    String updateButtonText = 'Update',
    bool allowDismissal = true,
    String dismissButtonText = 'Maybe Later',
    VoidCallback? dismissAction,
  }) async {
    final dialogTitleWidget = Text(
      dialogTitle,
      style: MyTextTheme.mainbold(context),
    );
    final dialogTextWidget = Text(
      dialogText ??
          'You can now update this app from ${versionStatus.localVersion} to ${versionStatus.storeVersion}',
      style: MyTextTheme.main(context),
    );

    final updateButtonTextWidget = Text(
      updateButtonText,
      style: MyTextTheme.mainbold(context).copyWith(color: AppColors.mainblue),
    );

    List<Widget> actions = [
      Platform.isAndroid
          ? TextButton(
              onPressed: () => _updateActionFunc(
                allowDismissal: allowDismissal,
                context: context,
                appStoreLink: versionStatus.appStoreLink,
              ),
              child: updateButtonTextWidget,
            )
          : CupertinoDialogAction(
              onPressed: () => _updateActionFunc(
                allowDismissal: allowDismissal,
                context: context,
                appStoreLink: versionStatus.appStoreLink,
              ),
              child: updateButtonTextWidget,
            ),
    ];

    if (allowDismissal) {
      final dismissButtonTextWidget = Text(dismissButtonText);
      dismissAction = dismissAction ??
          () => Navigator.of(context, rootNavigator: true).pop();
      actions.add(
        Platform.isAndroid
            ? TextButton(
                onPressed: dismissAction,
                child: dismissButtonTextWidget,
              )
            : CupertinoDialogAction(
                onPressed: dismissAction,
                child: dismissButtonTextWidget,
              ),
      );
    }

    await showDialog(
      context: context,
      barrierDismissible: allowDismissal,
      builder: (BuildContext context) {
        return WillPopScope(
            child: Platform.isAndroid
                ? AlertDialog(
                    title: dialogTitleWidget,
                    content: dialogTextWidget,
                    actions: actions,
                  )
                : CupertinoAlertDialog(
                    title: dialogTitleWidget,
                    content: dialogTextWidget,
                    actions: actions,
                  ),
            onWillPop: () => Future.value(allowDismissal));
      },
    );
  }
}

class UpdateController extends GetxController {
  static UpdateController get to => Get.find();
  bool isRequiredUpdate = false;
  final newVersionPlus = CustomNewVersionPlus(
    androidId: "com.loopus.loopus",
    iOSId: "com.loopus.loopusfrontend",
  );
  VersionStatus? status;

  Future checkRequiredUpdate() async {
    try {
      status = await newVersionPlus.getVersionStatus();
    } catch (e) {
      status = null;
    }
    if (status != null) {
      //ex) localVersion: 1.0.0 , storeVersion: 1.0.1  isRequiredUpdate = true
      if (int.parse(status!.localVersion.split(".")[0]) <
              int.parse(status!.storeVersion.split(".")[0]) ||
          int.parse(status!.localVersion.split(".")[1]) <
              int.parse(status!.storeVersion.split(".")[1]) ||
          int.parse(status!.localVersion.split(".")[2]) <
              int.parse(status!.storeVersion.split(".")[2])) {
        isRequiredUpdate = true;
      }
    }
  }
}
