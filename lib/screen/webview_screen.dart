import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/webview_controller.dart';
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
        title: (url == kTermsOfService ||
                url == kPersonalInfoCollectionAgreement ||
                url == kPrivacyPolicy)
            ? Text(
                //TODO : LINK 패턴 관리
                url! == kTermsOfService
                    ? '서비스 이용약관'
                    : url! == kPersonalInfoCollectionAgreement
                        ? '개인정보 수집동의'
                        : url! == kPrivacyPolicy
                            ? '개인정보 처리방침'
                            : '',
                style: kNavigationTitle,
              )
            : Text(
                //TODO : LINK 패턴 관리
                url!.contains('http://')
                    ? url!.replaceFirst('http://', '')
                    : url!.replaceFirst('https://', ''),
                style: kNavigationTitle,
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
                      decoration: const BoxDecoration(
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
          icon: SvgPicture.asset('assets/icons/appbar_back.svg'),
        ),
        actions: [],
      ),
      body: Obx(
        () => (_webController.isWrongUrl.value == false)
            ? Builder(builder: (BuildContext context) {
                return WebView(
                  zoomEnabled: true,
                  onWebResourceError: (error) {
                    _webController.isWrongUrl.value = true;
                  },
                  initialUrl: url!.endsWith(".pdf")
                      ? Platform.isIOS
                          ? url
                          : "http://docs.google.com/gview?embedded=true&url=" +
                              url!
                      : url,
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
                    // if (request.url.startsWith('https://www.youtube.com/')) {
                    //   print('blocking navigation to $request}');
                    //   return NavigationDecision.prevent;
                    // }
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
              })
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '유효하지 않은 링크에요',
                    textAlign: TextAlign.center,
                  ),
                  TextButton(
                    onPressed: () {
                      showCustomDialog('알려주셔서 감사합니다!', 1000);
                    },
                    child: Text(
                      '이 버튼만 클릭해서 잘못된 링크인 걸 알려주세요',
                      textAlign: TextAlign.center,
                      style: ktempFont.copyWith(
                        color: mainblue,
                      ),
                    ),
                  ),
                  Text(
                    '상대방은 누가 버튼을 클릭했는지 알 수 없어요',
                    textAlign: TextAlign.center,
                    style: ktempFont.copyWith(
                      color: mainblack.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
      ),
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
              padding: EdgeInsets.zero,
              icon: SvgPicture.asset('assets/icons/arrow_left.svg'),
              onPressed: !webViewReady
                  ? null
                  : () async {
                      if (await controller!.canGoBack()) {
                        await controller.goBack();
                      } else {
                        // ignore: deprecated_member_use
                        showCustomDialog('이전 페이지가 없어요', 1000);
                        return;
                      }
                    },
            ),
            SizedBox(
              width: 10,
            ),
            IconButton(
              padding: EdgeInsets.zero,
              icon: SvgPicture.asset('assets/icons/arrow_right.svg'),
              onPressed: !webViewReady
                  ? null
                  : () async {
                      if (await controller!.canGoForward()) {
                        await controller.goForward();
                      } else {
                        // ignore: deprecated_member_use
                        showCustomDialog('다음 페이지가 없어요', 1000);
                        return;
                      }
                    },
            ),
            SizedBox(
              width: 10,
            ),
            IconButton(
              padding: EdgeInsets.zero,
              icon: SvgPicture.asset('assets/icons/refresh.svg'),
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
