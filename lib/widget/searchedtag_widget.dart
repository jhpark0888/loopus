import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SearchTagWidget extends StatelessWidget {
  SearchTagWidget({Key? key, required this.tag, this.interesting})
      : super(key: key);

  String tag;
  String? interesting;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {},
      leading: Icon(Icons.local_offer),
      title: Text(
        '$tag',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        interesting != null ? '$interesting' : '',
        style: TextStyle(
          fontSize: 16,
        ),
      ),
    );
  }
}
