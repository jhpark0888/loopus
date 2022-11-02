// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:loopus/api/loop_api.dart';
// import 'package:loopus/constant.dart';
// import 'package:loopus/controller/hover_controller.dart';
// import 'package:loopus/controller/profile_controller.dart';
// import 'package:loopus/controller/project_add_controller.dart';
// import 'package:loopus/controller/project_detail_controller.dart';
// import 'package:loopus/controller/tag_controller.dart';
// import 'package:loopus/trash_bin/project_add_intro_screen.dart';
// import 'package:loopus/screen/project_add_title_screen.dart';
// import 'package:loopus/screen/project_add_period_screen.dart';
// import 'package:loopus/screen/project_add_person_screen.dart';
// import 'package:loopus/widget/appbar_widget.dart';
// import 'package:intl/intl.dart';
// import 'package:loopus/widget/selected_tag_widget.dart';

// class ProjectModifyScreen extends StatelessWidget {
//   ProjectModifyScreen({Key? key, required this.projectid}) : super(key: key);

//   ProjectAddController projectaddcontroller = Get.put(ProjectAddController());
//   // ProjectDetailController projectDetailController = Get.find();
//   //
//   int projectid;
//   late ProjectDetailController controller = Get.find(tag: projectid.toString());

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBarWidget(
//           bottomBorder: false,
//           title: '활동 편집',
//           leading: IconButton(
//             onPressed: () {
//               Get.back();
//             },
//             icon: SvgPicture.asset('assets/icons/appbar_back.svg'),
//           ),
//         ),
//         body: ListView(
//           children: [
//             Obx(
//               () => UpdateProjectTileWidget(
//                 hoverTag: '활동명',
//                 isSubtitleExist: true,
//                 onTap: () async {
//                   projectnameinput();
//                   Get.to(() => ProjectAddTitleScreen(
//                         projectid: projectid,
//                         screenType: Screentype.update,
//                       ));
//                 },
//                 title: '활동명',
//                 subtitle: controller.project.value.careerName,
//               ),
//             ),
//             Obx(
//               () => UpdateProjectTileWidget(
//                 hoverTag: '활동기간',
//                 isSubtitleExist: true,
//                 onTap: () async {
//                   projectdateinput();
//                   Get.to(() => ProjectAddPeriodScreen(
//                         projectid: projectid,
//                         screenType: Screentype.update,
//                       ));
//                 },
//                 title: '활동 기간',
//                 subtitle:
//                     '${DateFormat("yy.MM.dd").format(controller.project.value.startDate!)} ~ ${controller.project.value.endDate != null ? DateFormat("yy.MM.dd").format(controller.project.value.endDate!) : '진행중'}',
//               ),
//             ),
//             Obx(
//               () => UpdateProjectTileWidget(
//                 hoverTag: '활동사람',
//                 isSubtitleExist: true,
//                 onTap: () async {
//                   projectlooperinput();

//                   getprojectfollowlist(
//                       ProfileController.to.myUserInfo.value.userid,
//                       followlist.following);
//                   Get.to(() => ProjectAddPersonScreen(
//                         projectid: projectid,
//                         screenType: Screentype.update,
//                       ));
//                 },
//                 title: '함께 활동한 사람',
//                 subtitle: controller.project.value.members.isEmpty
//                     ? '함께 활동한 사람이 없어요'
//                     : controller.project.value.members
//                         .map((user) => user.name)
//                         .toList()
//                         .join(', '),
//               ),
//             ),
//           ],
//         ));
//   }

//   void projectnameinput() {
//     projectaddcontroller.projectnamecontroller.text =
//         controller.project.value.careerName;
//   }

//   void projectdateinput() {
//     projectaddcontroller.selectedStartDateTime.value =
//         controller.project.value.startDate!.toString();

//     if (controller.project.value.endDate != null) {
//       projectaddcontroller.selectedEndDateTime.value =
//           controller.project.value.endDate!.toString();
//       projectaddcontroller.isEndedProject.value = true;
//     } else {
//       projectaddcontroller.isEndedProject.value = false;
//     }
//   }

//   void projectlooperinput() {
//     if (controller.project.value.members != null) {
//       projectaddcontroller.selectedpersontaglist.clear();
//       for (var user in controller.project.value.members) {
//         projectaddcontroller.selectedpersontaglist.add(SelectedTagWidget(
//           id: user.userid,
//           text: user.name,
//           selecttagtype: SelectTagtype.person,
//           tagtype: Tagtype.Posting,
//         ));
//       }
//     }
//   }
// }

// class UpdateProjectTileWidget extends StatelessWidget {
//   UpdateProjectTileWidget({
//     required this.onTap,
//     required this.title,
//     required this.subtitle,
//     required this.isSubtitleExist,
//     required this.hoverTag,
//   });

//   VoidCallback onTap;
//   String title;
//   String subtitle;
//   bool isSubtitleExist;
//   String hoverTag;

//   late final HoverController _hoverController =
//       Get.put(HoverController(), tag: hoverTag);

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       behavior: HitTestBehavior.translucent,
//       onTapDown: (details) => _hoverController.isHover(true),
//       onTapCancel: () => _hoverController.isHover(false),
//       onTapUp: (details) => _hoverController.isHover(false),
//       onTap: onTap,
//       child: Container(
//         padding: EdgeInsets.symmetric(
//           horizontal: 16,
//           vertical: (isSubtitleExist) ? 16 : 20,
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Obx(
//                     () => Text(
//                       title,
//                       style: ktempFont.copyWith(
//                           color: _hoverController.isHover.value
//                               ? mainblack.withOpacity(0.6)
//                               : mainblack),
//                     ),
//                   ),
//                   if (isSubtitleExist)
//                     SizedBox(
//                       height: 12,
//                     ),
//                   if (isSubtitleExist)
//                     Obx(
//                       () => Text(
//                         subtitle,
//                         style: ktempFont.copyWith(
//                             color: _hoverController.isHover.value
//                                 ? mainblack.withOpacity(0.6)
//                                 : mainblack),
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//             Obx(
//               () => SvgPicture.asset('assets/icons/arrow_right.svg',
//                   color: _hoverController.isHover.value
//                       ? mainblack.withOpacity(0.6)
//                       : mainblack),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
