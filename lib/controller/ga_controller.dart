import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class GAController extends GetxController {
  static GAController get to => Get.find();
  FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  FirebaseAnalyticsObserver getAnalyticsObserver() =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  //어떤 유저인지 알려줌
  Future setUserProperties(String userId, String userDepartment) async {
    await _analytics.setUserId(id: userId);
    await _analytics.setUserProperty(
        name: 'user_department', value: userDepartment);
  }

  Future logLogin() async {
    await _analytics.logLogin(loginMethod: 'email');
  }

  Future logSignup() async {
    await _analytics.logSignUp(signUpMethod: 'email');
  }

  Future logPostingCreated(bool isCreated) async {
    await _analytics.logEvent(
        name: 'create_posting', parameters: {'create_success': isCreated});
  }

  Future logProjectCreated(bool isCreated) async {
    await _analytics.logEvent(
        name: 'create_project', parameters: {'create_success': isCreated});
  }

  Future logScreenView(String screenName) async {
    await _analytics.logScreenView(screenName: screenName);
  }
}
