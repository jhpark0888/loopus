import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';

class SearchTypingScreen extends StatelessWidget {
  const SearchTypingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Column(
            children: [
              // SizedBox(
              //   height: 5,
              // ),
              Container(
                height: 36,
                child: TextField(
                    style: TextStyle(color: Colors.black),
                    cursorColor: Colors.black,
                    autofocus: true,
                    // focusNode: searchController.detailsearchFocusnode,
                    textAlign: TextAlign.start,
                    // selectionHeightStyle: BoxHeightStyle.tight,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(8)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(8)),
                      // focusColor: Colors.black,
                      // border: OutlineInputBorder(borderSide: BorderSide.none),
                      contentPadding: EdgeInsets.all(9),
                      isDense: true,
                      hintText: "어떤 정보를 찾으시나요?",
                      hintStyle: TextStyle(fontSize: 14),
                      prefixIcon: Icon(
                        Icons.search,
                        size: 16,
                        color: Colors.black,
                      ),
                    )),
              ),
            ],
          ),
          automaticallyImplyLeading: false,
          toolbarHeight: 60,
        ),
        body: Container(
          color: mainWhite,
        ));
  }
}
