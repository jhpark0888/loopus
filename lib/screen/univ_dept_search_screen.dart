import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/api/profile_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/signup_controller.dart';
import 'package:loopus/model/univ_model.dart';
import 'package:loopus/screen/search_focus_screen.dart';
import 'package:loopus/utils/error_control.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/disconnect_reload_widget.dart';
import 'package:loopus/widget/divide_widget.dart';
import 'package:loopus/widget/empty_contents_widget.dart';
import 'package:loopus/widget/error_reload_widget.dart';
import 'package:loopus/widget/loading_widget.dart';
import 'package:loopus/widget/scroll_noneffect_widget.dart';
import 'package:loopus/widget/search_text_field_widget.dart';

enum UnivDeptSearchType { univ, dept }

class UnivDeptSearchScreen extends StatelessWidget {
  UnivDeptSearchScreen({Key? key, required this.searchType}) : super(key: key);

  final SignupController _signupController = Get.find();
  TextEditingController searchController = TextEditingController();
  UnivDeptSearchType searchType;

  Widget searchResult(BuildContext context, {Univ? univ, Dept? dept}) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (searchType == UnivDeptSearchType.univ) {
          _signupController.selectUniv(univ);
          _signupController.deptInit();
          _signupController.univcontroller.text = univ!.univname;
          _signupController.searchUnivList.clear();
        } else {
          _signupController.selectDept(dept);
          _signupController.departmentcontroller.text = dept!.deptname;
          _signupController.searchDeptList.clear();
        }
        Get.back();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 20),
        child: Text(
          searchType == UnivDeptSearchType.univ
              ? univ!.univname
              : dept!.deptname,
          style: MyTextTheme.main(context),
        ),
      ),
    );
  }

  void searchFunction() {
    if (searchController.text.trim().isNotEmpty) {
      if (searchType == UnivDeptSearchType.univ) {
        _signupController.searchUnivLoad(searchController.text.trim());
      } else {
        _signupController.searchDeptLoad(searchController.text.trim());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBarWidget(
            title: searchType == UnivDeptSearchType.univ ? "?????? ??????" : "?????? ??????",
            bottomBorder: false,
          ),
          body: SafeArea(
              child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                height: 36,
                child: SearchTextFieldWidget(
                  ontap: () {},
                  hinttext: "??????",
                  readonly: false,
                  autofocus: true,
                  controller: searchController,
                  onSubmitted: (text) {
                    searchFunction();
                  },
                  textInputAction: TextInputAction.search,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: Obx(
                  () => _signupController.searchscreenstate.value ==
                          ScreenState.normal
                      ? Container()
                      : _signupController.searchscreenstate.value ==
                              ScreenState.loading
                          ? const Center(child: LoadingWidget())
                          : _signupController.searchscreenstate.value ==
                                  ScreenState.disconnect
                              ? DisconnectReloadWidget(reload: searchFunction)
                              : _signupController.searchscreenstate.value ==
                                      ScreenState.error
                                  ? ErrorReloadWidget(reload: searchFunction)
                                  : Obx(
                                      () => (searchType ==
                                                      UnivDeptSearchType.univ
                                                  ? _signupController
                                                      .searchUnivList.isEmpty
                                                  : _signupController
                                                      .searchDeptList
                                                      .isEmpty) &&
                                              searchController.text.trim() != ""
                                          ? EmptyContentWidget(
                                              text:
                                                  "\"${searchController.text.trim()}\"??? ?????? ?????? ????????? ????????????")
                                          : ScrollNoneffectWidget(
                                              child: ListView.separated(
                                                itemBuilder: (context, index) {
                                                  return searchType ==
                                                          UnivDeptSearchType
                                                              .univ
                                                      ? searchResult(context,
                                                          univ: _signupController
                                                                  .searchUnivList[
                                                              index])
                                                      : searchResult(context,
                                                          dept: _signupController
                                                                  .searchDeptList[
                                                              index]);
                                                },
                                                separatorBuilder:
                                                    (context, index) =>
                                                        DivideWidget(
                                                  height: 1,
                                                ),
                                                itemCount: searchType ==
                                                        UnivDeptSearchType.univ
                                                    ? _signupController
                                                        .searchUnivList.length
                                                    : _signupController
                                                        .searchDeptList.length,
                                              ),
                                            ),
                                    ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  TextEditingController textController =
                      TextEditingController();
                  showTextFieldDialog(
                    title:
                        "${searchType == UnivDeptSearchType.univ ? "??????" : "??????"} ????????????",
                    rightText: '????????????',
                    rightBoxColor: AppColors.mainblue,
                    leftBoxColor: AppColors.maingray,
                    hintText:
                        '???????????? ${searchType == UnivDeptSearchType.univ ? "??????" : "??????"}?????? ??????????????????. ?????? ?????? ??? ???????????? ?????????.',
                    leftFunction: () {
                      dialogBack();
                    },
                    rightFunction: () async {
                      //?????? ????????? ?????? ????????????
                      await inquiryRequest(
                              searchType == UnivDeptSearchType.univ
                                  ? InquiryType.school
                                  : InquiryType.department,
                              content: textController.text)
                          .then((value) {
                        if (value.isError == false) {
                          dialogBack();
                          showCustomDialog(
                              "??????????????? ?????? ????????? \n ?????? ?????? ??? ????????? ????????????", 1000);
                        } else {
                          errorSituation(value);
                        }
                      });
                    },
                    textEditingController: textController,
                  );
                },
                child: Text(
                    "???????????? ${searchType == UnivDeptSearchType.univ ? "?????????" : "?????????"} ????????????????",
                    style: MyTextTheme.main(context)
                        .copyWith(color: AppColors.mainblue)),
              ),
              const SizedBox(
                height: 14,
              )
            ],
          ))),
    );
  }
}
