import 'package:flutter/material.dart';

class SearchTypingScreen extends StatelessWidget {
  const SearchTypingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Column(
            children: [
              Container(
                height: 3,
              ),
              TextField(
                  style: TextStyle(color: Colors.black),
                  cursorColor: Colors.black,
                  autofocus: true,
                  // focusNode: searchController.detailsearchFocusnode,
                  textAlign: TextAlign.start,
                  // selectionHeightStyle: BoxHeightStyle.tight,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 1.5),
                          borderRadius: BorderRadius.circular(15)),
                      focusColor: Colors.black,
                      contentPadding: EdgeInsets.all(10),
                      isDense: true,
                      hintText: "검색",
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.black,
                      ),
                      border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black)))),
            ],
          ),
          automaticallyImplyLeading: false,
          toolbarHeight: 70,
        ),
        body: Column(
          children: [
            Container(
              height: 30,
              color: Colors.red,
            )
          ],
        ));
  }
}
