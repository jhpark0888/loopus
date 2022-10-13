import 'package:flutter/material.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/search_text_field_widget.dart';

class SelectCareerGroupMemberScreen extends StatelessWidget {
  SelectCareerGroupMemberScreen({Key? key}) : super(key: key);
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: '함께하는 친구 추가',
        actions: [
          IconButton(
              padding: const EdgeInsets.only(left: 0, right: 12.5),
              onPressed: () {},
              icon: const Text(
                '확인',
                style: kNavigationTitle,
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        child: Column(children: [
          searchField(),
          const SizedBox(height: 24),
          memberList(context)

        ]),
      ),
    );
  }
  Widget searchField(){
    return SearchTextFieldWidget(
              ontap: () {},
              hinttext: '검색',
              readonly: false,
              controller: searchController);
  }
  Widget memberList(BuildContext context){
    return Expanded(child: ListView.builder(itemBuilder: (context,index){return Container(decoration: BoxDecoration(color: mainblack),width: 40,height: 40,);}, itemCount: 2,));
  }
}
