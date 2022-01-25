import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/tag_controller.dart';

class TagSearchWidget extends StatelessWidget {
  TagSearchWidget({Key? key}) : super(key: key);
  final TagController tagController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 16, left: 16, top: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '선택한 태그',
                style: kSubTitle2Style,
              ),
              Obx(
                () => Text(
                  '${tagController.selectedtaglist.length} / 3',
                  style: kSubTitle2Style,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        //TODO : 태그 삭제하고 검색 탭 눌렀을 때 초기화되는 오류 수정
        Container(
          height: 32,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 1,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(
                      left: (index == 0) ? 16 : 0,
                      right: (index == 0) ? 16 : 0),
                  child: Obx(
                      () => Row(children: tagController.selectedtaglist.value)),
                );
              }),
        ),
        SizedBox(
          height: 16,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            focusNode: tagController.tagsearchfocusNode,
            controller: tagController.tagsearch,
            style: kBody2Style,
            cursorColor: Colors.grey,
            cursorWidth: 1.2,
            cursorRadius: Radius.circular(5.0),

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
              hintStyle: kBody2Style.copyWith(
                  color: mainblack.withOpacity(0.38), height: 1.5),
              isDense: true,
              hintText: "예) 봉사, 기계공학과, 서포터즈",
              prefixIcon: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
                child: SvgPicture.asset(
                  "assets/icons/Search_Inactive.svg",
                  width: 16,
                  height: 16,
                  color: mainblack.withOpacity(0.6),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 12,
        ),
        Obx(
          () => Expanded(
            child: ListView(
              children: tagController.searchtaglist,
            ),
          ),
        )
      ],
    );
  }
}
