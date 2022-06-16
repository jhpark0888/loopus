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
      child: CachedNetworkImage(
        imageUrl: imageUrl == ''
            ? 'https://cdn.pixabay.com/photo/2021/12/04/04/44/woman-6844349__340.jpg'
            : imageUrl,
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
