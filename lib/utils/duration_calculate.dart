import 'package:get/get.dart';
import 'package:intl/intl.dart';

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

  String messagedurationCaculate({
    required DateTime startDate,
    required DateTime endDate,
  }) {
    RxString durationResult = ''.obs;

    int _dateDiffence = (endDate.difference(startDate).inDays).toInt();
    int _dateDiffenceHours = (endDate.difference(startDate).inHours).toInt();
    int _dateDiffenceMinutes =
        (endDate.difference(startDate).inMinutes).toInt();

    // print('일 $_dateDiffence');
    // print('시간 $_dateDiffenceHours');
    // print('분 $_dateDiffenceMinutes');
    // print('d : ${_dateDiffence / 30}');
    if ((_dateDiffence / 365).floor() > 0) {
      durationResult.value = DateFormat('yy.MM.dd EEEE').format(startDate);
    } else if ((_dateDiffence / 30).floor() > 0) {
      durationResult.value = DateFormat('yy.MM.dd EEEE').format(startDate);
    } else if ((_dateDiffence / 30).floor() == 0) {
      durationResult.value = DateFormat('yy.MM.dd EEEE').format(startDate);
      if (_dateDiffence <= 6) {
        durationResult.value = '${_dateDiffence + 1}일 전';
      }
      if ((_dateDiffenceHours / 24).floor() == 0) {
        durationResult.value = '${(_dateDiffenceHours).toString()}시간 전';
      }
      if ((_dateDiffenceMinutes / 60).floor() == 0) {
        durationResult.value = '${(_dateDiffenceMinutes + 1).toString()}분 전';
      }
    }

    return durationResult.value;
  }
}
