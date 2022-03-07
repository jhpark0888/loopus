// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:loopus/api/profile_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/withdrawal_controller.dart';
import 'package:loopus/utils/check_form_validate.dart';
import 'package:loopus/widget/appbar_widget.dart';

class WithdrawalScreen extends StatelessWidget {
  WithdrawalScreen({Key? key}) : super(key: key);

  WithDrawalController _controller = Get.put(WithDrawalController());

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBarWidget(
            bottomBorder: false,
            title: '회원탈퇴',
            actions: [
              TextButton(
                onPressed: () {
                  TextEditingController pwcontroller = TextEditingController();
                  ModalController.to.showTextFieldDialog(
                      isWithdrawal: true,
                      title: "현재 비밀번호를 입력해주세요",
                      hintText: "8자리 이상",
                      textEditingController: pwcontroller,
                      obscureText: true,
                      validator: (value) =>
                          CheckValidate().validatePassword(value!),
                      leftFunction: () => Get.back(),
                      rightFunction: () {
                        FocusScope.of(context).unfocus();
                        _controller.iswithdrawalloading(true);
                        Get.back();
                        deleteuser(pwcontroller.text).then((value) {
                          _controller.iswithdrawalloading(false);
                        });
                      });
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Text(
                    '탈퇴하기',
                    style: kSubTitle2Style.copyWith(color: mainpink),
                  ),
                ),
              ),
            ],
          ),
          body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                32,
                24,
                32,
                40,
              ),
              child: Column(
                children: [
                  Text(
                    '탈퇴 사유를 선택해주세요',
                    style: kSubTitle1Style,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ListView(
                    shrinkWrap: true,
                    children: _controller.reasonlist,
                  ),

                  // CustomTextField(
                  //   counterText: null,
                  //   maxLength: null,
                  //   textController: null,
                  //   hintText: '탈퇴 사유...',
                  //   validator: null,
                  //   obscureText: false,
                  //   maxLines: 5,
                  // ),
                ],
              ),
            ),
          ),
        ),
        if (_controller.iswithdrawalloading.value == true)
          Container(
            height: Get.height,
            width: Get.width,
            color: mainblack.withOpacity(0.3),
            child: Image.asset(
              'assets/icons/loading.gif',
              scale: 6,
            ),
          ),
      ],
    );
  }
}

class SelectedOptionWidget extends StatelessWidget {
  SelectedOptionWidget({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;
  RxBool isSelected = false.obs;
  void selectOption() {
    isSelected.value = !isSelected.value;
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(text),
            Obx(
              () => GestureDetector(
                onTap: selectOption,
                child: isSelected.value
                    ? SvgPicture.asset(
                        "assets/icons/check_box_active.svg",
                        width: 24,
                        height: 24,
                      )
                    : SvgPicture.asset(
                        "assets/icons/check_box_inactive.svg",
                        width: 24,
                        height: 24,
                      ),
              ),
            ),
          ],
        ),
      ),
      Divider()
    ]);
  }
}
