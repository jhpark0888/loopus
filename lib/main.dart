import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:get/get.dart';
import 'package:loopus/app.dart';
import 'package:loopus/binding/init_binding.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/screen/home_screen.dart';
import 'package:loopus/screen/login_screen.dart';
import 'package:loopus/screen/search_typing_screen.dart';
import 'package:loopus/screen/start_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String? temptoken = await FlutterSecureStorage().read(key: 'token');
  print(temptoken);

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
      home: WelcomeScreen(token: token),
      locale: DevicePreview.locale(context),
      debugShowCheckedModeBanner: false,
      title: "Loop Us",
      theme: ThemeData(
        fontFamily: 'Nanum',
        appBarTheme: const AppBarTheme(
          backgroundColor: mainWhite,
          foregroundColor: mainblack,
        ),
        canvasColor: mainWhite,
        // brightness: Brightness.dark,
        textTheme: const TextTheme(
          bodyText1: TextStyle(color: mainblack),
          bodyText2: TextStyle(color: mainblack),
        ).apply(bodyColor: mainblack),
        textSelectionTheme: TextSelectionThemeData(cursorColor: mainblack),
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
        GetPage(
          name: '/search',
          page: () => SearchTypingScreen(),
          transition: Transition.fadeIn,
        ),
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
    new Future.delayed(
        const Duration(seconds: 3),
        () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: token == null
                      ? (context) => StartScreen()
                      : (context) => App()),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainWhite,
      body: Container(
        height: Get.height,
        width: Get.width,
        child: Image.asset("assets/illustrations/splash_animation.gif",
            gaplessPlayback: true),
      ),
    );
  }
}
