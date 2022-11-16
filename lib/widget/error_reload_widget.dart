import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loopus/constant.dart';

class ErrorReloadWidget extends StatelessWidget {
  ErrorReloadWidget({Key? key, required this.reload}) : super(key: key);

  Function()? reload;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(
          "오류가 발생했어요",
          style: MyTextTheme.main(context),
        ),
        IconButton(
          onPressed: reload,
          icon: SvgPicture.asset('assets/icons/refresh.svg'),
        ),
        const SizedBox(
          height: 60,
        ),
      ]),
    );
  }
}
