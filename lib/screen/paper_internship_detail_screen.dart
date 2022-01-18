// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:loopus/constant.dart';
// import 'package:loopus/widget/appbar_widget.dart';

// class PaperInternshipDetailScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBarWidget(
//         bottomBorder: false,
//         actions: [
//           IconButton(
//             onPressed: () {},
//             icon: SvgPicture.asset('assets/icons/Export.svg'),
//           ),
//           IconButton(
//             onPressed: () {},
//             icon: SvgPicture.asset('assets/icons/Link.svg'),
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.fromLTRB(
//                 16,
//                 24,
//                 16,
//                 12,
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   Text(
//                     '공고 디테일 제목',
//                     style: kHeaderH2Style,
//                   ),
//                   SizedBox(
//                     height: 24,
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Row(
//                         children: [
//                           ClipOval(
//                             child: CachedNetworkImage(
//                               height: 32,
//                               width: 32,
//                               imageUrl: "https://i.stack.imgur.com/l60Hf.png",
//                               placeholder: (context, url) => CircleAvatar(
//                                 child:
//                                     Center(child: CircularProgressIndicator()),
//                               ),
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                           SizedBox(
//                             width: 8,
//                           ),
//                           Text(
//                             "채용기관명",
//                             style: kButtonStyle,
//                           ),
//                         ],
//                       ),
//                       Row(
//                         children: [
//                           SvgPicture.asset(
//                             'assets/icons/View.svg',
//                             color: mainblack.withOpacity(0.6),
//                           ),
//                           SizedBox(
//                             width: 4,
//                           ),
//                           Text(
//                             '조회수',
//                             style: kBody1Style.copyWith(
//                               color: mainblack.withOpacity(0.6),
//                               height: 1.3,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             Container(
//               height: 1,
//               color: Color(0xffe7e7e7),
//             ),
//             Padding(
//               padding: const EdgeInsets.fromLTRB(
//                 16,
//                 24,
//                 16,
//                 20,
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   Text(
//                     '접수 기간',
//                     style: kSubTitle2Style,
//                   ),
//                   SizedBox(
//                     height: 16,
//                   ),
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Text(
//                         '21년 12월 27일(금) ~ 22년 01월 03일(화)',
//                         style: kBody2Style,
//                       ),
//                       SizedBox(
//                         width: 12,
//                       ),
//                       Text(
//                         'D-17',
//                         style: kButtonStyle.copyWith(
//                           color: mainblue,
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(
//                     height: 24,
//                   ),
//                   Text(
//                     '상세 정보',
//                     style: kSubTitle2Style,
//                   ),
//                   SizedBox(
//                     height: 16,
//                   ),
//                   Row(
//                     children: [
//                       Text(
//                         '지원 자격',
//                         style: kBody2Style,
//                       ),
//                       SizedBox(
//                         width: 12,
//                       ),
//                       Text(
//                         '2·3년제 졸업 이상',
//                         style: kButtonStyle,
//                       ),
//                     ],
//                   ),
//                   SizedBox(
//                     height: 12,
//                   ),
//                   Row(
//                     children: [
//                       Text(
//                         '근무 지역',
//                         style: kBody2Style,
//                       ),
//                       SizedBox(
//                         width: 12,
//                       ),
//                       Text(
//                         '서울',
//                         style: kButtonStyle,
//                       ),
//                     ],
//                   ),
//                   SizedBox(
//                     height: 12,
//                   ),
//                   Row(
//                     children: [
//                       Text(
//                         '채용 형태',
//                         style: kBody2Style,
//                       ),
//                       SizedBox(
//                         width: 12,
//                       ),
//                       Text(
//                         '신입·전환형 인턴',
//                         style: kButtonStyle,
//                       ),
//                     ],
//                   ),
//                   SizedBox(
//                     height: 12,
//                   ),
//                   Row(
//                     children: [
//                       Text(
//                         '모집 부문',
//                         style: kBody2Style,
//                       ),
//                       SizedBox(
//                         width: 12,
//                       ),
//                       Text(
//                         'IT·SW, 디자인, 기타만원',
//                         style: kButtonStyle,
//                       ),
//                     ],
//                   ),
//                   SizedBox(
//                     height: 24,
//                   ),
//                   Text(
//                     '공고 포스터',
//                     style: kSubTitle2Style,
//                   ),
//                   SizedBox(
//                     height: 16,
//                   ),
//                   CachedNetworkImage(
//                     fadeOutDuration: Duration(milliseconds: 500),
//                     imageUrl:
//                         "https://res.cloudinary.com/linkareer/image/fetch/f_auto/https://s3.ap-northeast-2.amazonaws.com/media.linkareer.com/activity_manager/posters/2021-03-231147367242010_%EB%A9%98%ED%86%A0%EB%8B%A8_%EC%B6%94%EA%B0%80%EB%AA%A8%EC%A7%91_%ED%8F%AC%EC%8A%A4%ED%84%B0.jpg",
//                     placeholder: (context, url) => CircleAvatar(
//                         child: Container(
//                       color: mainWhite,
//                     )),
//                     fit: BoxFit.cover,
//                   ),
//                 ],
//               ),
//             ),
//             Container(
//               height: 8,
//               color: Color(0xfff2f3f5),
//             ),
//             SizedBox(
//               height: 40,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
