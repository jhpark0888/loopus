import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:loopus/constant.dart';

class SearchProfileWidget extends StatelessWidget {
  int id;
  String name;
  String department;
  var profileimage;
  SearchProfileWidget(
      {required this.name,
      required this.id,
      required this.department,
      required this.profileimage});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {},
      leading: profileimage == null
          ? ClipOval(
              child: Image.asset("assets/illustrations/default_profile.png"),
            )
          : CachedNetworkImage(
              height: 56,
              width: 56,
              imageUrl: profileimage,
              placeholder: (context, url) => const CircleAvatar(
                child: Center(child: CircularProgressIndicator()),
              ),
              fit: BoxFit.fill,
            ),
      title: Text(
        '$name',
        style: kSubTitle2Style,
      ),
      subtitle: Text(
        '$department',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: mainblack.withOpacity(0.6),
          fontFamily: 'Nanum',
        ),
      ),
    );
  }
}
