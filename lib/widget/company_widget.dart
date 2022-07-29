import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/model/company_model.dart';
import 'package:loopus/widget/company_image_widget.dart';

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
          CompanyImageWidget(
            imageUrl: company.companyImage,
            height: 60,
            width: 60,
          ),
          const SizedBox(width: 24),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(company.companyName),
              const SizedBox(height: 7),
              RichText(
                  text: TextSpan(children: [
                TextSpan(
                    text: company.contactField,
                    style: k15normal.copyWith(color: mainblue)),
                const TextSpan(text: ' 분야 컨택 중', style: k15normal)
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
          CompanyImageWidget(
            imageUrl: company.companyImage,
            width: 36,
            height: 36,
          ),
          const SizedBox(
            width: 14,
          ),
          Expanded(
            child: Text(
              company.companyName,
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
                'assets/icons/Close.svg',
              ),
            )
        ],
      ),
    );
  }
}
