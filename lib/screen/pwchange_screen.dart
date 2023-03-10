import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/api/login_api.dart';
import 'package:loopus/api/profile_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/pwchange_controller.dart';
import 'package:loopus/screen/loading_screen.dart';
import 'package:loopus/screen/pw_find_screen.dart';
import 'package:loopus/utils/check_form_validate.dart';
import 'package:loopus/utils/error_control.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/custom_expanded_button.dart';
import 'package:loopus/widget/custom_textfield.dart';
import 'package:loopus/widget/label_textfield_widget.dart';
import 'package:loopus/widget/signup_text_widget.dart';

class PwChangeScreen extends StatelessWidget {
  PwChangeScreen({Key? key, required this.pwType}) : super(key: key);
  final PwChangeController _pwChangeController = Get.put(PwChangeController());

  PwType pwType;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        bottomNavigationBar: BottomAppBar(
          color: AppColors.mainWhite,
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Obx(() => _pwChangeController.pwcertification.value ==
                        Emailcertification.waiting
                    ? _pwChangeController.timer.timerDisplay(context)
                    : Container()),
                const SizedBox(
                  height: 24,
                ),
                Row(
                  children: [
                    Expanded(
                      child: CustomExpandedButton(
                          onTap: () {
                            Get.back();
                          },
                          isBlue: false,
                          title: "??????",
                          isBig: true),
                    ),
                    const SizedBox(
                      width: 14,
                    ),
                    Expanded(
                      child: Obx(
                        () => CustomExpandedButton(
                            onTap: () {
                              if (_pwChangeController.pwChangeButtonOn.value) {
                                if (_formKey.currentState!.validate()) {
                                  loading();
                                  pwType == PwType.pwchange
                                      ? putpwchange().then((value) {
                                          if (value.isError == false) {
                                            getbacks(2);
                                            showCustomDialog(
                                                '???????????? ????????? ?????????????????????', 1400);
                                          } else {
                                            Get.back();

                                            if (value
                                                    .errorData!["statusCode"] ==
                                                401) {
                                              showCustomDialog(
                                                  '?????? ??????????????? ???????????????.', 1400);
                                            } else {
                                              errorSituation(value);
                                            }
                                          }
                                        })
                                      : putpwfindchange().then((value) {
                                          if (value.isError == false) {
                                            getbacks(3);
                                            showCustomDialog(
                                                '???????????? ????????? ?????????????????????', 1400);
                                          } else {
                                            Get.back();
                                            if (value
                                                    .errorData!["statusCode"] ==
                                                401) {
                                              showCustomDialog(
                                                  '????????? ????????? ?????? ??????????????????', 1400);
                                            } else {
                                              errorSituation(value);
                                            }
                                          }
                                        });
                                }
                              }
                            },
                            isBlue: _pwChangeController.pwChangeButtonOn.value,
                            title: "????????????",
                            isBig: true),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SignUpTextWidget(
                    oneLinetext: "??????????????? ??????",
                    twoLinetext: "6?????? ??????????????? ?????????",
                  ),
                  pwType == PwType.pwchange
                      ? Column(
                          children: [
                            LabelTextFieldWidget(
                              label: "?????? ????????????",
                              hintText: "?????? 6??????",
                              textController:
                                  _pwChangeController.originpwcontroller,
                              // validator: (value) =>
                              //     CheckValidate().validatePassword(value!),
                              obscureText: true,
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                          ],
                        )
                      : Container(),
                  LabelTextFieldWidget(
                    label: "????????? ????????????",
                    hintText: "?????? 6??????",
                    textController: _pwChangeController.newpwcontroller,
                    // validator: (value) =>
                    //     CheckValidate().validatePassword(value!),
                    obscureText: true,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  LabelTextFieldWidget(
                    label: "????????? ???????????? ??????",
                    hintText: "?????? ??? ??? ??????????????????",
                    textController: _pwChangeController.newpwcheckcontroller,
                    validator: (value) {
                      if (value != _pwChangeController.newpwcontroller.text) {
                        return "???????????? ??????????????? ????????????. ?????? ??????????????????";
                      } else {
                        return null;
                      }
                    },
                    obscureText: true,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  GestureDetector(
                      onTap: () {
                        Get.to(() => PwFindScreen());
                      },
                      child: Center(
                        child: Text(
                          "??????????????? ????????????????",
                          style: MyTextTheme.main(context).copyWith(
                            color: AppColors.maingray,
                          ),
                        ),
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
