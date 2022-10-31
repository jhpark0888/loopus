import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/scout_field_comp_controller.dart';
import 'package:loopus/model/company_model.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/company_widget.dart';
import 'package:loopus/widget/custom_header_footer.dart';
import 'package:loopus/widget/error_reload_widget.dart';
import 'package:loopus/widget/loading_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ScoutFieldCompScreen extends StatelessWidget {
  ScoutFieldCompScreen(
      {Key? key, required this.fieldId, required this.companyList})
      : super(key: key);

  String fieldId;
  RxList<Company> companyList;
  late final ScoutFieldCompController _controller =
      ScoutFieldCompController(fieldId: fieldId)..getFieldCompList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: "${fieldList[fieldId]!} 기업",
        bottomBorder: false,
      ),
      body: Obx(
        () => _controller.screenState.value == ScreenState.loading
            ? const Center(child: LoadingWidget())
            : SmartRefresher(
                controller: _controller.refreshController,
                footer: const MyCustomFooter(),
                enablePullDown: false,
                enablePullUp: true,
                onLoading: _controller.onLoading,
                child: Obx(
                  () => ListView.separated(
                      primary: false,
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: CompanyWidget(
                              company: _controller.companyList[index]),
                        );
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 16),
                      itemCount: _controller.companyList.length),
                ),
              ),
      ),
    );
  }
}
