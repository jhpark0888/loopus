import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/project_add_controller.dart';
import 'package:loopus/model/company_model.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/company_widget.dart';
import 'package:loopus/widget/custom_header_footer.dart';
import 'package:loopus/widget/disconnect_reload_widget.dart';
import 'package:loopus/widget/empty_contents_widget.dart';
import 'package:loopus/widget/error_reload_widget.dart';
import 'package:loopus/widget/label_textfield_widget.dart';
import 'package:loopus/widget/loading_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ProjectAddCompanyScreen extends StatelessWidget {
  ProjectAddCompanyScreen({
    Key? key,
  }) : super(key: key);

  final ProjectAddController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBarWidget(
          bottomBorder: false,
          title: '기업 선택',
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 16,
            ),
            Text(
              "어떤 기업과 함께했나요?",
              style: kmain.copyWith(color: maingray),
            ),
            const SizedBox(
              height: 16,
            ),
            LabelTextFieldWidget(
              label: "기업 이름",
              hintText: "기업 이름을 입력하세요",
              textController: _controller.companyController,
              textInputAction: TextInputAction.search,
              onfieldSubmitted: (value) {
                if (value.trim() != "") {
                  _controller.companySearchState(ScreenState.loading);
                  _controller.companyPageNum = 1;
                  _controller.searchCompanyList.clear();
                  _controller.compRefreshController.loadComplete();
                  _controller.careerCompSearch();
                }
              },
            ),
            const SizedBox(
              height: 16,
            ),
            Expanded(
              child: Obx(
                () => _controller.companySearchState.value == ScreenState.normal
                    ? Container()
                    : _controller.companySearchState.value ==
                            ScreenState.loading
                        ? const Center(child: LoadingWidget())
                        : _controller.companySearchState.value ==
                                ScreenState.disconnect
                            ? DisconnectReloadWidget(
                                reload: _controller.careerCompSearch)
                            : _controller.companySearchState.value ==
                                    ScreenState.error
                                ? ErrorReloadWidget(
                                    reload: _controller.careerCompSearch)
                                : Obx(
                                    () => _controller
                                                .searchCompanyList.isEmpty &&
                                            _controller.companyController.text
                                                    .trim() !=
                                                ""
                                        ? Column(
                                            children: [
                                              EmptyContentWidget(
                                                  text:
                                                      "\"${_controller.companyController.text.trim()}\"에 대한 검색 결과가 없습니다"),
                                              const SizedBox(
                                                height: 16,
                                              ),
                                              // Obx(() => _controller
                                              //         .onRegisterButton.value
                                              //     ? Center(
                                              //         child: GestureDetector(
                                              //           onTap: () {
                                              //             _controller.selectCompany(
                                              //                 Company.defaultCompany(
                                              //                     name: _controller
                                              //                         .companyController
                                              //                         .text
                                              //                         .trim()));
                                              //             _controller
                                              //                 .companyController
                                              //                 .clear();
                                              //             Get.back();
                                              //           },
                                              //           child: Text(
                                              //               "입력한 기업으로 등록하기",
                                              //               style: kmain.copyWith(
                                              //                   color:
                                              //                       mainblue)),
                                              //         ),
                                              //       )
                                              //     : Container())
                                            ],
                                          )
                                        : SmartRefresher(
                                            controller: _controller
                                                .compRefreshController,
                                            onLoading: _controller.onLoading,
                                            enablePullDown: false,
                                            enablePullUp: true,
                                            footer: const MyCustomFooter(),
                                            child: ListView.separated(
                                              primary: false,
                                              shrinkWrap: true,
                                              itemBuilder: (context, index) {
                                                // if (_controller.onRegisterButton
                                                //         .value &&
                                                //     index ==
                                                //         _controller
                                                //             .searchCompanyList
                                                //             .length) {
                                                //   return Center(
                                                //     child: GestureDetector(
                                                //       onTap: () {
                                                //         _controller.selectCompany(
                                                //             Company.defaultCompany(
                                                //                 name: _controller
                                                //                     .companyController
                                                //                     .text
                                                //                     .trim()));
                                                //         _controller
                                                //             .companyController
                                                //             .clear();
                                                //         Get.back();
                                                //       },
                                                //       child: Text(
                                                //           "입력한 기업으로 등록하기",
                                                //           style: kmain.copyWith(
                                                //               color: mainblue)),
                                                //     ),
                                                //   );
                                                // }
                                                return GestureDetector(
                                                  onTap: () {
                                                    _controller.selectCompany(
                                                        _controller
                                                                .searchCompanyList[
                                                            index]);
                                                    _controller
                                                        .companyController
                                                        .clear();
                                                    Get.back();
                                                  },
                                                  behavior: HitTestBehavior
                                                      .translucent,
                                                  child: CompanyTileWidget(
                                                    company: _controller
                                                            .searchCompanyList[
                                                        index],
                                                  ),
                                                );
                                              },
                                              separatorBuilder:
                                                  (context, index) =>
                                                      const SizedBox(
                                                height: 24,
                                              ),
                                              itemCount: _controller
                                                      .onRegisterButton.value
                                                  ? _controller
                                                          .searchCompanyList
                                                          .length +
                                                      1
                                                  : _controller
                                                      .searchCompanyList.length,
                                            ),
                                          ),
                                  ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            // Obx(() => _controller.onRegisterButton.value
            //     ? GestureDetector(
            //         onTap: () {
            //           _controller.selectCompany(Company.defaultCompany(
            //               name: _controller.companyController.text.trim()));
            //           _controller.companyController.clear();
            //           Get.back();
            //         },
            //         child: Text("입력한 기업으로 등록하기",
            //             style: kmain.copyWith(color: mainblue)),
            //       )
            //     : Container()),
            // const SizedBox(
            //   height: 14,
            // )
          ],
        ),
      ),
    );
  }
}
