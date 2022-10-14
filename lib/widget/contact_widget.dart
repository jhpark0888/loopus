import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/model/company_model.dart';
import 'package:loopus/model/contact_model.dart';
import 'package:loopus/screen/other_profile_screen.dart';
import 'package:loopus/utils/duration_calculate.dart';
import 'package:loopus/widget/company_image_widget.dart';
import 'package:loopus/widget/user_image_widget.dart';
import 'package:loopus/controller/home_controller.dart';

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
