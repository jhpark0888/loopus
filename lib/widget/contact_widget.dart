import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/model/company_model.dart';
import 'package:loopus/model/contact_model.dart';
import 'package:loopus/screen/other_profile_screen.dart';
import 'package:loopus/utils/duration_calculate.dart';
import 'package:loopus/widget/company_image_widget.dart';
import 'package:loopus/widget/user_image_widget.dart';

class CompanyFollowWidget extends StatelessWidget {
  CompanyFollowWidget({Key? key, required this.company}) : super(key: key);

  Company company;

  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
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
                    children: <Widget>[
                      CompanyImageWidget(imageUrl: company.companyImage),
                      SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          children: [
                            Text(company.companyName, style: kmain),
                            Text(
                              company.contactField.split(",").first,
                              style: kmainheight.copyWith(color: maingray),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                          child: GestureDetector(
                        child: Container(
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
