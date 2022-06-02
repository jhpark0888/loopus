// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:loopus/constant.dart';
// import 'package:loopus/controller/editorcontroller.dart';

// extension SmartTextStyle on SmartTextType {
//   TextStyle get textStyle {
//     switch (this) {
//       // case SmartTextType.QUOTE:
//       //   return const TextStyle(
//       //     fontSize: 14,
//       //     fontStyle: FontStyle.italic,
//       //     fontWeight: FontWeight.w400,
//       //     color: mainblack,
//       //     height: 1.2,
//       //   );
//       case SmartTextType.H1:
//         return const TextStyle(
//           fontSize: 20,
//           color: mainblack,
//           fontWeight: FontWeight.w500,
//           height: 1.5,
//         );
//       case SmartTextType.H2:
//         return const TextStyle(
//           fontSize: 16,
//           color: mainblack,
//           fontWeight: FontWeight.w500,
//           height: 1.6,
//         );

//       case SmartTextType.LINK:
//         return const TextStyle(
//           fontSize: 16,
//           fontWeight: FontWeight.w400,
//           shadows: [Shadow(color: mainblue, offset: Offset(0, -5))],
//           color: Colors.transparent,
//           decoration: TextDecoration.underline,
//           decorationColor: mainblue,
//           decorationThickness: 1.2,
//           decorationStyle: TextDecorationStyle.solid,
//         );
//       case SmartTextType.IMAGEINFO:
//         return const TextStyle(
//           fontSize: 12.0,
//           fontWeight: FontWeight.w300,
//           color: mainblack,
//         );
//       default:
//         return const TextStyle(
//           fontSize: 16.0,
//           fontWeight: FontWeight.w300,
//           color: mainblack,
//           height: 1.6,
//         );
//     }
//   }

//   EdgeInsets get padding {
//     switch (this) {
//       case SmartTextType.H1:
//         return const EdgeInsets.fromLTRB(16, 12, 16, 8);
//       case SmartTextType.BULLET:
//         return const EdgeInsets.fromLTRB(24, 4, 16, 4);
//       case SmartTextType.IMAGE:
//         return const EdgeInsets.only(top: 16);
//       default:
//         return const EdgeInsets.fromLTRB(16, 8, 16, 8);
//     }
//   }

//   TextAlign get align {
//     switch (this) {
//       // case SmartTextType.QUOTE:
//       //   return TextAlign.center;
//       case SmartTextType.IMAGEINFO:
//         return TextAlign.center;
//       default:
//         return TextAlign.start;
//     }
//   }

//   Alignment get imageAlign {
//     switch (this) {
//       case SmartTextType.IMAGE:
//         return Alignment.center;
//       default:
//         return Alignment.topLeft;
//     }
//   }

//   String? get prefix {
//     switch (this) {
//       case SmartTextType.BULLET:
//         return '\u2022 ';
//       default:
//         return null;
//     }
//   }
// }

// class SmartTextField extends StatelessWidget {
//   SmartTextField(
//       {Key? key, required this.type, this.controller, this.focusNode})
//       : super(key: key);

//   EditorController editorController = Get.find();
//   final Rx<SmartTextType> type;
//   final TextEditingController? controller;
//   final FocusNode? focusNode;

//   @override
//   Widget build(BuildContext context) {
//     return type.value == SmartTextType.IMAGE
//         ? editorController.imageindex[
//                     editorController.textcontrollers.indexOf(controller)] !=
//                 null
//             ? Align(
//                 alignment: type.value.imageAlign,
//                 child: Stack(children: [
//                   Image.file(editorController.imageindex[
//                       editorController.textcontrollers.indexOf(controller)]!),
//                   IconButton(
//                     onPressed: () {
//                       editorController.imagedelete(controller);
//                     },
//                     icon: const Icon(
//                       Icons.cancel_rounded,
//                       color: Colors.black26,
//                     ),
//                     iconSize: 32,
//                   )
//                 ]),
//               )
//             : Align(
//                 alignment: type.value.imageAlign,
//                 child: Padding(
//                   padding: type.value.padding,
//                   child: Stack(children: [
//                     Image.network(editorController.urlimageindex[
//                         editorController.textcontrollers.indexOf(controller)]!),
//                     IconButton(
//                       onPressed: () {
//                         editorController.imagedelete(controller);
//                       },
//                       icon: const Icon(
//                         Icons.cancel_rounded,
//                         color: Colors.black26,
//                       ),
//                       iconSize: 32,
//                     )
//                   ]),
//                 ),
//               )
//         : Focus(
//             onFocusChange: (hasFocus) {
//               if (hasFocus) {
//                 editorController.setFocus(type.value);
//               }
//             },
//             child: TextField(
//               inputFormatters: [
//                 // TextInputFormatter
//               ],
//               autocorrect: false,
//               controller: controller,
//               focusNode: focusNode,
//               autofocus: true,
//               keyboardType: TextInputType.multiline,
//               maxLines: null,
//               cursorColor: mainblue,
//               cursorWidth: 1.3,
//               cursorRadius: const Radius.circular(500),
//               textAlign: type.value.align,
//               decoration: InputDecoration(
//                   hintText: type.value == SmartTextType.IMAGEINFO
//                       ? "이미지에 대한 설명을 적어주세요"
//                       : "",
//                   border: InputBorder.none,
//                   prefixText: type.value.prefix,
//                   prefixStyle: type.value.textStyle,
//                   isDense: true,
//                   contentPadding: type.value.padding),
//               style: type.value.textStyle,
//               toolbarOptions: const ToolbarOptions(
//                 cut: true,
//                 copy: true,
//                 paste: true,
//                 selectAll: true,
//               ),
//             ),
//           );
//   }
// }
