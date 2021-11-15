import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  // const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Search',
        ),
      ),
      body: Container(
        color: Colors.amber,
      ),
    );
  }
}
