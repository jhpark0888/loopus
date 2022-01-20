// import 'package:flutter/material.dart';
// import 'package:loopus/constant.dart';

// class StartDateTextFormField extends StatelessWidget {
//   StartDateTextFormField(
//       {Key? key,
//       required this.controller,
//       this.focusNode,
//       required this.maxLenght,
//       this.hinttext,
//       this.validator})
//       : super(key: key);

//   TextEditingController controller;
//   FocusNode? focusNode;
//   int maxLenght;
//   String? hinttext;
//   String? Function(String?)? validator;

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       child: TextFormField(
//         scrollPadding: EdgeInsets.zero,
//         validator: validator,
//         focusNode: focusNode,
//         controller: controller,
//         cursorColor: mainblack,
//         keyboardType: TextInputType.number,
//         decoration: InputDecoration(
//           contentPadding: EdgeInsets.zero,
//           isDense: true,
//           counterText: '',
//           enabledBorder: UnderlineInputBorder(
//             borderRadius: BorderRadius.circular(2),
//             borderSide: BorderSide(color: mainblack, width: 1.2),
//           ),
//           focusedBorder: UnderlineInputBorder(
//             borderRadius: BorderRadius.circular(2),
//             borderSide: BorderSide(color: mainblack, width: 1.2),
//           ),
//           errorBorder: UnderlineInputBorder(
//             borderRadius: BorderRadius.circular(2),
//             borderSide: BorderSide(color: mainpink, width: 1.2),
//           ),
//           focusedErrorBorder: UnderlineInputBorder(
//             borderRadius: BorderRadius.circular(2),
//             borderSide: BorderSide(color: mainpink, width: 1.2),
//           ),
//           hintText: hinttext,
//           hintStyle:
//               kSubTitle2Style.copyWith(color: mainblack.withOpacity(0.38)),
//         ),
//         textAlign: TextAlign.center,
//         autocorrect: false,
//         cursorWidth: 1.2,
//         cursorRadius: Radius.circular(2),
//         maxLength: maxLenght,
//       ),
//     );
//   }
// }
