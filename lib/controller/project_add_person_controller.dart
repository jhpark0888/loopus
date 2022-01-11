// import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:get/get.dart';
// import 'package:loopus/api/loop_api.dart';
// import 'package:loopus/controller/project_add_controller.dart';
// import 'package:loopus/model/user_model.dart';
// import 'package:loopus/widget/checkboxperson_widget.dart';
// import 'package:loopus/widget/selected_persontag_widget.dart';
// import 'package:loopus/widget/selected_tag_widget.dart';

// class ProjectAddPersonController extends GetxController {
//   static ProjectAddPersonController get to => Get.find();
//   ProjectAddController projectaddController = Get.find();

//   void onInit() async {
//     String? userId = await const FlutterSecureStorage().read(key: "id");
//     looplist = await getlooplist(userId!);
//     super.onInit();
//   }

//   List<User> looplist = <User>[].obs;
//   RxBool isLoopPersonLoading = true.obs;
//   List<CheckBoxPersonWidget> looppersonlist = <CheckBoxPersonWidget>[].obs;

//   RxList<SelectedPersonTagWidget> selectedpersontaglist =
//       <SelectedPersonTagWidget>[].obs;
// }
