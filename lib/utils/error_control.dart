import 'package:get/get.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/model/httpresponse_model.dart';

void errorSituation(HTTPResponse httpresponse) {
  if (httpresponse.errorData!['statusCode'] == 59) {
    showdisconnectdialog();
  } else if (httpresponse.errorData!['statusCode'] == 404) {
    Get.back();
    showCustomDialog('존재하지 않는 콘텐츠입니다', 1200);
  } else {
    showErrorDialog(
        title: '예기치 못한 에러 발생',
        content: '에러에러',
        leftFunction: () {
          Get.back();
        });
  }
}
