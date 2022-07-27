import 'package:get/get.dart';
import 'package:intl/intl.dart';

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
  DateFormat dateFormat = DateFormat('aa h:mm','ko');
  DateFormat dateonlyFormat = DateFormat('yyyy-MM-dd');
  DateTime startDateOnlyDay = DateTime.parse(dateonlyFormat.format(startDate));
  DateTime endDateOnlyDay = DateTime.parse(dateonlyFormat.format(endDate));
  int _dateOnlyDiffence = (endDateOnlyDay.difference(startDateOnlyDay).inDays).toInt();
  int _dateDiffence = (endDate.difference(startDate).inDays).toInt();
  int _dateDiffenceHours = (endDate.difference(startDate).inHours).toInt();
  int _dateDiffenceMinutes = (endDate.difference(startDate).inMinutes).toInt();
  int _dateDiffenceSeconds = (endDate.difference(startDate).inSeconds).toInt();
  
  // print('일 $_dateDiffence');
  // print('시간 $_dateDiffenceHours');
  // print('분 $_dateDiffenceMinutes');
  // print('d : ${_dateDiffence / 30}');
  if ((_dateDiffence / 365).floor() > 0) {
    durationResult.value = '${(_dateDiffence / 365).floor()}년 전';
  } else if ((_dateDiffence / 30).floor() > 0) {
    durationResult.value = DateFormat('MM.dd').format(startDate);
  } else if ((_dateDiffence / 30).floor() == 0) {
    durationResult.value = DateFormat('MM.dd').format(startDate);
    if(_dateOnlyDiffence == 1){
      durationResult.value = '어제';
    }
    // if (_dateDiffence <= 6) {
    //   durationResult.value = DateFormat('yy.MM.dd EE').format(startDate);
    // }
    else if ((_dateDiffenceHours / 24).floor() == 0) {
      // durationResult.value = '${(_dateDiffenceHours).toString()}시간 전';
      durationResult.value = dateFormat.format(startDate);
    }
    // if((_dateDiffenceSeconds / 60).floor()==0){
    //   durationResult.value = ''
    // }
    // if ((_dateDiffenceMinutes / 60).floor() == 0) {
    //   durationResult.value = '${(_dateDiffenceMinutes + 1).toString()}분 전';
    // }
  }

  return durationResult.value;
}

String messageDurationCalculate(DateTime time){
    DateFormat dateFormat = DateFormat('aa hh:mm','ko');
    return dateFormat.format(time);
  }

String calculateDate(DateTime date) {
  if (DateTime.now().difference(date).inMilliseconds < 1000) {
    return '방금 전';
  } else if (DateTime.now().difference(date).inMinutes < 60) {
    return '${DateTime.now().difference(date).inMinutes}분 전';
  } else if (DateTime.now().difference(date).inHours <= 24) {
    return '${DateTime.now().difference(date).inHours}시간 전';
  } else if (DateTime.now().difference(date).inDays <= 31) {
    return '${DateTime.now().difference(date).inDays}일 전';
  } else if (DateTime.now().difference(date).inDays <= 365) {
    return '일 년 이내';
  }
  return '일 년 전';
}
