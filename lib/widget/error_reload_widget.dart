import 'package:flutter/material.dart';

class ErrorReloadWidget extends StatelessWidget {
  ErrorReloadWidget({Key? key, required this.reload}) : super(key: key);

  Function()? reload;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text("에러 발생"),
        IconButton(onPressed: reload, icon: Icon(Icons.refresh_rounded)),
        SizedBox(
          height: 60,
        ),
      ]),
    );
  }
}
