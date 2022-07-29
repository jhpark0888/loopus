import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:loopus/constant.dart';

class CompanyImageWidget extends StatelessWidget {
  CompanyImageWidget(
      {Key? key, required this.imageUrl, this.width, this.height})
      : super(key: key);

  String imageUrl;
  double? width;
  double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: dividegray, width: 1),
      ),
      child: imageUrl == ''
          ? Image.asset(
              "assets/illustrations/default_company.png",
              height: height ?? 50,
              width: width ?? 50,
              fit: BoxFit.cover,
            )
          : CachedNetworkImage(
              imageUrl: imageUrl,
              height: height ?? 50,
              width: width ?? 50,
              fit: BoxFit.cover,
              placeholder: (context, string) {
                return Container(
                  height: height ?? 50,
                  width: width ?? 50,
                  color: dividegray,
                );
              },
            ),
    );
  }
}
