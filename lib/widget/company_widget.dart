import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/model/company_model.dart';
import 'package:loopus/screen/other_company_screen.dart';
import 'package:loopus/widget/Link_widget.dart';
import 'package:loopus/widget/follow_button_widget.dart';
import 'package:loopus/widget/user_image_widget.dart';

class CompanyWidget extends StatelessWidget {
  CompanyWidget({Key? key, required this.company}) : super(key: key);

  Company company;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _onTap(),
      behavior: HitTestBehavior.translucent,
      child: Column(
        children: [
          Container(
            width: Get.width,
            height: 160,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.maingray,
                width: 0.5,
              ),
            ),
            clipBehavior: Clip.hardEdge,
            child: company.images.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: company.images[0].image,
                    fit: BoxFit.cover,
                    errorWidget: (context, string, widget) {
                      return Container(
                        color: AppColors.maingray,
                      );
                    },
                  )
                : Container(
                    color: AppColors.maingray,
                  ),
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              UserImageWidget(
                imageUrl: company.profileImage,
                height: 36,
                width: 36,
                userType: company.userType,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      company.name,
                      style: MyTextTheme.main(context),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          fieldList[company.fieldId]!,
                          style: MyTextTheme.main(context)
                              .copyWith(color: AppColors.maingray),
                        ),
                        const Spacer(),
                        RichText(
                            text: TextSpan(children: [
                          TextSpan(
                              text: "?????? ",
                              style: MyTextTheme.main(context)
                                  .copyWith(color: AppColors.maingray)),
                          TextSpan(
                              text: "${company.itrCount}???",
                              style: MyTextTheme.main(context))
                        ]))
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _onTap() {
    Get.to(
        () => OtherCompanyScreen(
              companyId: company.userId,
              companyName: company.name,
              company: company,
            ),
        preventDuplicates: false);
  }
}

class CompanyTileWidget extends StatelessWidget {
  CompanyTileWidget({Key? key, required this.company, this.onCancelTap})
      : super(key: key);

  Company company;
  void Function()? onCancelTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          UserImageWidget(
            imageUrl: company.profileImage,
            width: 36,
            height: 36,
            userType: company.userType,
          ),
          const SizedBox(
            width: 8,
          ),
          Expanded(
            child: Text(
              company.name,
              style: MyTextTheme.mainbold(context),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          if (onCancelTap != null)
            GestureDetector(
              onTap: onCancelTap,
              child: SvgPicture.asset(
                'assets/icons/widget_delete.svg',
              ),
            )
        ],
      ),
    );
  }
}
