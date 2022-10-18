import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:intl/intl.dart';
import 'package:loopus/api/project_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/ga_controller.dart';
import 'package:loopus/controller/local_data_controller.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/controller/project_add_controller.dart';
import 'package:loopus/controller/project_detail_controller.dart';
import 'package:loopus/controller/tag_controller.dart';
import 'package:loopus/model/company_model.dart';
import 'package:loopus/model/project_model.dart';
import 'package:loopus/screen/loading_screen.dart';
import 'package:loopus/trash_bin/project_add_intro_screen.dart';
import 'package:loopus/screen/project_add_period_screen.dart';
import 'package:loopus/utils/error_control.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/trash_bin/company_image_widget.dart';
import 'package:loopus/widget/company_widget.dart';
import 'package:loopus/widget/custom_textfield.dart';
import 'package:loopus/widget/disconnect_reload_widget.dart';
import 'package:loopus/widget/empty_contents_widget.dart';
import 'package:loopus/widget/error_reload_widget.dart';
import 'package:loopus/widget/label_textfield_widget.dart';
import 'package:loopus/widget/loading_widget.dart';
import 'package:loopus/widget/scroll_noneffect_widget.dart';

import '../utils/check_form_validate.dart';

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
              height: 14,
            ),
            Text(
              "어떤 기업과 함께했나요?",
              style: kmain.copyWith(color: maingray),
            ),
            LabelTextFieldWidget(
                label: "기업 이름",
                hintText: "기업 이름을 입력하세요",
                textController: _controller.companyController),
            Expanded(
              child: Obx(
                () => _controller.companySearchState.value == ScreenState.normal
                    ? Container()
                    : _controller.companySearchState.value ==
                            ScreenState.loading
                        ? const Center(child: LoadingWidget())
                        : _controller.companySearchState.value ==
                                ScreenState.disconnect
                            ? DisconnectReloadWidget(reload: searchFunction)
                            : _controller.companySearchState.value ==
                                    ScreenState.error
                                ? ErrorReloadWidget(reload: searchFunction)
                                : Obx(
                                    () => _controller
                                                .searchCompanyList.isEmpty &&
                                            _controller.companyController.text
                                                    .trim() !=
                                                ""
                                        ? EmptyContentWidget(
                                            text:
                                                "\"${_controller.companyController.text.trim()}\"에 대한 검색 결과가 없습니다")
                                        : ScrollNoneffectWidget(
                                            child: ListView.separated(
                                              itemBuilder: (context, index) {
                                                return CompanyTileWidget(
                                                    company: _controller
                                                            .searchCompanyList[
                                                        index]);
                                              },
                                              separatorBuilder:
                                                  (context, index) =>
                                                      const SizedBox(
                                                height: 12,
                                              ),
                                              itemCount: _controller
                                                  .searchCompanyList.length,
                                            ),
                                          ),
                                  ),
              ),
            ),
            Obx(() => _controller.onRegisterButton.value
                ? GestureDetector(
                    onTap: () {
                      _controller.selectCompany(Company.defaultCompany(
                          name: _controller.companyController.text.trim()));
                      _controller.companyController.clear();
                      Get.back();
                    },
                    child: Text("입력한 기업으로 등록하기",
                        style: kmain.copyWith(color: mainblue)),
                  )
                : Container()),
            const SizedBox(
              height: 14,
            )
          ],
        ),
      ),
    );
  }

  void searchFunction() {}
}
