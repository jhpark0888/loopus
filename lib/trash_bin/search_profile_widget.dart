// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:loopus/constant.dart';
// import 'package:loopus/model/user_model.dart';
// import 'package:loopus/screen/other_profile_screen.dart';

// import '../controller/hover_controller.dart';

// class SearchProfileWidget extends StatelessWidget {
//   Person user;
//   SearchProfileWidget({
//     required this.user,
//   });
//   late final HoverController _hoverController =
//       Get.put(HoverController(), tag: 'searchProfile' + user.userid.toString());

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//         behavior: HitTestBehavior.translucent,
//         onTapDown: (details) => _hoverController.isHover(true),
//         onTapCancel: () => _hoverController.isHover(false),
//         onTapUp: (details) => _hoverController.isHover(false),
//         onTap: () async {
//           // profileController.isProfileLoading(true);

//           Get.to(() => OtherProfileScreen(
//                 userid: user.userid,
//                 realname: user.name,
//               ));
//         },
//         child: Padding(
//           padding: const EdgeInsets.symmetric(
//             horizontal: 16,
//             vertical: 8,
//           ),
//           child: Row(
//             children: [
//               (user.profileImage == null)
//                   ? Obx(
//                       () => Opacity(
//                         opacity: _hoverController.isHover.value ? 0.6 : 1,
//                         child: Image.asset(
//                           "assets/illustrations/default_profile.png",
//                           width: 50,
//                           height: 50,
//                         ),
//                       ),
//                     )
//                   : Obx(
//                       () => Opacity(
//                         opacity: _hoverController.isHover.value ? 0.6 : 1,
//                         child: ClipOval(
//                           child: CachedNetworkImage(
//                             height: 50,
//                             width: 50,
//                             imageUrl: user.profileImage!,
//                             placeholder: (context, url) =>
//                                 kProfilePlaceHolder(),
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                       ),
//                     ),
//               SizedBox(
//                 width: 12,
//               ),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Obx(
//                       () => Text(
//                         user.name,
//                         style: kSubTitle2Style.copyWith(
//                             color: _hoverController.isHover.value
//                                 ? mainblack.withOpacity(0.6)
//                                 : mainblack),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 8,
//                     ),
//                     Obx(
//                       () => Text(
//                         user.department,
//                         style: kSubTitle3Style.copyWith(
//                           color: _hoverController.isHover.value
//                               ? mainblack.withOpacity(0.38)
//                               : mainblack.withOpacity(0.6),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ));
//   }
// }
