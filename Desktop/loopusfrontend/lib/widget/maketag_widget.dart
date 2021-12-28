import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MakeTagWidget extends StatelessWidget {
  MakeTagWidget({
    Key? key,
    required this.tag,
  }) : super(key: key);

  String tag;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {},
      leading: Icon(Icons.local_offer),
      title: Text(
        '$tag',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
