import 'dart:io';

import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl_standalone.dart';
import 'package:loopus/controller/ga_controller.dart';
import 'package:loopus/app.dart';
import 'package:loopus/binding/init_binding.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/firebase_options.dart';
import 'package:loopus/screen/start_screen.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  print(message);
  showCustomSnackbar('', '', (aa) {});
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // debugPrintGestureArenaDiagnostics = true;
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: mainblack,
    systemNavigationBarIconBrightness: Brightness.light,
    statusBarColor: mainWhite, // status bar color
  ));
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
  final ThemeData themeData = ThemeData(
      fontFamily: 'SUIT',
      appBarTheme: const AppBarTheme(
        backgroundColor: mainWhite,
        foregroundColor: mainblack,
      ),
      canvasColor: mainWhite,
      textTheme: const TextTheme(
        bodyText1: TextStyle(color: mainblack),
        bodyText2: TextStyle(color: mainblack),
      ).apply(bodyColor: mainblack),
      textSelectionTheme: const TextSelectionThemeData(cursorColor: mainblue),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          primary: mainblack,
          splashFactory: NoSplash.splashFactory,
        ),
      ),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      scrollbarTheme: ScrollbarThemeData(
          thickness: MaterialStateProperty.all(5),
          thumbColor: MaterialStateProperty.all(maingray),
          radius: const Radius.circular(10)));

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaleFactor: 1.0,
        ),
        child: child!,
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ko'),
      ],
      navigatorObservers: [_gaController.getAnalyticsObserver()],
      home: WelcomeScreen(token: token),
      locale: DevicePreview.locale(context),
      debugShowCheckedModeBanner: false,
      title: "루프어스",
      theme: themeData,
      // themeMode: ThemeMode.system,
      scrollBehavior: const ScrollBehavior(
          androidOverscrollIndicator: AndroidOverscrollIndicator.stretch),
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
    Future.delayed(
      const Duration(seconds: 1),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              token == null ? (context) => StartScreen() : (context) => App(),
          //     (context) => ProjectAddTitleScreen(
          //   screenType: Screentype.add,
          // ),
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
              style: TextStyle(
                fontSize: 10,
                color: mainblack.withOpacity(0.6),
              ),
            ),
            SizedBox(
              height: 32,
            ),
          ],
        ),
      ),
      backgroundColor: mainWhite,
      body: Container(
        width: Get.width,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/illustrations/splash_image.png",
              fit: BoxFit.contain,
              width: Get.width / 2,
            ),
          ],
        ),
      ),
    );
  }
}
