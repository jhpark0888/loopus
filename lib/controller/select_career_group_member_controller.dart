import 'package:get/get.dart';

class SelectCareerGroupMemberController extends GetxController{
  RxString searchWord = ''.obs;
  @override
  void onInit() {
    debounce(searchWord, (_){
      if(searchWord.value != ''){
        
      }
    });
    super.onInit();
  }
}
