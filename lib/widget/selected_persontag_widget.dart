// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:loopus/constant.dart';
// import 'package:loopus/controller/project_add_person_controller.dart';
// import 'package:loopus/controller/project_add_controller.dart';

// class SelectedPersonTagWidget extends StatelessWidget {
//   SelectedPersonTagWidget({Key? key, required this.text, this.id})
//       : super(key: key);

//   // ProjectAddPersonController projectAddPersonController = Get.find();

//   String text;
//   int? id;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(right: 8),
//       padding: const EdgeInsets.fromLTRB(14, 4, 4, 4),
//       decoration: BoxDecoration(
//         color: mainlightgrey,
//         borderRadius: BorderRadius.circular(40),
//       ),
//       child: Row(
//         // mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(
//             text,
//             style: TextStyle(fontSize: 14),
//           ),
//           const SizedBox(
//             width: 2,
//           ),
//           Padding(
//             padding: const EdgeInsets.only(right: 4),
//             child: InkWell(
//               onTap: () {},
//               child: SvgPicture.asset(
//                 "assets/icons/Close_blue.svg",
//                 width: 24,
//                 height: 24,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
