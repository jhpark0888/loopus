import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/model/httpresponse_model.dart';

void errorSituation(HTTPResponse httpresponse, {Rx<ScreenState>? screenState}) {
  dialogBack();
  if (httpresponse.errorData!['statusCode'] == 59) {
    showdisconnectdialog();
    if (screenState != null) {
      print("ddd");
      screenState.value = ScreenState.disconnect;
    }
  } else if (httpresponse.errorData!['statusCode'] == 404) {
    Get.back();
    showCustomDialog('존재하지 않는 콘텐츠입니다', 1200);
    // if (screenState != null) {
    //   screenState.value = ScreenState.error;
    // }
  } else if (httpresponse.errorData!['statusCode'] == 500) {
    showErrorDialog(
        title: '현재 서버가 점검 중이에요',
        content: '나중에 다시 접속해주세요',
        leftFunction: () {
          Get.back();
          // print('asd');
          // if (Platform.isIOS) {
          //   exit(0);
          // } else if (Platform.isAndroid) {
          //   SystemNavigator.pop();
          // }
        });
    if (screenState != null) {
      screenState.value = ScreenState.error;
    }
  } else {
    showErrorDialog(
        title: '에러 발생',
        content: '에러 Code: ${httpresponse.errorData!['statusCode']}',
        leftFunction: () {
          Get.back();
        });
    if (screenState != null) {
      screenState.value = ScreenState.error;
    }
  }
}
