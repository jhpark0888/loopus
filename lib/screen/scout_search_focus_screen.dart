// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:http/retry.dart';
// import 'package:loopus/constant.dart';
// import 'package:loopus/controller/home_controller.dart';
// import 'package:loopus/controller/scout_report_controller.dart';
// import 'package:loopus/model/contact_model.dart';
// import 'package:loopus/model/user_model.dart';
// import 'package:loopus/screen/myProfile_screen.dart';
// import 'package:loopus/widget/appbar_widget.dart';
// import 'package:loopus/widget/company_image_widget.dart';
// import 'package:loopus/widget/company_widget.dart';
// import 'package:loopus/widget/contact_widget.dart';
// import 'package:loopus/widget/custom_expanded_button.dart';
// import 'package:loopus/widget/custom_header_footer.dart';
// import 'package:loopus/widget/disconnect_reload_widget.dart';
// import 'package:loopus/widget/divide_widget.dart';
// import 'package:loopus/widget/error_reload_widget.dart';
// import 'package:loopus/widget/loading_widget.dart';
// import 'package:loopus/widget/person_image_widget.dart';
// import 'package:loopus/widget/scroll_noneffect_widget.dart';
// import 'package:loopus/widget/search_text_field_widget.dart';
// import 'package:loopus/widget/user_image_widget.dart';
// import 'package:path/path.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';
// import 'package:loopus/controller/search_controller.dart';
// import 'package:loopus/api/search_api.dart';
// import 'package:loopus/controller/app_controller.dart';

// class ScoutSearchFocusScreen extends StatefulWidget {
//   @override
//   State<ScoutSearchFocusScreen> createState() => _ScoutSearchFocusScreenState();
// }

// class _ScoutSearchFocusScreenState extends State<ScoutSearchFocusScreen> {
//   final SearchController _searchController = Get.find();

//   final List<String> _valuelist = ['서울', '인천', '경기', '대전', '대구', '부산', '전국'];

//   RxString _selectedValue = '전국'.obs;

//   final List<String> _secondvaluelist = [
//     '전체',
//     'IT',
//     '디자인',
//     '마케팅',
//     '컨설턴트',
//     '세무'
//   ];

//   RxString _secondselectedValue = '디자인'.obs;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//         onTap: () {
//           _searchController.focusNode.unfocus();
//         },
//         child: Scaffold(
//           resizeToAvoidBottomInset: true,
//           appBar: AppBarWidget(
//             leading: IconButton(
//               onPressed: () {
//                 Get.back();
//               },
//               icon: SvgPicture.asset('assets/icons/appbar_back.svg'),
//             ),
//             title: '기업검색',
//           ),
//           body: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               Padding(
//                 padding: EdgeInsets.fromLTRB(20, 14, 14, 0),
//                 child: Row(
//                   children: [
//                     Container(
//                       decoration: BoxDecoration(
//                           border: Border.all(color: maingray, width: 1),
//                           borderRadius: BorderRadius.circular(8),
//                           color: maingray),
//                       color: mainWhite,
//                       child: Row(children: [
//                         Text("지역", style: kmainbold),
//                         SizedBox(width: 7),
//                         DropdownButton(
//                           style: kmain,
//                           value: _selectedValue.value.isNotEmpty
//                               ? _selectedValue.value
//                               : null,
//                           items: _valuelist.map((item) {
//                             return DropdownMenuItem(
//                               value: item,
//                               child: Text(item),
//                             );
//                           }).toList(),
//                           onChanged: (String? value) {
//                             setState(() {
//                               _selectedValue.value = value!;
//                             });
//                           },
//                           underline:
//                               DropdownButtonHideUnderline(child: Container()),
//                         ),
//                       ]),
//                     ),
//                     SizedBox(width: 14),
//                     Container(
//                       decoration: BoxDecoration(
//                           border: Border.all(color: maingray, width: 1),
//                           borderRadius: BorderRadius.circular(8),
//                           color: maingray),
//                       color: mainWhite,
//                       child: Row(children: [
//                         Text("분야", style: kmainbold),
//                         SizedBox(width: 7),
//                         DropdownButton(
//                           style: kmain,
//                           value: _secondselectedValue.value.isNotEmpty
//                               ? _secondselectedValue.value
//                               : null,
//                           items: _secondvaluelist.map((item) {
//                             return DropdownMenuItem(
//                               value: item,
//                               child: Text(item),
//                             );
//                           }).toList(),
//                           onChanged: (String? value) {
//                             setState(() {
//                               _secondselectedValue.value = value!;
//                             });
//                           },
//                           underline:
//                               DropdownButtonHideUnderline(child: Container()),
//                         ),
//                       ]),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 14),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 20),
//                 width: MediaQuery.of(context).size.width,
//                 height: 50,
//                 child: Row(
//                   children: [
//                     Expanded(
//                         child: SearchTextFieldWidget(
//                       hinttext: '지역별 직무 검색',
//                       ontap: () {},
//                       readonly: false,
//                       controller: _searchController.searchtextcontroller,
//                     )),
//                     GestureDetector(
//                       onTap: AppController.to.willPopAction,
//                       child: Padding(
//                         padding: const EdgeInsets.only(left: 14),
//                         child: Text(
//                           '검색',
//                           style: kmain.copyWith(color: mainblue),
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ));
//   }
// }
