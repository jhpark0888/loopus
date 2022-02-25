import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/screen/withdrawal_screen.dart';

class WithDrawalController extends GetxController {
  static WithDrawalController get to => Get.find();

  RxBool iswithdrawalloading = false.obs;

  List<SelectedOptionWidget> reasonlist = kWithdrawalOptions
      .map((reason) => SelectedOptionWidget(text: reason.toString()))
      .toList();
  @override
  void onInit() {
    // TODO: implement onInit

    super.onInit();
  }
}
