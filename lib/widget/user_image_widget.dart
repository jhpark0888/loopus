import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class UserImageWidget extends StatelessWidget {
  UserImageWidget({Key? key, required this.imageUrl, this.width, this.height})
      : super(key: key);

  String imageUrl;
  double? width;
  double? height;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: imageUrl == ''
          ? Image.asset(
              "assets/illustrations/default_profile.png",
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
                return Image.asset(
                  'assets/icons/loading.gif',
                  scale: 6,
                );
              },
            ),
    );
  }
}
