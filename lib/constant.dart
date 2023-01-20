import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';

import 'package:get/get.dart';
import 'package:loopus/model/project_model.dart';
import 'package:loopus/screen/group_career_detail_screen.dart';
import 'package:loopus/screen/personal_career_detail_screen.dart';

//URL
const String kPersonalInfoCollectionAgreement =
    "https://loopusimage.s3.ap-northeast-2.amazonaws.com/static/%EA%B0%9C%EC%9D%B8%EC%A0%95%EB%B3%B4+%EC%88%98%EC%A7%91%EB%8F%99%EC%9D%98%EC%84%9C+-+%EC%88%98%EC%A0%95.pdf";

const String kPrivacyPolicy =
    "https://loopusimage.s3.ap-northeast-2.amazonaws.com/static/%EA%B0%9C%EC%9D%B8%EC%A0%95%EB%B3%B4%EC%B2%98%EB%A6%AC%EB%B0%A9%EC%B9%A8.pdf";

const String kTermsOfService =
    "https://loopusimage.s3.ap-northeast-2.amazonaws.com/static/%EC%9D%B4%EC%9A%A9%EC%95%BD%EA%B4%80.pdf";

//네트워크 확인
Future<ConnectivityResult> initConnectivity() async {
  late ConnectivityResult result = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  // Platform messages may fail, so we use a try/catch PlatformException.
  try {
    result = await _connectivity.checkConnectivity();
    print(result);
    return result;
  } catch (e) {
    print(e);
    print(result);
    return result;
  }
}

// type
enum UserType {
  company,
  student,
  school,
}

enum Screentype { add, update }

enum SearchType { profile, post, tag, company }

enum PwType { pwchange, pwfind }

enum Tagtype { profile, Posting, question }

enum SelectTagtype { person, interesting }

enum PostaddRoute { project, bottom, update, career }

enum FollowState { normal, follower, following, wefollow }

enum BanState { normal, ban, isbanned }

enum SmartTextType { T, H1, H2, BULLET, IMAGE, LINK, IMAGEINFO }

enum NotificationType {
  empty1, // 그냥 인덱스 맞출려고 넣어 놓은 것
  empty2, // 그냥 인덱스 맞출려고 넣어 놓은 것
  follow,
  careerTag,
  postLike,
  commentLike,
  replyLike,
  comment,
  reply,
  schoolNoti,
  rankUpdate,
  groupCareerPost,
}

enum Emailcertification { normal, waiting, success, fail }

enum ScreenState { normal, loading, disconnect, error, success }

int companyCareerId = 113;

Map<String, String> fieldList = {
  "1": "IT",
  "2": "마케팅",
  "3": "디자인",
  "4": "건축",
  "5": "경영•경제",
  "6": "제조",
  "7": "교육",
  "8": "의료",
  "9": "무역•유통",
  "10": "영업•서비스",
  "11": "R&D",
  "12": "엔지니어링",
  "13": "전문•특수",
  "14": "예체능",
  "15": "기타",
  "16": "미정"
};

class MyThemes {
  static final lightTheme = ThemeData(
      fontFamily: 'SUIT',
      appBarTheme: const AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: AppColors.mainWhite,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.dark,
        ),

        backgroundColor: AppColors.mainWhite,
        // foregroundColor: mainblack,
      ),
      canvasColor: AppColors.mainWhite,
      textTheme: MyTextTheme.textTheme.apply(bodyColor: AppColors.mainblack),
      textSelectionTheme:
          const TextSelectionThemeData(cursorColor: AppColors.mainblue),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          primary: AppColors.mainblack,
          splashFactory: NoSplash.splashFactory,
        ),
      ),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      scrollbarTheme: ScrollbarThemeData(
          thickness: MaterialStateProperty.all(5),
          thumbColor: MaterialStateProperty.all(AppColors.maingray),
          radius: const Radius.circular(10)));

  static final darkTheme = ThemeData(
      fontFamily: 'SUIT',
      appBarTheme: const AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: AppColors.mainblack,
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.light,
        ),

        backgroundColor: AppColors.mainblack,
        // foregroundColor: mainblack,
      ),
      canvasColor: AppColors.mainblack,
      textTheme: MyTextTheme.textTheme.apply(bodyColor: AppColors.mainWhite),
      textSelectionTheme:
          const TextSelectionThemeData(cursorColor: AppColors.mainblue),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          primary: AppColors.mainWhite,
          splashFactory: NoSplash.splashFactory,
        ),
      ),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      scrollbarTheme: ScrollbarThemeData(
          thickness: MaterialStateProperty.all(5),
          thumbColor: MaterialStateProperty.all(AppColors.maingray),
          radius: const Radius.circular(10)));
}

