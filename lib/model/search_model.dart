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
            ? Person.fromJson(json["data"])
            : tempSearchType == SearchType.post
                ? json["data"]
                : tempSearchType == SearchType.tag
                    ? Tag.fromJson(json["data"])
                    : tempSearchType == SearchType.company
                        ? Company.fromJson(json["data"])
                        : null);
  }
}
