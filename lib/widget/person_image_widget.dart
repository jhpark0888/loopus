import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/hover_controller.dart';
import 'package:loopus/model/user_model.dart';

class PersonImageWidget extends StatelessWidget {
  PersonImageWidget({ Key? key, required this.user, this.width }) : super(key: key);
  User user;
  double? width;
  late final HoverController _hoverController =
      Get.put(HoverController(), tag: user.userid.toString());
  @override
  Widget build(BuildContext context) {
    return  ClipOval(
              child: user.profileImage == null
                  ? Obx(() => Opacity(
                        opacity: _hoverController.isHover.value ? 0.6 : 1,
                        child: Image.asset(
                          "assets/illustrations/default_profile.png",
                          width: 50,
                          height: 50,
                        ),
                      ))
                  : Obx(
                      () => Opacity(
                        opacity: _hoverController.isHover.value ? 0.6 : 1,
                        child: CachedNetworkImage(
                          height: width ?? 50,
                          width: width ?? 50,
                          imageUrl: user.profileImage!,
                          placeholder: (context, url) => kProfilePlaceHolder(),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
            );}
}