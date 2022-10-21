import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/my_company_controller.dart';
import 'package:loopus/utils/check_form_validate.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/label_textfield_widget.dart';

class CompIntroEditController extends GetxController {
  TextEditingController emailController = TextEditingController();
  RxBool isEmailCheck = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    emailController.addListener(() {
      isEmailCheck(CheckValidate.validateEmailBool(emailController.text));
    });
  }
}

class CompanyIntroEditScreen extends StatelessWidget {
  CompanyIntroEditScreen({Key? key}) : super(key: key);
  final CompIntroEditController _controller =
      Get.put(CompIntroEditController());

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
      child: Scaffold(
        appBar: AppBarWidget(
          title: "기업 소개 수정",
          bottomBorder: false,
          actions: [
            TextButton(
                onPressed: () {},
                child: Obx(
                  () => Text(
                    "보내기",
                    style: kNavigationTitle.copyWith(
                        color: _controller.isEmailCheck.value
                            ? mainblue
                            : maingray),
                  ),
                )),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              LabelTextFieldWidget(
                label: "연락 받을 이메일 주소",
                hintText: "자료 송수신을 위해 연락 가능한 이메일을 입력해주세요",
                textController: _controller.emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "해당 이메일 주소로 기업 소개 수정을 위한 이메일이"
                  "\ncompany@loopus.co.kr로 발송되며,"
                  "\n수정 사항을 작성하여 메일 답장을 보내주시면, 빠른 시일"
                  "\n내 수정해 드리겠습니다. (평균 2~3일 내외)",
                  style: kmainheight.copyWith(color: maingray),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
