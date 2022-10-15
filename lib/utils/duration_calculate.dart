import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:time_machine/time_machine.dart';

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

String messageDurationCalculate(DateTime time) {
  DateFormat dateFormat = DateFormat('aa h:mm', 'ko');
  return dateFormat.format(time);
}

String messageRoomDurationCalculate({
  required DateTime startDate,
  required DateTime endDate,
}) {
  RxString durationResult = ''.obs;
  DateFormat dateFormat = DateFormat('aa h:mm', 'ko');
  DateFormat dateonlyFormat = DateFormat('yyyy-MM-dd');
  DateTime startDateOnlyDay = DateTime.parse(dateonlyFormat.format(startDate));
  DateTime endDateOnlyDay = DateTime.parse(dateonlyFormat.format(endDate));
  int _dateOnlyDiffence =
      (endDateOnlyDay.difference(startDateOnlyDay).inDays).toInt();
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
    if (_dateOnlyDiffence == 1) {
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

String notiDurationCaculate({
  required DateTime startDate,
  required DateTime endDate,
}) {
  RxString durationResult = ''.obs;
  DateFormat dateFormat = DateFormat('aa h:mm', 'ko');
  DateFormat dateonlyFormat = DateFormat('yyyy-MM-dd');
  DateTime startDateOnlyDay = DateTime.parse(dateonlyFormat.format(startDate));
  DateTime endDateOnlyDay = DateTime.parse(dateonlyFormat.format(endDate));
  int _dateOnlyDiffence =
      (endDateOnlyDay.difference(startDateOnlyDay).inDays).toInt();
  int _dateDiffence = (endDate.difference(startDate).inDays).toInt();

  if ((_dateOnlyDiffence / 30).floor() < 1) {
    durationResult.value = '이번 달';
    if (_dateOnlyDiffence <= 7) {
      durationResult.value = '이번 주';
    }
  } else if ((_dateOnlyDiffence / 30).floor() >= 1) {
    durationResult.value = '지난 알림';
  }

  return durationResult.value;
}

// String calculateDate(DateTime date) {
//   if (DateTime.now().difference(date).inMinutes <= 1) {
//     return '방금 전';
//   } else if (DateTime.now().difference(date).inMinutes < 60) {
//     return '${DateTime.now().difference(date).inMinutes}분 전';
//   } else if (DateTime.now().difference(date).inHours <= 24) {
//     return '${DateTime.now().difference(date).inHours}시간 전';
//   } else if (DateTime.now().difference(date).inDays <= 31) {
//     return '${DateTime.now().difference(date).inDays}일 전';
//   } else if (DateTime.now().difference(date).inDays <= 365) {
//     return '일 년 이내';
//   }
//   return '일 년 전';
// }

String calculateDate(DateTime date) {
  final currentDateTime = DateTime.now();
  LocalDateTime compareDate = LocalDateTime.dateTime(date);
  LocalDateTime currentDate = LocalDateTime.dateTime(currentDateTime);
  Period diff = currentDate.periodSince(compareDate);

  if (diff.years >= 1) {
    return DateFormat('YYYY.MM.dd').format(date);
  } else {
    if (diff.months >= 1) {
      // return DateFormat('MM.dd').format(date);
      return '${date.month}월 ${date.day}일';
    } else {
      if (diff.days > 7) {
        // return DateFormat('MM.dd').format(date);
        return '${date.month}월 ${date.day}일';
      } else if (diff.days <= 7 && diff.days >= 1) {
        return '${diff.days}일 전';
      } else {
        if (diff.hours >= 1) {
          return '${diff.hours}시간 전';
        } else {
          if (diff.minutes > 0) {
            return '${diff.minutes}분 전';
          } else {
            return '방금 전';
          }
        }
      }
    }
  }
}

String commentCalculateDate(DateTime date) {
  final currentDateTime = DateTime.now();
  LocalDateTime compareDate = LocalDateTime.dateTime(date);
  LocalDateTime currentDate = LocalDateTime.dateTime(currentDateTime);
  Period diff = currentDate.periodSince(compareDate);
  if (diff.years >= 1) {
    return DateFormat('YYYY.MM.dd').format(date);
  } else {
    if (diff.months >= 1) {
      // return DateFormat('MM.dd').format(date);
      return '${date.day ~/ 7}주';
    } else {
      if (diff.days > 7) {
        // return DateFormat('MM.dd').format(date);
        return '${date.day ~/ 7}주';
      } else if (diff.days <= 7 && diff.days >= 1) {
        return '${diff.days}일';
      } else {
        if (diff.hours >= 1) {
          return '${diff.hours}시간';
        } else {
          if (diff.minutes > 0) {
            return '${diff.minutes}분';
          } else {
            return '방금';
          }
        }
      }
    }
  }
}

String lastPostCalculateDate(DateTime date) {
  final currentDateTime = DateTime.now();
  LocalDateTime compareDate = LocalDateTime.dateTime(date);
  LocalDateTime currentDate = LocalDateTime.dateTime(currentDateTime);
  Period diff = currentDate.periodSince(compareDate);

  if (diff.years >= 1) {
    return "${diff.years} 년 전";
  } else {
    if (diff.months >= 1) {
      // return DateFormat('MM.dd').format(date);
      return "${diff.months}개월 전";
    } else {
      if (diff.days >= 1) {
        // return DateFormat('MM.dd').format(date);
        return "${diff.days}일 전";
      } else {
        if (diff.hours >= 1) {
          return '${diff.hours}시간 전';
        } else {
          if (diff.minutes > 0) {
            return '${diff.minutes}분 전';
          } else {
            return '방금 전';
          }
        }
      }
    }
  }
}
