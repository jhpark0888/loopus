import 'package:get/get.dart';

class BookmarkController extends GetxController {
  static BookmarkController get to => Get.find();
  RxBool bookmark = false.obs;

  @override
  void onInit() {
    super.onInit();
  }
}
