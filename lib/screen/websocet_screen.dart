import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/widget/career_rank_widget.dart';
import 'package:web_socket_channel/io.dart';

class WebsoketScreen extends StatelessWidget {
  WebsoketScreen({Key? key}) : super(key: key);
  WebsoketController controller = Get.put(WebsoketController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('웹소켓'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextFormField(
              controller: controller.sendText,
              onFieldSubmitted: (string) {
                controller.channel.sink.add(controller.sendText.text);
              },
            ),
            Center(
                child: IconButton(
                    onPressed: () {
                      controller.channel.sink.add(jsonEncode({'message': '야'}));
                      print('눌림');
                    },
                    icon: Text('보내기'))),
            StreamBuilder(
                stream: controller.channel.stream,
                builder: (context, snapshot) {
                  return Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(snapshot.hasData ? '${snapshot.data}' : ''));
                })
            // CareerRankWidget(isUniversity: true)
          ],
        ),
      ),
    );
  }
}

class WebsoketController extends GetxController {
  var channel = IOWebSocketChannel.connect(
      Uri.parse('ws://192.168.35.43:8000/ws/chat/2/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Token 77480185d4d0bcbda684f0ded385d830f5925728'
      });
  TextEditingController sendText = TextEditingController();
  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }
}
