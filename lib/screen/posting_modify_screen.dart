// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:loopus/constant.dart';
// import 'package:loopus/controller/hover_controller.dart';
// import 'package:loopus/controller/post_detail_controller.dart';
// import 'package:loopus/controller/posting_add_controller.dart';
// import 'package:loopus/screen/posting_add_content_screen.dart';
// import 'package:loopus/screen/posting_add_image_screen.dart';
// import 'package:loopus/screen/posting_add_name_screen.dart';
// import 'package:loopus/widget/appbar_widget.dart';

// class PostingModifyScreen extends StatelessWidget {
//   PostingModifyScreen({Key? key, required this.postid}) : super(key: key);

//   PostingAddController postingaddcontroller =
//       Get.put(PostingAddController(route: PostaddRoute.update));

//   int postid;
//   late PostingDetailController controller = Get.find(tag: postid.toString());

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBarWidget(
//           bottomBorder: false,
//           title: '포스팅 편집',
//           leading: IconButton(
//             onPressed: () {
//               Get.back();
//             },
//             icon: SvgPicture.asset('assets/icons/Arrow.svg'),
//           ),
//         ),
//         body: ListView(
//           children: [
//             Obx(
//               () => UpdatePostingTileWidget(
//                 hoverTag: '포스팅 제목 변경',
//                 isSubtitleExist: true,
//                 onTap: () async {
//                   postingtitleinput();
//                   Get.to(() => PostingAddNameScreen(
//                       postid: postid,
//                       project_id: controller.post.value.project!.id,
//                       route: PostaddRoute.update));
//                 },
//                 title: '포스팅 제목',
//                 subtitle: controller.post.value.title,
//               ),
//             ),
//             UpdatePostingTileWidget(
//               hoverTag: '포스팅 내용 변경',
//               isSubtitleExist: false,
//               onTap: () async {
//                 postingcontentsinput();
//                 Get.to(() => PostingAddContentScreen(
//                       postid: postid,
//                       project_id: controller.post.value.project!.id,
//                     ));
//               },
//               title: '포스팅 내용',
//               subtitle: "",
//             ),
//             UpdatePostingTileWidget(
//               hoverTag: '포스팅 대표사진 변경',
//               isSubtitleExist: false,
//               onTap: () async {
//                 postingthumbnailinput();
//                 Get.to(() => PostingAddImageScreen(
//                       postid: postid,
//                       project_id: controller.post.value.project!.id,
//                     ));
//               },
//               title: '대표 사진 변경',
//               subtitle: '',
//             ),
//           ],
//         ));
//   }

//   void postingtitleinput() {
//     postingaddcontroller.titlecontroller.text = controller.post.value.title;
//   }

//   void postingcontentsinput() {
//     postingaddcontroller.editorController.alllistclear();
//     controller.post.value.contents?.forEach((content) {
//       if (content.type == SmartTextType.IMAGE) {
//         postingaddcontroller.editorController.types.add(content.type);
//         postingaddcontroller.editorController.urlimageindex
//             .add(content.content);
//         postingaddcontroller.editorController.imageindex.add(null);
//         postingaddcontroller.editorController.linkindex.add(null);
//         postingaddcontroller.editorController.nodes.add(FocusNode());
//         postingaddcontroller.editorController.textcontrollers
//             .add(TextEditingController());
//       } else if (content.type == SmartTextType.LINK) {
//         postingaddcontroller.editorController.insert(
//             index: controller.post.value.contents!.indexOf(content),
//             text: content.content,
//             type: content.type);
//         postingaddcontroller.editorController
//                 .linkindex[controller.post.value.contents!.indexOf(content)] =
//             content.url;
//       } else {
//         postingaddcontroller.editorController.insert(
//             index: controller.post.value.contents!.indexOf(content),
//             text: content.content,
//             type: content.type);
//       }
//     });
//   }

//   void postingthumbnailinput() {
//     postingtitleinput();
//     postingcontentsinput();
//     postingaddcontroller.postingurlthumbnail.value =
//         controller.post.value.thumbnail ?? "";
//     postingaddcontroller.thumbnail.value = File("");
//   }
// }

// class UpdatePostingTileWidget extends StatelessWidget {
//   UpdatePostingTileWidget({
//     required this.onTap,
//     required this.title,
//     required this.subtitle,
//     required this.isSubtitleExist,
//     required this.hoverTag,
//   });

//   final VoidCallback onTap;
//   final String title;
//   final String subtitle;
//   final bool isSubtitleExist;
//   final String hoverTag;
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
//       child: Padding(
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
//                       style: kSubTitle2Style.copyWith(
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
//                         style: kSubTitle3Style.copyWith(
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
//               () => SvgPicture.asset('assets/icons/Arrow_right.svg',
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
