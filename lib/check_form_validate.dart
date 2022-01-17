class CheckValidate {
  String? validateName(String value) {
    if (value.isEmpty) {
      return '제목을 입력해주세요.';
    } else {
      Pattern pattern = r'[\-\_\/\\\[\]\(\)\|\{\}*$@$!%*#?~^<>,.&+=]';
      RegExp regExp = RegExp(pattern.toString());
      if (regExp.hasMatch(value)) {
        return '특수문자를 제거해주세요.';
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
      RegExp regExp = new RegExp(pattern.toString());
      if (!regExp.hasMatch(value)) {
        return '이메일 형식을 다시 확인해주세요';
      } else {
        return null;
      }
    }
  }

  String? validatePassword(String value) {
    if (value.isEmpty) {
      return '비밀번호를 입력하세요';
    } else {
      Pattern pattern =
          r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?~^<>,.&+=])[A-Za-z\d$@$!%*#?~^<>,.&+=]{8,15}$';
      RegExp regExp = new RegExp(pattern.toString());
      if (!regExp.hasMatch(value)) {
        return '영문, 숫자, 특수문자 포함 8자 이상이어야해요';
      } else {
        return null;
      }
    }
  }
}
