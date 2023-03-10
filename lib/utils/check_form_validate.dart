class CheckValidate {
  String? validateName(String value) {
    if (value.isEmpty) {
      return '아직 아무것도 쓰지 않았어요';
    } else {
      Pattern pattern = r'[\-\_\/\\\[\]\(\)\|\{\}*$@$!%*#?~^<>,.&+=]';
      RegExp regExp = RegExp(pattern.toString());
      if (regExp.hasMatch(value)) {
        return '특수문자는 쓸 수 없어요';
      } else {
        return null;
      }
    }
  }

  String? validateEmail(String value) {
    if (value.isEmpty) {
      return '이메일을 입력하세요';
    } else {
      Pattern pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regExp = RegExp(pattern.toString());
      if (!regExp.hasMatch(value)) {
        return '이메일 형식을 다시 확인해주세요';
      } else {
        return null;
      }
    }
  }

  static bool validateEmailBool(String value) {
    if (value.isEmpty) {
      return false;
    } else {
      Pattern pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regExp = RegExp(pattern.toString());
      if (!regExp.hasMatch(value)) {
        return false;
      } else {
        return true;
      }
    }
  }

  static String? validatePassword(String value) {
    if (value.isEmpty) {
      return '비밀번호를 입력해주세요';
    } else {
      // Pattern pattern =
      //     r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?~^<>,.&+=])[A-Za-z\d$@$!%*#?~^<>,.&+=]{8,15}$';
      // RegExp regExp = new RegExp(pattern.toString());
      if (value.length < 6) {
        return '비밀번호가 6자 이상이어야 해요';
      } else {
        return null;
      }
    }
  }

  static bool validatePasswordBool(String value) {
    if (value.isEmpty) {
      return false;
    } else {
      // Pattern pattern =
      //     r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?~^<>,.&+=])[A-Za-z\d$@$!%*#?~^<>,.&+=]{8,15}$';
      // RegExp regExp = new RegExp(pattern.toString());
      if (value.length < 6) {
        return false;
      } else {
        return true;
      }
    }
  }

  // bool validateSpecificWords(String value) {
  //   if (value.trim().isEmpty) {
  //     return false;
  //   } else {
  //     Pattern pattern =
  //         r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?~^<>,.&+=])[A-Za-z\d$@$!%*#?~^<>,.&+=]{8,15}$';
  //     RegExp regExp = RegExp(pattern.toString());
  //     if (regExp.hasMatch(value)) {
  //       return false;
  //     } else {
  //       return true;
  //     }
  //   }
  // }
  static bool validateSpecificWords(String value) {
    if (value.trim().isEmpty) {
      return false;
    } else {
      Pattern pattern = r'[\-\_\/\\\[\]\(\)\|\{\}*$@$!%*#?~^<>,.&+=]';
      RegExp regExp = RegExp(pattern.toString());
      if (regExp.hasMatch(value)) {
        return false;
      } else {
        return true;
      }
    }
  }

  static RegExp urlRegExp =
      RegExp(r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.+&]+\.[\w/\-?=%.+&]+');
}

double getAspectRatioinUrl(String url) {
  double aspectRatio = 1.0;
  url.splitMapJoin(RegExp("(?<=aspectRatio)(.*?)(?=.jpg)"), onMatch: (m) {
    aspectRatio = double.parse(m[0].toString());
    return m[0].toString();
  });

  return aspectRatio;
}
