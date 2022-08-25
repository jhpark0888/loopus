import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:loopus/controller/message_controller.dart';
import 'package:loopus/controller/before_message_detail_controller.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/model/httpresponse_model.dart';
import 'package:loopus/model/message_model.dart';
import 'package:loopus/model/socket_message_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/widget/message_widget.dart';
import 'package:loopus/widget/messageroom_widget.dart';

import '../constant.dart';
import '../controller/error_controller.dart';

// Future<void> getmessageroomlist() async {
//   ConnectivityResult result = await initConnectivity();
//   MessageController.to.chatroomscreenstate(ScreenState.loading);
//   if (result == ConnectivityResult.none) {
//     MessageController.to.chatroomscreenstate(ScreenState.disconnect);
//     showdisconnectdialog();
//   } else {
//     String? token = await const FlutterSecureStorage().read(key: 'token');
//     String? myid = await const FlutterSecureStorage().read(key: 'id');

//     final url = Uri.parse("$serverUri/chat/get_list");
//     try {
//       http.Response response = await http.get(
//         url,
//         headers: {
//           'Authorization': 'Token $token',
//           'Content-Type': 'application/json'
//         },
//       );

//       print('채팅방 리스트 statuscode: ${response.statusCode}');
//       if (response.statusCode == 200) {
//         List responseBody = jsonDecode(utf8.decode(response.bodyBytes));
//         MessageController.to.chattingRoomList(responseBody
//             .map((messageroom) => MessageRoomWidget(
//                 chatRoom: ChatRoom.fromJson(messageroom).obs))
//             .toList());
//         MessageController.to.chatroomscreenstate(ScreenState.success);
//         print("---------------------------");
//         print(responseBody);
//         print(response.statusCode);
//         return;
//       } else {
//         MessageController.to.chatroomscreenstate(ScreenState.error);
//         return Future.error(response.statusCode);
//       }
//     } on SocketException {
//       print("서버에러 발생");

//       // ErrorController.to.isServerClosed(true);
//     } catch (e) {
//       print(e);
//       // ErrorController.to.isServerClosed(true);
//     }
//   }
// }

Future<HTTPResponse> getChatroomlist(int id) async {
  ConnectivityResult result = await initConnectivity();
  MessageController.to.chatroomscreenstate(ScreenState.loading);
  if (result == ConnectivityResult.none) {
    MessageController.to.chatroomscreenstate(ScreenState.disconnect);
    showdisconnectdialog();
    return HTTPResponse.networkError();
  } else {
    String? token = await const FlutterSecureStorage().read(key: 'token');
    String? myid = await const FlutterSecureStorage().read(key: 'id');
    final url = Uri.parse("http://$chatServerUri/chat/chat_list?id=${id}");
    try {
      http.Response response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      print('채팅방 리스트 statuscode: ${response.statusCode}');
      if (response.statusCode == 200) {
        List responseBody = jsonDecode(utf8.decode(response.bodyBytes));
        List<ChatRoom> chatroom =
            responseBody.map((e) => ChatRoom.fromJson(e)).toList();
        MessageController.to.chatroomscreenstate(ScreenState.success);
        print("---------------------------");
        print(responseBody);
        print(response.statusCode);
        return HTTPResponse.success(chatroom);
      } else {
        MessageController.to.chatroomscreenstate(ScreenState.error);
        return HTTPResponse.apiError('', response.statusCode);
      }
    } on SocketException {
      print("서버에러 발생");
      return HTTPResponse.serverError();
      // ErrorController.to.isServerClosed(true);
    } catch (e) {
      print(e);
      // ErrorController.to.isServerClosed(true);
      return HTTPResponse.unexpectedError(e);
    }
  }
}

Future<HTTPResponse> getUserProfile(List<int> membersId) async {
  ConnectivityResult result = await initConnectivity();
  // MessageController.to.chatroomscreenstate(ScreenState.loading);
  if (result == ConnectivityResult.none) {
    // MessageController.to.chatroomscreenstate(ScreenState.disconnect);
    showdisconnectdialog();
    return HTTPResponse.networkError();
  } else {
    String? token = await const FlutterSecureStorage().read(key: 'token');
    String? myid = await const FlutterSecureStorage().read(key: 'id');
    final url = Uri.parse("$serverUri/chat/get_profile?members=$membersId");
    try {
      http.Response response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': "Token $token"
        },
      );

      print('유저들 프로필 리스트 statuscode: ${response.statusCode}');
      if (response.statusCode == 200) {
        List<dynamic> responseBody =
            jsonDecode(utf8.decode(response.bodyBytes));
        List<User> userList = responseBody.map((e) {
          return User.fromJson(e);
        }).toList();
        // MessageController.to.chatroomscreenstate(ScreenState.success);
        print("---------------------------");
        print(responseBody);
        print(response.statusCode);
        return HTTPResponse.success(userList);
      } else {
        // MessageController.to.chatroomscreenstate(ScreenState.error);
        return HTTPResponse.apiError('', response.statusCode);
      }
    } on SocketException {
      print("서버에러 발생");
      return HTTPResponse.serverError();
      // ErrorController.to.isServerClosed(true);
    } catch (e) {
      print(e);
      // ErrorController.to.isServerClosed(true);
      return HTTPResponse.unexpectedError(e);
    }
  }
}

