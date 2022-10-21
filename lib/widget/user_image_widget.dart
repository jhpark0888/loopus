import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:loopus/constant.dart';

class UserImageWidget extends StatelessWidget {
  UserImageWidget(
      {Key? key,
      required this.imageUrl,
      this.width,
      this.height,
      required this.userType})
      : super(key: key);

  String imageUrl;
  double? width;
  double? height;
  UserType userType;

  Widget imageShape(Widget child) {
    return userType == UserType.student
        ? ClipOval(
            child: child,
          )
        : ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: child,
          );
  }

  @override
  Widget build(BuildContext context) {
    return imageShape(
      imageUrl == ""
          ? Image.asset(
              userType == UserType.student
                  ? "assets/illustrations/default_profile.png"
                  : "assets/illustrations/default_company.png",
              height: height ?? 50,
              width: width ?? 50,
              fit: BoxFit.cover,
            )
          : CachedNetworkImage(
              imageUrl: imageUrl,
              height: height ?? 50,
              width: width ?? 50,
              fit: userType == UserType.student ? BoxFit.cover : BoxFit.contain,
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
