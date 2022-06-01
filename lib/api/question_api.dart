import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/question_detail_controller.dart';
import 'dart:convert';

import 'package:loopus/controller/tag_controller.dart';
import 'package:loopus/model/httpresponse_model.dart';
import 'package:loopus/model/question_model.dart';
import 'package:loopus/widget/question_answer_widget.dart';

import '../constant.dart';
import '../controller/error_controller.dart';

// Future postquestion(String content) async {
//   ConnectivityResult result = await initConnectivity();
//   if (result == ConnectivityResult.none) {
//     ModalController.to.showdisconnectdialog();
//   } else {
//     String? token;
//     await const FlutterSecureStorage().read(key: 'token').then((value) {
//       token = value;
//     });

//     final url = Uri.parse("$serverUri/question_api/question");
//     var data = {
//       "content": content,
//       "tag": Get.find<TagController>(tag: Tagtype.question.toString())
//           .selectedtaglist
//           .map((element) => element.text)
//           .toList()
//     };
//     try {
//       http.Response response = await http.post(url,
//           headers: {
//             'Authorization': 'Token $token',
//             'Content-Type': 'application/json'
//           },
//           body: jsonEncode(data));
//       var responseHeaders = response.headers;
//       var responseBody = utf8.decode(response.bodyBytes);

//       if (response.statusCode == 200) {
//         getbacks(2);
//         HomeController.to.onQuestionRefresh();
//         return;
//       } else {
//         return Future.error(response.statusCode);
//       }
//     } on SocketException {
//       ErrorController.to.isServerClosed(true);
//     } catch (e) {
//       print(e);

//       // ErrorController.to.isServerClosed(true);
//     }
//   }
// }

Future<HTTPResponse> getquestionlist(int lastindex, String type) async {
  String? token;
  await const FlutterSecureStorage().read(key: 'token').then((value) {
    token = value;
  });
  print(lastindex);
  final url = Uri.parse(
      "$serverUri/question_api/question_list_load/$type?last=$lastindex");
  try {
    final response = await get(url, headers: {"Authorization": "Token $token"});
    var statusCode = response.statusCode;
    var responseHeaders = response.headers;
    if (response.statusCode == 200) {
      var responseBody = utf8.decode(response.bodyBytes);
      print(responseBody);

      List<dynamic> list = jsonDecode(responseBody);
      // print(list);
      return HTTPResponse.success(QuestionModel.fromJson(list));
    } else {
      return HTTPResponse.apiError('', response.statusCode);
    }
  } on SocketException {
    ErrorController.to.isServerClosed(true);
    return HTTPResponse.serverError();
  } catch (e) {
    print(e);
    return HTTPResponse.unexpectedError(e);
    // ErrorController.to.isServerClosed(true);
  }
}

Future<void> getquestion(int questionid) async {
  ConnectivityResult result = await initConnectivity();
  QuestionDetailController controller =
      Get.find<QuestionDetailController>(tag: questionid.toString());
  if (result == ConnectivityResult.none) {
    controller.questionscreenstate(ScreenState.disconnect);
    ModalController.to.showdisconnectdialog();
  } else {
    print(questionid);
    String? token;
    await FlutterSecureStorage().read(key: 'token').then((value) {
      token = value;
    });

    final url = Uri.parse("$serverUri/question_api/question?id=$questionid");

    final response = await get(url, headers: {"Authorization": "Token $token"});

    print("질문 로드 statusCode: ${response.statusCode}");
    if (response.statusCode == 200) {
      Map<String, dynamic> responseBody =
          jsonDecode(utf8.decode(response.bodyBytes));
      QuestionItem question = QuestionItem.fromJson(responseBody);
      controller.question(question);
      controller.addanswer();

      controller.questionscreenstate(ScreenState.success);

      return;
    } else if (response.statusCode == 404) {
      Get.back();
      ModalController.to.showCustomDialog('이미 삭제된 질문입니다', 1400);
      return Future.error(response.statusCode);
    } else {
      controller.questionscreenstate(ScreenState.error);
      return Future.error(response.statusCode);
    }
  }
}

// Future<dynamic> deletequestion(int questionid) async {
//   ConnectivityResult result = await initConnectivity();
//   QuestionDetailController controller =
//       Get.find<QuestionDetailController>(tag: questionid.toString());
//   if (result == ConnectivityResult.none) {
//     ModalController.to.showdisconnectdialog();
//   } else {
//     String? token;
//     await FlutterSecureStorage().read(key: 'token').then((value) {
//       token = value;
//     });

//     final url = Uri.parse("$serverUri/question_api/question?id=$questionid");
//     try {
//       final response =
//           await delete(url, headers: {"Authorization": "Token $token"});

//       if (response.statusCode == 200) {
//         //   var statusCode = response.statusCode;
//         // var responseHeaders = response.headers;
//         // var responseBody = utf8.decode(response.bodyBytes);
//         // print(statusCode);
//         // Map<String, dynamic> map = jsonDecode(responseBody);
//         HomeController.to.questionResult.value.questionitems.removeWhere(
//             (question) => question.id == controller.question.value.id);
//         Get.back();
//         controller.isQuestionDeleteLoading(false);

