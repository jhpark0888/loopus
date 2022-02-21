import 'package:flutter/material.dart';

class DisconnectReloadWidget extends StatelessWidget {
  DisconnectReloadWidget({Key? key, required this.reload}) : super(key: key);

  Function()? reload;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text("네트워크 불안정"),
        IconButton(onPressed: reload, icon: Icon(Icons.refresh_rounded)),
        SizedBox(
          height: 60,
        ),
      ]),
    );
  }
}
