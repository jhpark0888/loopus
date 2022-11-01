import 'package:loopus/constant.dart';
import 'package:loopus/model/company_model.dart';
import 'package:loopus/model/tag_model.dart';
import 'package:loopus/model/user_model.dart';

class RecentSearch {
  int id;
  SearchType searchType;
  dynamic data;

  RecentSearch({
    required this.id,
    required this.searchType,
    required this.data,
  });

  factory RecentSearch.fromJson(Map<String, dynamic> json) {
    SearchType tempSearchType = SearchType.values[json["type"]];
    return RecentSearch(
        id: json["id"],
        searchType: tempSearchType,
        data: tempSearchType == SearchType.profile
            ? json["data"] != null
                ? Person.fromJson(json["data"])
                : Person.defaultuser()
            : tempSearchType == SearchType.post
                ? json["data"]
                : tempSearchType == SearchType.tag
                    ? Tag.fromJson(json["data"])
                    : tempSearchType == SearchType.company
                        ? json["data"] != null
                            ? Company.fromJson(json["data"])
                            : Company.defaultCompany()
                        : null);
  }
}