//         print(' 질문 삭제 성공 : ${response.statusCode}');
//         return;
//       } else {
//         return Future.error(response.statusCode);
//       }
//     } on SocketException {
//       ErrorController.to.isServerClosed(true);
//     } catch (e) {
//       print(e);
//       // ErrorController.to.isServerClosed(true);
//     }
//   }
// }

Future<void> answermake(String content, int questionid) async {
  ConnectivityResult result = await initConnectivity();
  QuestionDetailController controller =
      Get.find<QuestionDetailController>(tag: questionid.toString());
  if (result == ConnectivityResult.none) {
    ModalController.to.showdisconnectdialog();
  } else {
    String? token;
    await FlutterSecureStorage().read(key: 'token').then((value) {
      token = value;
    });

    final url = Uri.parse("$serverUri/question_api/answer/$questionid");

    print(token);
    var data = {
      "content": content,
    };
    try {
      http.Response response = await http.post(url,
          headers: {
            'Authorization': 'Token $token',
            'Content-Type': 'application/json'
          },
          body: jsonEncode(data));

      print(response.statusCode);
      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody =
            jsonDecode(utf8.decode(response.bodyBytes));
        Answer answer = Answer.fromJson(responseBody);
        answer.isuser = 1;
        controller.answerlist.add(QuestionAnswerWidget(
          answer: answer,
        ));
        controller.answerfocus.unfocus();
        controller.answertextController.clear();
        return;
      } else {
        return Future.error(response.statusCode);
      }
    } on SocketException {
      ErrorController.to.isServerClosed(true);
    } catch (e) {
      print(e);
      // ErrorController.to.isServerClosed(true);
    }
  }
}

Future<dynamic> deleteanswer(int questionid, int answerid) async {
  ConnectivityResult result = await initConnectivity();
  QuestionDetailController controller =
      Get.find<QuestionDetailController>(tag: questionid.toString());
  if (result == ConnectivityResult.none) {
    ModalController.to.showdisconnectdialog();
  } else {
    String? token;
    await FlutterSecureStorage().read(key: 'token').then((value) {
      token = value;
    });

    final url =
        Uri.parse("$serverUri/question_api/answer/questionid?id=$answerid");
    try {
      final response =
          await delete(url, headers: {"Authorization": "Token $token"});

      print(' 답변 삭제 : ${response.statusCode}');

      if (response.statusCode == 200) {
        controller.question.value.answer
            .removeWhere((element) => element.id == answerid);
        controller.answerlist
            .removeWhere((element) => element.answer.id == answerid);
        getbacks(2);
        return;
      } else {
        return Future.error(response.statusCode);
      }
    } on SocketException {
      ErrorController.to.isServerClosed(true);
    } catch (e) {
      print(e);
      // ErrorController.to.isServerClosed(true);
    }
  }
}

Future questionreport(int questionid) async {
  ConnectivityResult result = await initConnectivity();
  if (result == ConnectivityResult.none) {
    ModalController.to.showdisconnectdialog();
  } else {
    String? token;
    await const FlutterSecureStorage().read(key: 'token').then((value) {
      token = value;
    });

    final Uri uri = Uri.parse("$serverUri/question_api/report");

    var body = {"id": questionid, "reason": ""};

    try {
      final response = await http.post(uri,
          headers: {
            'Content-Type': 'application/json',
            "Authorization": "Token $token"
          },
          body: json.encode(body));

      print('질문 신고 statusCode: ${response.statusCode}');
      if (response.statusCode == 200) {
        getbacks(2);
        ModalController.to.showCustomDialog("신고가 접수되었습니다", 1000);
        return;
      } else {
        return Future.error(response.statusCode);
      }
    } on SocketException {
      ErrorController.to.isServerClosed(true);
    } catch (e) {
      print(e);
      // ErrorController.to.isServerClosed(true);
    }
  }
}

Future answerreport(int answerid) async {
  ConnectivityResult result = await initConnectivity();
  if (result == ConnectivityResult.none) {
    ModalController.to.showdisconnectdialog();
  } else {
    String? token;
    await const FlutterSecureStorage().read(key: 'token').then((value) {
      token = value;
    });

    final Uri uri = Uri.parse("$serverUri/question_api/answer_report");

    var body = {"id": answerid, "reason": ""};

    try {
      final response = await http.post(uri,
          headers: {
            'Content-Type': 'application/json',
            "Authorization": "Token $token"
          },
          body: json.encode(body));

      print('답변 신고 statusCode: ${response.statusCode}');
      if (response.statusCode == 200) {
        getbacks(2);
        ModalController.to.showCustomDialog("신고가 접수되었습니다", 1000);
        return;
      } else {
        return Future.error(response.statusCode);
      }
    } on SocketException {
      ErrorController.to.isServerClosed(true);
    } catch (e) {
      print(e);
      // ErrorController.to.isServerClosed(true);
    }
  }
}
