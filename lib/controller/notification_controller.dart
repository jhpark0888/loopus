import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class NotificationController extends GetxController {
  static NotificationController get to => Get.find();
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  RxMap<String, dynamic> message = Map<String, dynamic>().obs;

  @override
  void onInit() {
    _initNotification();
    _getToken();
    //Foreground 상태에서 알림을 받았을 때
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      print("message recieved");
      print(event.notification!.body);
    });
    //Background, Killed 상태에서 알림을 받고, 그 알림을 클릭해서 앱에 접근했을 때
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Message clicked!');
    });

    super.onInit();
  }

  //사용자 고유의 알림 토근 가져오기
  Future<void> _getToken() async {
    try {
      String? userMessageToken = await messaging.getToken();
      print('token : $userMessageToken');
    } catch (e) {
      print(e);
    }
  }

  //알림 권한 요청
  void _initNotification() {
    messaging.requestPermission(
      sound: true,
      badge: true,
      alert: true,
      provisional: true,
    );
  }

  //특정 질문 등에 알림을 설정한 사람들 그룹 지정
  void fcmSubscribe(String id) {
    messaging.subscribeToTopic(id);
  }

  //특정 질문 등에 알림을 해제한 사람들 또는 만료된 그룹 해제
  void fcmUnSubscribe(String id) {
    messaging.unsubscribeFromTopic(id);
  }
}
