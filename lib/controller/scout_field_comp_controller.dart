import 'package:get/get.dart';
import 'package:loopus/api/scout_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/model/company_model.dart';
import 'package:loopus/utils/error_control.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ScoutFieldCompController {
  ScoutFieldCompController({required this.fieldId});

  RefreshController refreshController = RefreshController();
  RxList<Company> companyList = <Company>[].obs;
  Rx<ScreenState> screenState = ScreenState.loading.obs;
  int pageNum = 1;
  String fieldId;

  void onLoading() {
    getFieldCompList();
  }

  void getFieldCompList() async {
    await getScoutCompanySearch(
      page: pageNum,
      fieldId: fieldId,
    ).then((value) {
      if (value.isError == false) {
        List<Company> tempList = List.from(value.data)
            .map((company) => Company.fromJson(company))
            .toList();

        pageNum += 1;
        companyList.addAll(companyList);
        // for (Company company in tempList) {
        //   // print(companyList.any((element) => element.userId == company.userId));
        //   if (!companyList.any((element) => element.userId == company.userId)) {
        //     companyList.add(company);
        //   }
        // }
        refreshController.loadComplete();
        screenState(ScreenState.success);
      } else {
        if (value.errorData!["statusCode"] == 204) {
          refreshController.loadNoData();
        } else {
          errorSituation(value);
          refreshController.loadComplete();
        }
      }
    });
  }
}
