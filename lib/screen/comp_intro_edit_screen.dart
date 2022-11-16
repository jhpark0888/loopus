import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:loopus/api/profile_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/modal_controller.dart';
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
  CompanyIntroEditScreen({Key? key, required this.name}) : super(key: key);
  final CompIntroEditController _controller =
      Get.put(CompIntroEditController());

  String name;

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
      child: Scaffold(
        appBar: AppBarWidget(
          title: "기업 소개 수정",
          bottomBorder: false,
          actions: [
            TextButton(
                onPressed: () async {
                  if (_controller.isEmailCheck.value) {
                    await inquiryRequest(InquiryType.company_info,
                            email: _controller.emailController.text.trim(),
                            name: name)
                        .then((value) {
                      if (value.isError == false) {
                        Get.back();
                        showOneButtonDialog(
                            title: "입력하신 이메일을 확인해주세요",
                            startContent:
                                "해당 주소로 기업 소개 수정을 위한\n양식을 보내드렸어요\n확인 후 company@loopus.co.kr로\n답장주시면 빠른 시일 내 수정해드리겠습니다",
                            buttonFunction: () {
                              dialogBack();
                            },
                            buttonText: "확인");
                      }
                    });
                  }
                },
                child: Obx(
                  () => Text(
                    "확인",
                    style: MyTextTheme.navigationTitle(context).copyWith(
                        color: _controller.isEmailCheck.value
                            ? AppColors.mainblue
                            : AppColors.maingray),
                  ),
                )),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              LabelTextFieldWidget(
                label: "연락 받을 이메일 주소",
                hintText: "자료 송수신을 위해 연락 가능한 이메일을 입력해주세요",
                textController: _controller.emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "해당 이메일 주소로 기업 소개 수정을 위한 이메일이"
                  "\ncompany@loopus.co.kr로 발송되며,"
                  "\n수정 사항을 작성하여 메일 답장을 보내주시면, 빠른 시일"
                  "\n내 수정해 드리겠습니다. (평균 2~3일 내외)",
                  style: MyTextTheme.mainheight(context)
                      .copyWith(color: AppColors.maingray),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
