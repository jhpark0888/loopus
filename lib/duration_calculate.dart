class DurationCaculate {
  String durationCaculate({
    required DateTime startDate,
    required DateTime endDate,
  }) {
    String durationResult = '';

    int _dateDiffence = (endDate.difference(startDate).inDays).toInt();
    // print('d : ${_dateDiffence / 30}');

    if ((_dateDiffence / 30).floor() > 0) {
      durationResult = '${((_dateDiffence / 30).floor()).toString()}개월';
      // print('dd : ${(_dateDiffence / 30).floor()}');
    } else if ((_dateDiffence / 30).floor() == 0) {
      durationResult = '${((_dateDiffence / 7)).floor().toString()}주일';
      // print('ddd : ${(_dateDiffence)}');
      if (_dateDiffence <= 6) {
        durationResult = '${_dateDiffence + 1}일';
      }
    }
    // print('dddd : $durationResult');

    return durationResult;
  }
}
