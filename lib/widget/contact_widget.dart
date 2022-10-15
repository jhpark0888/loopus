import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/scout_report_controller.dart';
import 'package:loopus/model/company_model.dart';
import 'package:loopus/model/contact_model.dart';
import 'package:loopus/screen/other_profile_screen.dart';
import 'package:loopus/utils/duration_calculate.dart';
import 'package:loopus/widget/company_image_widget.dart';
import 'package:loopus/widget/user_image_widget.dart';
import 'package:loopus/controller/home_controller.dart';
import 'package:palette_generator/palette_generator.dart';

class CompanyFollowWidget extends StatelessWidget {
  CompanyFollowWidget({Key? key, required this.contact}) : super(key: key);

  Contact contact;

  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(contact.category, style: kmainbold),
        SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                children: <Widget>[
                  Container(height: 167.5, width: 335, color: Colors.grey),
                  const SizedBox(height: 14),
                  Expanded(
                      child: Row(
                    children: [
                      SizedBox(width: 20),
                      CompanyImageWidget(
                          imageUrl: contact.companyImage,
                          width: 40,
                          height: 40),
                      Expanded(
                        child: Column(
                          children: [
                            Text(contact.companyProfile.companyName,
                                style: kmain),
                            SizedBox(height: 7),
                            // Text(
                            //   contact.contactField.split(",").first,
                            //   style: kmainheight.copyWith(color: maingray),
                            // )
                          ],
                        ),
                      ),
                      Expanded(
                          child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8)),
                          height: 36,
                          width: 64,
                          color: mainblue,
                          child: Text(
                            "팔로우",
                            style: kmainheight.copyWith(color: mainWhite),
                          ),
                        ),
                      ))
                    ],
                  ))
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}

// class CompanyRecWidget extends StatelessWidget {
//    CompanyRecWidget({Key? key, required this.contact})
//       : super(key: key);
//  final ScoutReportController _scontroller = Get.put(ScoutReportController());
//   PageController _pController =
//       PageController(viewportFraction: 0.7, initialPage: 0);

//   final List<String> images = [];

//   late List<PaletteColor> colors;

//   late int _currentIndex;

//   @override
//   void initState() {
//     super.initState();
//     colors = [];
//     _currentIndex = 0;
//     _updatePalettes();
//   }

//   _updatePalettes() async {
//     for (String image in images) {
//       final PaletteGenerator generator =
//           await PaletteGenerator.fromImageProvider(
//         AssetImage(image),
//         size: Size(200, 100),
//       );
//       colors.add(generator.lightMutedColor ?? PaletteColor(Colors.blue, 2));
//     }
//     setState(() {});
//   }

 
//   Contact contact;
//  List<String> images = _scontroller.recommandCompList
//         .map((company) => company.companyImage)
//         .toList();

//   @override
//   Widget build(BuildContext context) {
//   return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text("당신에게 '집-중'하고 있는 추천 기업",
//             style: kmainbold.copyWith(color: mainWhite)),
//         SizedBox(height: 14),
//         Text(contact.slogan,
//         style: kNavigationTitle.copyWith(color: mainWhite)),
//         SizedBox(height: 14),
//         // Text(contact.slogan, style: kmain.copyWith(color: mainWhite)),
//         // SizedBox(height: 24),
//         Container(
//           width: double.infinity,
//           height: 200,
//           color: colors.isNotEmpty ? colors[_currentIndex].color : Colors.white,
//           child: Stack(
//             children: [
//               Positioned(
//                 top: 70,
//                 child: Container(
//                   width: double.infinity,
//                   height: 120,
//                   child: PageView(
//                     controller: _pController,
//                     onPageChanged: (index) {
//                       setState(() {
//                         _currentIndex = index;
//                       });
//                     },
//                     children: images
//                         .map((image) => Container(
//                               width: 321,
//                               height: 120,
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 14),
//                               margin: const EdgeInsets.symmetric(horizontal: 7),
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(8.0),
//                                 image: DecorationImage(
//                                     image: AssetImage(image),
//                                     fit: BoxFit.cover),
//                               ),
//                             ))
//                         .toList(),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }