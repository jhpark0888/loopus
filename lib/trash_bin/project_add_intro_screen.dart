// // ignore_for_file: prefer_const_constructors

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:loopus/api/project_api.dart';
// import 'package:loopus/constant.dart';
// import 'package:loopus/controller/project_add_controller.dart';
// import 'package:loopus/controller/project_detail_controller.dart';
// import 'package:loopus/screen/project_add_period_screen.dart';
// import 'package:loopus/widget/appbar_widget.dart';
// import 'package:loopus/widget/custom_textfield.dart';

// import '../controller/modal_controller.dart';

// class ProjectAddIntroScreen extends StatelessWidget {
//   ProjectAddIntroScreen({
//     Key? key,
//     this.projectid,
//     required this.screenType,
//   }) : super(key: key);

//   ProjectAddController projectaddcontroller = Get.find();
//   Screentype screenType;
//   int? projectid;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => FocusScope.of(context).unfocus(),
//       child: Scaffold(
//         appBar: AppBarWidget(
//           bottomBorder: false,
//           actions: [
//             screenType == Screentype.add
//                 ? TextButton(
//                     onPressed: () async {
//                       Get.to(() => ProjectAddPeriodScreen(
//                             screenType: Screentype.add,
//                           ));
//                     },
//                     child: Obx(
//                       () => Padding(
//                         padding: const EdgeInsets.only(right: 4.0),
//                         child: Text(
//                             (projectaddcontroller.isIntroTextEmpty.value ==
//                                     true)
//                                 ? '건너뛰기'
//                                 : '다음',
//                             style: kSubTitle2Style.copyWith(color: mainblue)),
//                       ),
//                     ),
//                   )
//                 : Obx(
//                     () => Get.find<ProjectDetailController>(
//                                 tag: projectid.toString())
//                             .isProjectUpdateLoading
//                             .value
//                         ? Image.asset(
//                             'assets/icons/loading.gif',
//                             scale: 9,
//                           )
//                         : TextButton(
//                             onPressed: () async {
//                               Get.find<ProjectDetailController>(
//                                       tag: projectid.toString())
//                                   .isProjectUpdateLoading
//                                   .value = true;
//                               await updateproject(
//                                       Get.find<ProjectDetailController>(
//                                               tag: projectid.toString())
//                                           .project
//                                           .value
//                                           .id,
//                                       ProjectUpdateType.introduction)
//                                   .then((value) {
//                                 Get.find<ProjectDetailController>(
//                                         tag: projectid.toString())
//                                     .isProjectUpdateLoading
//                                     .value = false;
//                               });
//                             },
//                             child: Text('저장',
//                                 style:
//                                     kSubTitle2Style.copyWith(color: mainblue)),
//                           ),
//                   )
//           ],
//           title: '활동 정보',
//         ),
//         body: Padding(
//           padding: const EdgeInsets.fromLTRB(
//             32,
//             24,
//             32,
//             40,
//           ),
//           child: Center(
//             child: Column(
//               children: [
//                 RichText(
//                   textAlign: TextAlign.center,
//                   text: TextSpan(
//                     children: [
//                       TextSpan(
//                         text: '어떤 활동인지 ',
//                         style: kSubTitle1Style,
//                       ),
//                       TextSpan(
//                         text: '간략하게 소개',
//                         style: kSubTitle1Style.copyWith(
//                           color: mainblue,
//                         ),
//                       ),
//                       TextSpan(
//                         text: '해주세요',
//                         style: kSubTitle1Style,
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(
//                   height: 12,
//                 ),
//                 Text(
//                   '지금 적지 않아도 나중에 추가할 수 있어요',
//                   style: kBody2Style,
//                 ),
//                 SizedBox(
//                   height: 32,
//                 ),
//                 CustomTextField(
//                     counterText: null,
//                     maxLength: null,
//                     textController: projectaddcontroller.introcontroller,
//                     hintText: 'OO를 주제로 진행하였으며, OO 역할을 맡았습니다.',
//                     validator: null,
//                     obscureText: false,
//                     maxLines: 5),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
