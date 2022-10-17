import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/model/company_model.dart';
import 'package:loopus/trash_bin/company_image_widget.dart';
import 'package:loopus/widget/user_image_widget.dart';

class CompanyWidget extends StatelessWidget {
  CompanyWidget({Key? key, required this.company}) : super(key: key);

  Company company;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 265,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: lightcardgray, borderRadius: BorderRadius.circular(16)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          UserImageWidget(
            imageUrl: company.profileImage,
            height: 60,
            width: 60,
            userType: company.userType,
          ),
          const SizedBox(width: 24),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(company.name),
              const SizedBox(height: 7),
              RichText(
                  text: TextSpan(children: [
                TextSpan(
                    text: company.contactField,
                    style: kmainheight.copyWith(color: mainblue)),
                const TextSpan(text: ' 분야 컨택 중', style: kmainheight)
              ]))
            ],
          )
        ],
      ),
    );
  }
}

class CompanyTileWidget extends StatelessWidget {
  CompanyTileWidget({Key? key, required this.company, this.onTap})
      : super(key: key);

  Company company;
  void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Row(
        children: [
          UserImageWidget(
            imageUrl: company.profileImage,
            width: 36,
            height: 36,
            userType: company.userType,
          ),
          const SizedBox(
            width: 14,
          ),
          Expanded(
            child: Text(
              company.name,
              style: kmainbold,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(
            width: 14,
          ),
          if (onTap != null)
            GestureDetector(
              onTap: onTap,
              child: SvgPicture.asset(
                'assets/icons/appbar_exit.svg',
              ),
            )
        ],
      ),
    );
  }
}
