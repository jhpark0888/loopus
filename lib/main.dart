import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import 'package:loopus/app.dart';
import 'package:loopus/binding/init_binding.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/firebase_options.dart';

import 'package:loopus/screen/search_typing_screen.dart';
import 'package:loopus/screen/start_screen.dart';

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
  String? temptoken = await const FlutterSecureStorage().read(key: 'token');

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
  const MyApp({Key? key, required this.token}) : super(key: key);

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
      home: WelcomeScreen(token: token),
      locale: DevicePreview.locale(context),
      debugShowCheckedModeBanner: false,
      title: "루프어스",
      theme: ThemeData(
        fontFamily: 'Nanum',
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
      const Duration(seconds: 3),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              token == null ? (context) => StartScreen() : (context) => App(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainWhite,
      body: SizedBox(
        height: Get.height,
        width: Get.width,
        child: Lottie.asset("assets/lotties/loopus_splash.json",
            repeat: false, frameRate: FrameRate.max),
      ),
    );
  }
}
