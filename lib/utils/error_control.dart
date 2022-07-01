import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/model/httpresponse_model.dart';

void errorSituation(HTTPResponse httpresponse, {ScreenState? screenState}) {
  if (httpresponse.errorData!['statusCode'] == 59) {
    if (!Get.isDialogOpen!) {
      showdisconnectdialog();
    }
    if (screenState != null) {
      screenState = ScreenState.disconnect;
    }
  } else if (httpresponse.errorData!['statusCode'] == 404) {
    Get.back();
    if (!Get.isDialogOpen!) {
      showCustomDialog('존재하지 않는 콘텐츠입니다', 1200);
    }
    if (screenState != null) {
      screenState = ScreenState.error;
    }
  } else if (httpresponse.errorData!['statusCode'] == 500) {
    if (!Get.isDialogOpen!) {
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
    }
    if (screenState != null) {
      screenState = ScreenState.error;
    }
  } else {
    if (!Get.isDialogOpen!) {
      showErrorDialog(
          title: '예기치 못한 에러 발생',
          content: '에러에러 Code: ${httpresponse.errorData!['statusCode']}',
          leftFunction: () {
            Get.back();
          });
    }
    if (screenState != null) {
      screenState = ScreenState.error;
    }
  }
}
