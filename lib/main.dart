import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl_standalone.dart';
import 'package:loopus/controller/ga_controller.dart';
import 'package:loopus/app.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/message_controller.dart';
import 'package:loopus/controller/signup_controller.dart';
import 'package:loopus/controller/sql_controller.dart';
import 'package:loopus/firebase_options.dart';
import 'package:loopus/screen/start_screen.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loopus/utils/local_notification.dart';
import 'package:loopus/utils/no_scroll_behavior.dart';
import 'controller/notification_controller.dart';

//백그라운드 메세지 왔을 때
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (message.data["type"] == "msg") {
    String? newMsg = await FlutterSecureStorage().read(key: 'newMsg') ?? '';
    if (newMsg == '') {
      const FlutterSecureStorage().write(key: 'newMsg', value: 'true');
    }
  } else if (message.data["type"] ==
      NotificationType.careerTag.index.toString()) {
    FlutterSecureStorage secureStorage = FlutterSecureStorage();
    int careerId = message.data["id"];
    String? strGroupTpList = await secureStorage.read(key: "groupTpList");
    List<int> groupTpList = [];

    if (strGroupTpList != null) {
      groupTpList = json.decode(strGroupTpList).cast<int>();
    }
    groupTpList.add(careerId);

    secureStorage.write(key: "groupTpList", value: json.encode(groupTpList));
    await FirebaseMessaging.instance.subscribeToTopic("project$careerId");
  }
  print('백그라운드 알림 데이터 : ${message.data}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // debugPrintGestureArenaDiagnostics = true;
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await localNotificaition.initLocalNotificationPlugin();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
  //   systemNavigationBarColor: AppColors.mainblack,
  //   statusBarIconBrightness: Brightness.dark,
  //   systemNavigationBarIconBrightness: Brightness.dark,
  //   statusBarColor: AppColors.mainWhite, // status bar color
  // ));
  try {
    if (Platform.isIOS || Platform.isAndroid) {
      Intl.systemLocale = await findSystemLocale();
    }
  } catch (e) {
    print(e);
  }

  String? temptoken = await const FlutterSecureStorage().read(key: 'token');
  await GetStorage.init();

  // KakaoContext.clientId = '3e0e4823d8dd690cfb48b8bcd5ad7e6c';
  // FlutterError.onError = (FlutterErrorDetails details) {
  //   FlutterError.presentError(details);
  //   print('error catch');
  //   // if (kReleaseMode) exit(1);
  // };
  runApp(
    // DevicePreview(
    // enabled: !kReleaseMode,
    // builder: (context) =>
    MyApp(token: temptoken), // Wrap your app
    // )
  );
  // runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final String? token;
  MyApp({Key? key, required this.token}) : super(key: key);
  final GAController _gaController = Get.put(GAController());
  final NotificationController notificationController =
      Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaleFactor: 1.0,
        ),
        child: child!,
      ),
      defaultTransition: Transition.rightToLeft,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ko'),
      ],
      navigatorObservers: [_gaController.getAnalyticsObserver()],
      home: token == null ? StartScreen() : App(),
      // WelcomeScreen(token: token),
      locale: DevicePreview.locale(context),
      debugShowCheckedModeBanner: false,
      title: "루프어스",
      theme: MyThemes.lightTheme,
      darkTheme: MyThemes.darkTheme,
      themeMode: ThemeMode.system,
      scrollBehavior: NoGlowScrollBehavior(),
      // const ScrollBehavior(
      //     androidOverscrollIndicator: AndroidOverscrollIndicator.stretch),
      // initialBinding: InitBinding(),
      getPages: [
        GetPage(
          name: "/",
          page: token != null ? () => App() : () => StartScreen(),
        ),
        // GetPage(
        //   name: '/search',
        //   page: () => SearchTypingScreen(),
        //   transition: Transition.fadeIn,
        //   transitionDuration: kAnimationDuration,
        //   curve: kAnimationCurve,
        // ),
      ],
    );
  }
}

class WelcomeScreen extends StatefulWidget {
  String? token;
  WelcomeScreen({this.token});
  @override
  _WelcomeScreenStete createState() => _WelcomeScreenStete(token: token);
}

class _WelcomeScreenStete extends State<WelcomeScreen> {
  String? token;
  _WelcomeScreenStete({this.token});
  @override
  void initState() {
    super.initState();
    localNotificaition.requestPermission();
    Future.delayed(
      const Duration(seconds: 1),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              token == null ? (context) => StartScreen() : (context) => App(),
        ),
      ),
    );
  }

  // Future logAppOpen() async {
  //   await analytics.logEvent(name: 'app open');
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Generated By LOOP',
              textAlign: TextAlign.center,
              style: MyTextTheme.main(context),
            ),
            SizedBox(
              height: 32,
            ),
          ],
        ),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Center(
        child: Container(
          width: Get.width / 2,
          child: Image.asset('assets/illustrations/splash.png'),
        ),
      ),
    );
  }
}
