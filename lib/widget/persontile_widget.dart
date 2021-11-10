import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PersonTileWidget extends StatelessWidget {
  PersonTileWidget(
      {Key? key, required this.name, required this.department, this.image})
      : super(key: key);

  String name;
  String department;
  String? image;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {},
      leading: ClipOval(
          child: CachedNetworkImage(
        height: 56,
        width: 56,
        imageUrl: image ?? "https://i.stack.imgur.com/l60Hf.png",
        placeholder: (context, url) => const CircleAvatar(
          child: Center(child: CircularProgressIndicator()),
        ),
        fit: BoxFit.fill,
      )),
      title: Text(
        '$name',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        '$department',
        style: TextStyle(
          fontSize: 16,
        ),
      ),
    );
  }
}
