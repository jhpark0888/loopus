import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/widget/appbar_widget.dart';

class ReportScreen extends StatelessWidget {
  ReportScreen({Key? key}) : super(key: key);
  TextEditingController reportController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: "신고하기",
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/icons/Close.svg',
          ),
          onPressed: () {
            Get.back();
          },
        ),
        actions: [
          TextButton(
              onPressed: () {
                print("신고");
              },
              child: Text(
                "제출",
                style: TextStyle(color: Colors.red),
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(
          32,
          24,
          32,
          40,
        ),
        child: Column(
          children: [
            Text(
              '신고 사유를 적어주세요',
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, height: 1.5),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              '허위 신고라고 판단될 시 서비스 이용이 제한될 수 있어요.',
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
              ),
            ),
            SizedBox(
              height: 32,
            ),
            TextFormField(
              minLines: 1,
              maxLines: 2,
              maxLength: 32,
              autocorrect: false,
              cursorWidth: 1.5,
              cursorRadius: Radius.circular(2),
              style: TextStyle(
                color: mainblack,
                fontWeight: FontWeight.bold,
                height: 1.5,
              ),
              cursorColor: mainblack,
              controller: reportController,
              decoration: InputDecoration(
                hintText: '신고 사유...',
                hintStyle: TextStyle(
                  color: mainblack.withOpacity(0.38),
                  fontWeight: FontWeight.bold,
                  height: 1.5,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(2),
                  borderSide: BorderSide(color: mainblack, width: 1),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(2),
                  borderSide: BorderSide(color: mainblack, width: 1),
                ),
                errorBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(2),
                  borderSide: BorderSide(color: mainpink, width: 1),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
