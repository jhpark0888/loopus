import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/screen/home_screen.dart';

class SearchTypingScreen extends StatefulWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(52.0);

  @override
  State<SearchTypingScreen> createState() => _SearchTypingScreenState();
}

class _SearchTypingScreenState extends State<SearchTypingScreen> {
  final FocusNode _focusNode = FocusNode();
  bool isFocused = true;

  @override
  void initState() {
    _focusListen();
    super.initState();
  }

  void _focusListen() {
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        isFocused = false;
      } else if (_focusNode.hasFocus) {
        isFocused = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 52,
          centerTitle: false,
          titleSpacing: 0,
          elevation: 0,
          backgroundColor: Colors.white,
          leading: Text(''),
          leadingWidth: 16,
          actions: [
            if (isFocused == true)
              TextButton(
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(
                    Colors.transparent,
                  ),
                ),
                onPressed: () => Get.back(),
                child: Center(
                  child: Text(
                    '취소',
                    style: TextStyle(
                      fontSize: 14,
                      color: mainblue,
                    ),
                  ),
                ),
              ),
            if (isFocused == false)
              SizedBox(
                width: 16,
              ),
          ],
          title: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            width: isFocused
                ? MediaQuery.of(context).size.width - 70
                : MediaQuery.of(context).size.width,
            curve: Curves.easeOut,
            height: 36,
            child: TextField(
                focusNode: _focusNode,
                style: TextStyle(color: mainblack, fontSize: 14),
                cursorColor: Colors.grey,
                cursorWidth: 1.5,
                cursorHeight: 14,
                cursorRadius: Radius.circular(5.0),
                autofocus: true,
                // focusNode: searchController.detailsearchFocusnode,
                textAlign: TextAlign.start,
                // selectionHeightStyle: BoxHeightStyle.tight,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: mainlightgrey,
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(8)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(8)),
                  // focusColor: Colors.black,
                  // border: OutlineInputBorder(borderSide: BorderSide.none),
                  contentPadding: EdgeInsets.only(right: 16),
                  isDense: true,
                  hintText: "어떤 정보를 찾으시나요?",
                  hintStyle: TextStyle(
                      fontSize: 14,
                      color: mainblack.withOpacity(0.6),
                      height: 1.5),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 10, 12, 10),
                    child: SvgPicture.asset(
                      "assets/icons/Search_Inactive.svg",
                      width: 16,
                      height: 16,
                      color: mainblack.withOpacity(0.6),
                    ),
                  ),
                )),
          ),
        ),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Container(
            color: mainWhite,
          ),
        ));
  }
}
