import 'dart:io';

import 'package:device_preview/device_preview.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl_standalone.dart';
import 'package:loopus/controller/ga_controller.dart';
// import 'package:kakao_flutter_sdk/link.dart';
import 'package:lottie/lottie.dart';

import 'package:loopus/app.dart';
import 'package:loopus/binding/init_binding.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/firebase_options.dart';

import 'package:loopus/screen/search_typing_screen.dart';
import 'package:loopus/screen/start_screen.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
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
      theme: ThemeData(
        pageTransitionsTheme: PageTransitionsTheme(
          builders: {
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
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
        textSelectionTheme:
            const TextSelectionThemeData(cursorColor: mainblack),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            primary: mainblack,
            splashFactory: NoSplash.splashFactory,
          ),
        ),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      initialBinding: InitBinding(),
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
