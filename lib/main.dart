import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/app.dart';
import 'package:loopus/binding/init_binding.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/screen/home_screen.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  // String? temptoken = await FlutterSecureStorage().read(key: 'token');
  // print(temptoken);
  // runApp(MyApp(token: temptoken));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Loop Us",
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: mainWhite,
          foregroundColor: mainFontDark,
        ),
        backgroundColor: mainWhite,
        // primaryColor: mainWhite,
        // brightness: Brightness.dark,
        textTheme: const TextTheme(
          bodyText1: TextStyle(color: mainFontDark),
          bodyText2: TextStyle(color: mainFontDark),
        ).apply(bodyColor: mainFontDark),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            primary: mainFontDark,
          ),
        ),
      ),
      initialBinding: InitBinding(),
      getPages: [
        GetPage(name: "/", page: () => App()),
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
