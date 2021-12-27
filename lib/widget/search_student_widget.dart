import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:loopus/constant.dart';

class SearchStudentWidget extends StatelessWidget {
  const SearchStudentWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {},
      leading: ClipOval(
        child: Image.asset("assets/illustrations/default_profile.png"),
      ),
      //     CachedNetworkImage(
      //   height: 56,
      //   width: 56,
      //   imageUrl: image ?? "https://i.stack.imgur.com/l60Hf.png",
      //   placeholder: (context, url) => const CircleAvatar(
      //     child: Center(child: CircularProgressIndicator()),
      //   ),
      //   fit: BoxFit.fill,
      // )),
      title: Text(
        '손승태',
        style: kSubTitle2Style,
      ),
      subtitle: Text(
        '산업경영공학과',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: mainblack.withOpacity(0.6),
          fontFamily: 'Nanum',
        ),
      ),
      trailing: Text('1,420점', style: kSubTitle2Style),
    );
  }
}
