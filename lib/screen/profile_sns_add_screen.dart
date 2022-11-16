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
        title: "SNS 추가",
        bottomBorder: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "SNS",
              style: MyTextTheme.mainbold(context),
            ),
            const SizedBox(
              height: 24,
            ),
            ListView.separated(
                primary: false,
                shrinkWrap: true,
                itemBuilder: (context, index) =>
                    snsRowWidget(context, SNSType.values[index]),
                separatorBuilder: (context, index) => const SizedBox(
                      height: 24,
                    ),
                itemCount: SNSType.values.length)
          ],
        ),
      ),
    );
  }

  Widget snsRowWidget(BuildContext context, SNSType snsType) {
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
            width: 36,
            height: 36,
          ),
          const SizedBox(
            width: 16,
          ),
          Obx(
            () => Text(
              "${snsType.snsEngtoKor} ${snsType == SNSType.naver ? "블로그 " : ""}"
              "${_controller.snsList.any((element) => element.snsType == snsType) ? "수정하기" : "추가하기"}",
              style:
                  MyTextTheme.main(context).copyWith(color: AppColors.mainblue),
            ),
          ),
          const Spacer(),
          Obx(
            () =>
                _controller.snsList.any((element) => element.snsType == snsType)
                    ? GestureDetector(
                        onTap: () {
                          _controller.snsDelete(snsList
                              .where((element) => element.snsType == snsType)
                              .first);
                        },
                        child: Text(
                          "삭제",
                          style: MyTextTheme.main(context)
                              .copyWith(color: AppColors.maingray),
                        ),
                      )
                    : Container(),
          )
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
    // if (_controller.snsList.any((element) => element.snsType == snsType)) {
    //   _controller.snsController.text = _controller.snsList
    //       .where((element) => element.snsType == snsType)
    //       .first
    //       .url;
    // }

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
                        id: 0,
                        snsType: snsType,
                        url: snsType.snsUrl + _controller.snsController.text));
                  }
                },
                child: Obx(
                  () => Text(
                    "확인",
                    style: MyTextTheme.navigationTitle(context).copyWith(
                        color: _controller.isButtonActive.value
                            ? AppColors.mainblue
                            : AppColors.maingray),
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
                const SizedBox(
                  height: 24,
                ),
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
