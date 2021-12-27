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
            name: "/", page: token != null ? () => App() : () => LogInPage()),
        //   GetPage(
        //     name: "/feed/:id",
        //     page: () => FeedPage(),
        //     binding: BindingsBuilder(
        //       () => Get.lazyPut<FeedController>(() => FeedController()),
        //     ),
        //   ),
        //   GetPage(
        //     name: "/noimagefeed/:id",
        //     page: () => NoimageFeedPage(),
        //     binding: BindingsBuilder(
        //       () => Get.lazyPut<FeedController>(() => FeedController(),
        //           fenix: true),
        //     ),
        //   ),
        //   GetPage(
        //     name: "/noticedetail",
        //     page: () => NoticeDetailPage(),
        //     // binding: BindingsBuilder(
        //     //   () => Get.lazyPut<NoticeController>(() => NoticeController()),
        //     // ),
        //   ),
        //   GetPage(name: "/detailnotice", page: () => DetailNoticePage()),
        //   GetPage(name: "/message", page: () => MessagePage()),
        //   // GetPage(name: "/myprofilecustom", page: () => MyProfileCustomPage()),
        //   GetPage(name: "/searchpersonal", page: () => SearchPersonalPage()),
        //   GetPage(name: "/searchpost", page: () => SearchPostPage()),
        //   GetPage(name: "/touchwithlistpage", page: () => TouchWithListPage()),
        //   GetPage(name: "/uploadcheck", page: () => UploadCheckPage()),
        //   GetPage(name: "/upload", page: () => UploadPage()),
        //   GetPage(name: "/pushalarm", page: () => PushAlarmPage()),
        //   GetPage(name: "/edit", page: () => EditPage()),
        //   GetPage(name: "/searchdetail", page: () => SearchDetailPage()),
        //   GetPage(name: "/group", page: () => GroupPage()),
        //   GetPage(name: "/likelist", page: () => LikeListPage()),
        //   GetPage(name: "/profile", page: () => ProfilePage()),
      ],
    );
  }
}
