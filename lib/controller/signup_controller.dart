import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

enum UserType {
  student,
  company,
  professer,
}

class SignupController extends GetxController {
  static SignupController get to => Get.find();
  TextEditingController campusnamecontroller = TextEditingController();
  TextEditingController classnumcontroller = TextEditingController();
  TextEditingController departmentcontroller = TextEditingController();
  TextEditingController emailidcontroller = TextEditingController();
  TextEditingController namecontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController passwordcheckcontroller = TextEditingController();
  RxBool emailcheck = false.obs;
  RxBool isdeptSearchLoading = false.obs;
  RxString selectdept = "".obs;

  Rx<UserType> selectedType = UserType.student.obs;

  RxList deptlist = [].obs;
  RxList searchdeptlist = [].obs;

  static final FlutterSecureStorage storage = FlutterSecureStorage();

  @override
  void onInit() {
    departmentcontroller.addListener(() {
      searchdeptlist.clear();
      isdeptSearchLoading(true);
      for (String dept in deptlist) {
        if (dept.contains(departmentcontroller.text)) {
          searchdeptlist.add(dept.toString());
        }
      }
      isdeptSearchLoading(false);
    });
    super.onInit();
  }

  @override
  void onClose() {
    campusnamecontroller.clear();
    classnumcontroller.clear();
    departmentcontroller.clear();
    emailidcontroller.clear();
    namecontroller.clear();
    passwordcontroller.clear();
    passwordcheckcontroller.clear();
    super.onClose();
  }
}
