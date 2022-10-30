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

  Widget searchResult({Univ? univ, Dept? dept}) {
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
          style: kmain,
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
          title: searchType == UnivDeptSearchType.univ ? "대학 검색" : "학과 검색",
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
                  hinttext: "검색",
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
                                                  "\"${searchController.text.trim()}\"에 대한 검색 결과가 없습니다")
                                          : ScrollNoneffectWidget(
                                              child: ListView.separated(
                                                itemBuilder: (context, index) {
                                                  return searchType ==
                                                          UnivDeptSearchType
                                                              .univ
                                                      ? searchResult(
                                                          univ: _signupController
                                                                  .searchUnivList[
                                                              index])
                                                      : searchResult(
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
                  showTextFieldDialog2(
                    title:
                        "${searchType == UnivDeptSearchType.univ ? "대학" : "학과"} 등록 문의하기",
                    completeText: '문의하기',
                    hintText:
                        '찾으시는 ${searchType == UnivDeptSearchType.univ ? "대학" : "학과"}명을 입력해주세요. 빠른 시일 내 업데이트 할게요.',
                    leftFunction: () {
                      dialogBack();
                    },
                    rightFunction: () async {
                      //학교 이름과 학과 문의하기
                      await inquiryRequest(
                              searchType == UnivDeptSearchType.univ
                                  ? InquiryType.school
                                  : InquiryType.department,
                              content: textController.text)
                          .then((value) {
                        if (value.isError == false) {
                          dialogBack();
                          showCustomDialog(
                              "문의하기가 완료 됐어요 \n 빠른 시일 내 처리해 드릴게요", 1000);
                        } else {
                          errorSituation(value);
                        }
                      });
                    },
                    textEditingController: textController,
                  );
                },
                child: Text(
                    "찾으시는 ${searchType == UnivDeptSearchType.univ ? "대학이" : "학과가"} 없으신가요?",
                    style: kmain.copyWith(color: mainblue)),
              ),
              // const SizedBox(height: 40)
            ],
          ),
        ),
      ),
    );
  }
}
