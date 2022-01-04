import 'package:flutter/material.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatelessWidget {
  WebViewScreen({Key? key, required this.url}) : super(key: key);

  String? url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: '웹뷰'),
      body: WebView(
        initialUrl: url,
      ),
    );
  }
}