// Colors
class AppColors {
  static const mainblue = Color(0xFF2199FC);
  static const mainblack = Color(0xFF2F2F2F);
  static const mainWhite = Color(0xFFFFFFFF);
  static Color maingray = const Color(0xFFC1C1C1);
  static Color dividegray = const Color(0xFFD0D0D0);
  static Color popupGray = const Color(0xFFEAEAEA).withOpacity(0.5);
  static Color cardGray = const Color(0xFFF1F1F1);
  static Color iconcolor = const Color(0xFF505050);
  static const rankred = Color(0xFFF16A6A);
  static Color lightcardgray = cardGray.withOpacity(0.7);
  static Color rankblue = const Color(0xFF005FAE);
  static Color frameColor = const Color(0xFFB6C7D6);

//-----------------------------------------------------------
  static Color kSplashColor = const Color(0xff33343C).withOpacity(0.1);

  static Color myPostColor = const Color(0xffB0B0B0); // 커리어보드 포스트 분석에 내포스트 수 컬러

}

class MyTextTheme {
  static TextTheme textTheme = const TextTheme(
    titleLarge: TextStyle(
      // title
      fontSize: 25,
      fontWeight: FontWeight.w500,
      fontFamily: 'SUIT',
    ),
    titleMedium: TextStyle(
      // NavigationTitle
      fontSize: 18,
      fontWeight: FontWeight.w500,
      fontFamily: 'SUIT',
    ),
    labelLarge: TextStyle(
      // mainbold
      fontSize: 14,
      fontWeight: FontWeight.w700,
      fontFamily: 'SUIT',
    ),
    labelMedium: TextStyle(
      // main
      fontSize: 14,
      fontWeight: FontWeight.w400,
      fontFamily: 'SUIT',
    ),
    bodyLarge: TextStyle(
      // mainboldheight
      fontSize: 14,
      fontWeight: FontWeight.w700,
      fontFamily: 'SUIT',
    ),
    bodyMedium: TextStyle(
      // mainheight
      fontSize: 14,
      fontWeight: FontWeight.w400,
      fontFamily: 'SUIT',
    ),
    bodySmall: TextStyle(
      // caption
      fontSize: 11,
      fontWeight: FontWeight.w400,
      fontFamily: 'SUIT',
    ),
    labelSmall: TextStyle(
      // tempfont
      fontSize: 11,
      fontWeight: FontWeight.w400,
      fontFamily: 'SUIT',
    ),
  );

  static TextStyle title(BuildContext context) {
    return Theme.of(context).textTheme.titleLarge!;
  }

  static TextStyle navigationTitle(BuildContext context) {
    return Theme.of(context).textTheme.titleMedium!;
  }

  static TextStyle mainbold(BuildContext context) {
    return Theme.of(context).textTheme.labelLarge!;
  }

  static TextStyle main(BuildContext context) {
    return Theme.of(context).textTheme.labelMedium!;
  }

  static TextStyle mainboldheight(BuildContext context) {
    return Theme.of(context).textTheme.bodyLarge!;
  }

  static TextStyle mainheight(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!;
  }

  static TextStyle caption(BuildContext context) {
    return Theme.of(context).textTheme.bodySmall!;
  }

  static TextStyle tempfont(BuildContext context) {
    return Theme.of(context).textTheme.labelSmall!;
  }
}

//Animation
const kAnimationDuration = Duration(milliseconds: 300);
const kAnimationCurve = Curves.easeInOut;

Widget kProfilePlaceHolder() {
  return CircleAvatar(
    backgroundColor: AppColors.maingray,
    child: Container(),
  );
}

Widget kImagePlaceHolder() {
  return Container(
    color: AppColors.maingray,
  );
}

//Get.back 반복
void getbacks(int number) {
  for (int i = 0; i < number; i++) {
    Get.back();
  }
}

void dialogBack({bool modalIOS = false}) {
  Get.until((route) {
    // print(!(Get.isDialogOpen! || Get.isBottomSheetOpen!));
    return !(Get.isDialogOpen! || Get.isBottomSheetOpen!);
  });
  if (modalIOS) {
    Get.back();
  }
}

void goCareerScreen(Project career, String name) {
  Get.to(() => career.isPublic
      ? GroupCareerDetailScreen(
          career: career,
          name: name,
        )
      : PersonalCareerDetailScreen(
          career: career,
          name: name,
        ));
}
