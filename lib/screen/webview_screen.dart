import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/webview_controller.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatelessWidget {
  WebViewScreen({Key? key, required this.url}) : super(key: key);

  String? url;
  final WebController _webController = Get.put(WebController());
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          //TODO : LINK 패턴 관리
          url!.replaceFirst('https://', ''),
          style: TextStyle(fontSize: 14),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          child: Obx(
            () => Stack(
              children: [
                Container(
                  color: Color(0xffe7e7e7),
                  height: (_webController.progressPercent.value != 100) ? 4 : 0,
                ),
                if (_webController.progressPercent.value != 100)
                  Obx(
                    () => Container(
                      decoration: BoxDecoration(
                        color: mainblue,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(2),
                          bottomRight: Radius.circular(2),
                        ),
                      ),
                      width: Get.width * (_webController.progressPercent / 100),
                      height: 4,
                    ),
                  ),
              ],
            ),
          ),
          preferredSize: Size.fromHeight(4.0),
        ),
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: mainWhite,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: SvgPicture.asset('assets/icons/Arrow.svg'),
        ),
        actions: [],
      ),
      body: Builder(builder: (BuildContext context) {
        return WebView(
          initialUrl: url,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
          onProgress: (int progress) {
            print('WebView is loading (progress : $progress%)');
            _webController.progressPercent.value = progress;
          },
          javascriptChannels: <JavascriptChannel>{
            _toasterJavascriptChannel(context),
          },
          navigationDelegate: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              print('blocking navigation to $request}');
              return NavigationDecision.prevent;
            }
            print('allowing navigation to $request');
            return NavigationDecision.navigate;
          },
          onPageStarted: (String url) {
            print('Page started loading: $url');
          },
          onPageFinished: (String url) {
            print('Page finished loading: $url');
          },
          gestureNavigationEnabled: true,
          backgroundColor: const Color(0x00000000),
        );
      }),
      bottomNavigationBar: BottomAppBar(
        child: NavigationControls(_controller.future),
      ),
    );
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          // ignore: deprecated_member_use
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }
}

class NavigationControls extends StatelessWidget {
  const NavigationControls(this._webViewControllerFuture);

  final Future<WebViewController> _webViewControllerFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
      future: _webViewControllerFuture,
      builder:
          (BuildContext context, AsyncSnapshot<WebViewController> snapshot) {
        final bool webViewReady =
            snapshot.connectionState == ConnectionState.done;
        final WebViewController? controller = snapshot.data;
        return Row(
          children: <Widget>[
            IconButton(
              icon: SvgPicture.asset('assets/icons/Arrow_left.svg'),
              onPressed: !webViewReady
                  ? null
                  : () async {
                      if (await controller!.canGoBack()) {
                        await controller.goBack();
                      } else {
                        // ignore: deprecated_member_use
                        ModalController.to
                            .showCustomDialog('이전 페이지가 없어요', 1000);
                        return;
                      }
                    },
            ),
            SizedBox(
              width: 12,
            ),
            IconButton(
              icon: SvgPicture.asset('assets/icons/Arrow_right.svg'),
              onPressed: !webViewReady
                  ? null
                  : () async {
                      if (await controller!.canGoForward()) {
                        await controller.goForward();
                      } else {
                        // ignore: deprecated_member_use
                        ModalController.to
                            .showCustomDialog('다음 페이지가 없어요', 1000);
                        return;
                      }
                    },
            ),
            SizedBox(
              width: 12,
            ),
            IconButton(
              icon: SvgPicture.asset('assets/icons/Refresh.svg'),
              onPressed: !webViewReady
                  ? null
                  : () {
                      controller!.reload();
                    },
            ),
          ],
        );
      },
    );
  }
}
