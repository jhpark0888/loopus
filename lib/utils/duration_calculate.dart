import 'package:get/get.dart';

class DurationCaculator extends GetxController {
  String durationCaculate({
    required DateTime startDate,
    required DateTime endDate,
  }) {
    RxString durationResult = ''.obs;

    int _dateDiffence = (endDate.difference(startDate).inDays).toInt();

    // print('d : ${_dateDiffence / 30}');
    if ((_dateDiffence / 365).floor() > 0) {
      durationResult.value =
          '${((_dateDiffence / 365).floor()).toString()}년 ${((_dateDiffence - 365) / 30).floor().toString()}개월';
    } else if ((_dateDiffence / 30).floor() > 0) {
      durationResult.value = '${((_dateDiffence / 30).floor()).toString()}개월';
      // print('dd : ${(_dateDiffence / 30).floor()}');
    } else if ((_dateDiffence / 30).floor() == 0) {
      durationResult.value = '${((_dateDiffence / 7)).floor().toString()}주일';
      // print('ddd : ${(_dateDiffence)}');
      if (_dateDiffence <= 6) {
        durationResult.value = '${_dateDiffence + 1}일';
      }
    }
    // print('dddd : $durationResult');

    return durationResult.value;
  }
}
