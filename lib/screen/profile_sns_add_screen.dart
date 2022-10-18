import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/profile_sns_add_controller.dart';
import 'package:loopus/model/sns_model.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/custom_textfield.dart';
import 'package:loopus/widget/label_textfield_widget.dart';

class ProfileSnsAddScreen extends StatelessWidget {
  ProfileSnsAddScreen({Key? key, required this.snsList}) : super(key: key);
  RxList<SNS> snsList;
  late final ProfileSnsAddController _controller =
      Get.put(ProfileSnsAddController(snsList: snsList));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: "SNS 추가하기",
        bottomBorder: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "SNS",
              style: kmainbold,
            ),
            const SizedBox(
              height: 14,
            ),
            ListView.separated(
                primary: false,
                shrinkWrap: true,
                itemBuilder: (context, index) =>
                    snsRowWidget(SNSType.values[index]),
                separatorBuilder: (context, index) => const SizedBox(
                      height: 14,
                    ),
                itemCount: SNSType.values.length)
          ],
        ),
      ),
    );
  }

  Widget snsRowWidget(SNSType snsType) {
    return GestureDetector(
      onTap: () {
        _controller.currentSNSType = snsType;
        Get.to(() => ProfileSnsInputScreen(
              snsType: snsType,
            ));
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            "assets/illustrations/${snsType.name}_image.png",
            fit: BoxFit.cover,
            width: 24,
            height: 24,
          ),
          const SizedBox(
            width: 14,
          ),
          Text(
            "${snsType.snsEngtoKor} ${snsType == SNSType.naver ? "블로그 " : ""}"
            "${snsList.any((element) => element.snsType == snsType) ? "수정하기" : "추가하기"}",
            style: kmain.copyWith(color: mainblue),
          ),
        ],
      ),
    );
  }
}

class ProfileSnsInputScreen extends StatelessWidget {
  ProfileSnsInputScreen({Key? key, required this.snsType}) : super(key: key);

  final ProfileSnsAddController _controller = Get.find();
  final SNSType snsType;
  final _formKey = GlobalKey<FormState>();

  String _snsInputTypePost(SNSType snsType) {
    switch (snsType) {
      case SNSType.instagram:
      case SNSType.github:
      case SNSType.naver:
        return "를";
      case SNSType.notion:
      case SNSType.youtube:
        return "을";
    }
  }

  @override
  Widget build(BuildContext context) {
    // snskorname = snsEngtoKor(snsType);
    // inputType = snsInputType(snsType);
    if (_controller.snsList.any((element) => element.snsType == snsType)) {
      _controller.snsController.text = _controller.snsList
          .where((element) => element.snsType == snsType)
          .first
          .url;
    }

    return KeyboardDismissOnTap(
      child: Scaffold(
        appBar: AppBarWidget(
          title:
              "${snsType.snsEngtoKor} ${snsType == SNSType.naver ? "블로그" : ""} ${_controller.snsList.any((element) => element.snsType == snsType) ? "수정" : "추가"}",
          bottomBorder: false,
          actions: [
            TextButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _controller.snsAdd(SNS(
                        snsType: snsType,
                        url: snsType.snsUrl + _controller.snsController.text));
                  }
                },
                child: Obx(
                  () => Text(
                    "확인",
                    style: kNavigationTitle.copyWith(
                        color: _controller.isButtonActive.value
                            ? mainblue
                            : maingray),
                  ),
                ))
          ],
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LabelTextFieldWidget(
                    label:
                        "본인 ${snsType.snsEngtoKor} ${snsType.snsInputType} 입력",
                    labelBold: true,
                    hintText:
                        "${snsType.snsEngtoKor} ${snsType.snsInputType}${_snsInputTypePost(snsType)} 입력하면 자동으로 ${snsType == SNSType.naver ? "블로그" : snsType.snsEngtoKor}에 연결됩니다.",
                    textController: _controller.snsController,
                    validator: (value) => _controller.validateUrl(value!))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
