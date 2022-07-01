import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ErrorReloadWidget extends StatelessWidget {
  ErrorReloadWidget({Key? key, required this.reload}) : super(key: key);

  Function()? reload;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Text("오류가 발생했어요..."),
        IconButton(
          onPressed: reload,
          icon: SvgPicture.asset('assets/icons/Refresh.svg'),
        ),
        const SizedBox(
          height: 60,
        ),
      ]),
    );
  }
}