Future<HTTPResponse> getPartnerToken(int memberId) async {
  ConnectivityResult result = await initConnectivity();
  // MessageController.to.chatroomscreenstate(ScreenState.loading);
  if (result == ConnectivityResult.none) {
    // MessageController.to.chatroomscreenstate(ScreenState.disconnect);
    showdisconnectdialog();
    return HTTPResponse.networkError();
  } else {
    String? token = await const FlutterSecureStorage().read(key: 'token');
    String? myid = await const FlutterSecureStorage().read(key: 'id');
    final url = Uri.parse("$serverUri/chat/get_token?id=$memberId");
    try {
      http.Response response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': "Token $token"
        },
      );
      print(memberId);
      print('유저들 프로필 리스트 statuscode: ${response.statusCode}');
      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody =
            jsonDecode(utf8.decode(response.bodyBytes));
        String token = responseBody['token'];
        print("---------------------------");
        print(responseBody);
        print(response.statusCode);
        return HTTPResponse.success(token);
      } else if (response.statusCode == 404) {
        return HTTPResponse.success('');
      } else {
        return HTTPResponse.apiError('', response.statusCode);
      }
    } on SocketException {
      print("서버에러 발생");
      return HTTPResponse.serverError();
      // ErrorController.to.isServerClosed(true);
    } catch (e) {
      print(e);
      // ErrorController.to.isServerClosed(true);
      return HTTPResponse.unexpectedError(e);
    }
  }
}

Future<HTTPResponse> deleteChatRoom(int roomId, int myId, int msgId) async {
  ConnectivityResult result = await initConnectivity();
  if (result == ConnectivityResult.none) {
    showdisconnectdialog();
    return HTTPResponse.networkError();
  } else {
    String? token = await const FlutterSecureStorage().read(key: 'token');
    String? myid = await const FlutterSecureStorage().read(key: 'id');
    final url = Uri.parse("http://$chatServerUri/chat/chat_list?id=$myId");
    try {
      http.Response response = await http.delete(
        url,
        body: jsonEncode({'room_id': roomId, 'msg_id': msgId}),
        headers: {'Content-Type': 'application/json'},
      );

      print('채팅방 삭제 statuscode: ${response.statusCode}');
      if (response.statusCode == 200) {
        return HTTPResponse.success(null);
      } else {
        return HTTPResponse.apiError('', response.statusCode);
      }
    } on SocketException {
      print("서버에러 발생");
      return HTTPResponse.serverError();
      // ErrorController.to.isServerClosed(true);
    } catch (e) {
      print(e);
      // ErrorController.to.isServerClosed(true);
      return HTTPResponse.unexpectedError(e);
    }
    // } on SocketException {
    //   print("서버에러 발생");
    //   return HTTPResponse.serverError();
    //   // ErrorController.to.isServerClosed(true);
    // } catch (e) {
    //   print(e);
    //   // ErrorController.to.isServerClosed(true);
    //   return HTTPResponse.unexpectedError(e);
    // }
  }
}

Future<HTTPResponse> deletemessageroom(int postid, int projectid) async {
  ConnectivityResult result = await initConnectivity();
  if (result == ConnectivityResult.none) {
    showdisconnectdialog();
    return HTTPResponse.networkError();
  } else {
    String? token = await const FlutterSecureStorage().read(key: "token");

    final uri = Uri.parse("$serverUri/post_api/posting?id=$postid");

    try {
      http.Response response =
          await http.delete(uri, headers: {"Authorization": "Token $token"});

      print("채팅방 삭제: ${response.statusCode}");
      if (response.statusCode == 200) {
        Get.back();
        return HTTPResponse.success(null);
      } else {
        return HTTPResponse.apiError('', response.statusCode);
      }
    } on SocketException {
      // ErrorController.to.isServerClosed(true);
      return HTTPResponse.serverError();
    } catch (e) {
      print(e);
      return HTTPResponse.unexpectedError(e);
      // ErrorController.to.isServerClosed(true);
    }
  }
}

