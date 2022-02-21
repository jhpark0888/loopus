import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DisconnectReloadWidget extends StatelessWidget {
  DisconnectReloadWidget({Key? key, required this.reload}) : super(key: key);

  Function()? reload;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text("네트워크 연결을 확인해주세요"),
        IconButton(
          onPressed: reload,
          icon: SvgPicture.asset('assets/icons/Refresh.svg'),
        ),
        SizedBox(
          height: 60,
        ),
      ]),
    );
  }
}
