import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
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
import 'package:new_version_plus/new_version_plus.dart';
import 'controller/notification_controller.dart';
import 'package:loopus/utils/custom_new_version_plus.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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

  await dotenv.load();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  // debugPrintGestureArenaDiagnostics = true;
  await FlutterDownloader.initialize(debug: true, ignoreSsl: true);
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

  // 토큰 여부 확인
  String? temptoken = await const FlutterSecureStorage().read(key: 'token');

  // 업데이트 여부 확인
  final UpdateController updateController = Get.put(UpdateController());
  await updateController.checkRequiredUpdate();

  await GetStorage.init();

  runApp(
    MyApp(
      token: temptoken,
    ), // Wrap your app
    // )
  );
}

class MyApp extends StatelessWidget {
  final String? token;
  MyApp({
    Key? key,
    required this.token,
  }) : super(key: key);
  final GAController _gaController = Get.put(GAController());
  final NotificationController notificationController =
      Get.put(NotificationController());
  final UpdateController _updateController = Get.find<UpdateController>();

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
      home: _updateController.isRequiredUpdate
          ? UpdateScreen()
          : token == null
              ? StartScreen()
              : App(),
      // WelcomeScreen(token: token),
      locale: DevicePreview.locale(context),
      debugShowCheckedModeBanner: false,
      title: "루프어스",
      theme: MyThemes.lightTheme,
      // darkTheme: MyThemes.darkTheme,
      themeMode: ThemeMode.light,
      scrollBehavior: NoGlowScrollBehavior(),
      // const ScrollBehavior(
      //     androidOverscrollIndicator: AndroidOverscrollIndicator.stretch),
      getPages: [
        GetPage(
          name: "/",
          page: () => _updateController.isRequiredUpdate
              ? UpdateScreen()
              : token != null
                  ? App()
                  : StartScreen(),
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

class UpdateScreen extends StatefulWidget {
  UpdateScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  final UpdateController _updateController = Get.find<UpdateController>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback(
      (_) {
        // Execute callback if page is mounted
        _updateController.newVersionPlus.showUpdateDialog(
            context: context,
            versionStatus: _updateController.status!,
            dialogText: "루프어스를 이용하기 위해서 필수 업데이트가 필요합니다.",
            dialogTitle: "업데이트 알림",
            allowDismissal: false,
            updateButtonText: "업데이트");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: Get.width / 2,
          child: Image.asset(
            'assets/illustrations/loop_splash.png',
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