Future<HTTPResponse> updateNotreadMsg(int userId) async {
  ConnectivityResult result = await initConnectivity();
  if (result == ConnectivityResult.none) {
    showdisconnectdialog();
    return HTTPResponse.networkError();
  } else {
    String? token = await const FlutterSecureStorage().read(key: "token");

    final uri = Uri.parse("http://$chatServerUri/chat/check_msg?id=$userId");

    try {
      http.Response response = await http.get(uri);

      print("안읽은 메세지 개수 업데이트: ${response.statusCode}");
      if (response.statusCode == 200) {
        bool responseBody = jsonDecode(utf8.decode(response.bodyBytes));
        return HTTPResponse.success(responseBody);
      } else {
        return HTTPResponse.apiError('', response.statusCode);
      }
    } on SocketException {
      // ErrorController.to.isServerClosed(true);
      return HTTPResponse.serverError();
    } catch (e) {
      print(e);
      return HTTPResponse.unexpectedError(e);
      // ErrorController.to.isServerClosed(true);
    }
  }
}

// Future<HTTPResponse> getmessagelist(int userid, int lastindex) async {
//   String? token = await const FlutterSecureStorage().read(key: 'token');
//   String? myid = await const FlutterSecureStorage().read(key: 'id');
//   MessageDetailController messageDetailController =
//       Get.find<MessageDetailController>(tag: userid.toString());

//   final url = Uri.parse("$serverUri/chat/chatting?id=$userid&last=$lastindex");

//   try {
//     final response =
//         await http.get(url, headers: {"Authorization": "Token $token"});

//     print('채팅 리스트 statuscode: ${response.statusCode}');
//     if (response.statusCode == 200) {
//       Map responseBody = jsonDecode(utf8.decode(response.bodyBytes));
//       if (lastindex == 0) {
//         messageDetailController.user =
//             User.fromJson(responseBody["profile"]).obs;
//       }
//       List<MessageWidget> modelmessagelist = List.from(responseBody["message"])
//           .map((message) => Message.fromJson(message, myid))
//           .toList()
//           .map((message) => MessageWidget(
//               message: message, user: messageDetailController.user!.value))
//           .toList();
//       // print(responseBody);

//       // MessageController.to.chattingroomlist(responseBody
//       //     .map((messageroom) => MessageRoom.fromJson(messageroom))
//       //     .toList());
//       return HTTPResponse.success(modelmessagelist);
//     } else if (response.statusCode == 404) {
//       messageDetailController.messagelist([]);
//       return HTTPResponse.success(<MessageWidget>[]);
//     } else {
//       return HTTPResponse.apiError('', response.statusCode);
//     }
//   } on SocketException {
//     // ErrorController.to.isServerClosed(true);
//     return HTTPResponse.serverError();
//   } catch (e) {
//     print(e);
//     return HTTPResponse.unexpectedError(e);
//     // ErrorController.to.isServerClosed(true);
//   }

// print(map);
// String username = map["real_name"];
// userid = map["user_id"];
// if (map["messages"].length != 0) {
//   map["messages"].forEach((element) {
//     if (element["sender_id"] == map["user_id"]) {
//       MessageController.to.messagelist.add(MessageWidget(
//         content: element["message"],
//         image: map["profile_image"],
//         isSender: 1,
//       ));
//     } else {
//       MessageController.to.messagelist.add(MessageWidget(
//         content: element["message"],
//         image: map["profile_image"],
//         isSender: 0,
//       ));
//     }
//   });
// } else {
//   return;
// }
// }

Future<void> postmessage(String content, int userid) async {
  String? token = await const FlutterSecureStorage().read(key: 'token');
  String? myid = await const FlutterSecureStorage().read(key: 'id');

  final url = Uri.parse("$serverUri/chat/chatting?id=$userid");

  var message = {
    "message": content,
  };

  http.Response response = await http.post(url,
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json'
      },
      body: jsonEncode(message));

  print('메세지 보내기 statuscode: ${response.statusCode}');
  if (response.statusCode == 200) {
    // var responseBody = jsonDecode(utf8.decode(response.bodyBytes));
    // print(responseBody);

    // Message messagelist = Message.fromJson(responseBody, myid);
    return;
  } else {
    return Future.error(response.statusCode);
  }
}

Future<void> putonmessagescreen(String userid) async {
  String? token = await const FlutterSecureStorage().read(key: 'token');
  String? myid = await const FlutterSecureStorage().read(key: 'id');

  final url = Uri.parse("$serverUri/chat/chatting?id=$userid");

  http.Response response = await http.put(
    url,
    headers: {
      'Authorization': 'Token $token',
      'Content-Type': 'application/json'
    },
  );

  print('on 메세지 스크린 statuscode: ${response.statusCode}');
  if (response.statusCode == 200) {
    // var responseBody = jsonDecode(utf8.decode(response.bodyBytes));
    // print(responseBody);

    // Message messagelist = Message.fromJson(responseBody, myid);
    return;
  } else {
    return Future.error(response.statusCode);
  }
}
