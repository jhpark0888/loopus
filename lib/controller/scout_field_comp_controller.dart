import 'package:get/get.dart';
import 'package:loopus/api/scout_api.dart';
import 'package:loopus/model/company_model.dart';
import 'package:loopus/utils/error_control.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ScoutFieldCompController {
  ScoutFieldCompController({required this.companyList, required this.fieldId});

  RefreshController refreshController = RefreshController();
  RxList<Company> companyList = <Company>[].obs;
  int pageNum = 2;
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
        companyList.addAll(tempList);
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
