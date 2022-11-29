import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class FileDownloadWidget extends StatefulWidget {
  FileDownloadWidget(
      {Key? key, required this.file, required this.downLoadValidPeriod})
      : super(key: key);
  String file;
  DateTime downLoadValidPeriod;

  @override
  State<FileDownloadWidget> createState() => _FileDownloadWidgetState();
}

class _FileDownloadWidgetState extends State<FileDownloadWidget> {
  final ReceivePort _port = ReceivePort();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      setState(() {});
    });

    FlutterDownloader.registerCallback(downloadCallback);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  @pragma('vm:entry-point')
  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    print(
        'Background Isolate Callback: task ($id) is in status ($status) and process ($progress)');
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port')!;
    send.send([id, status, progress]);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (widget.downLoadValidPeriod.isAfter(DateTime.now())) {
          if (await canLaunchUrlString(widget.file)) {
            launchUrlString(widget.file, mode: LaunchMode.externalApplication);
          }
          // String dir = (await getApplicationDocumentsDirectory())
          //     .path; //path provider로 저장할 경로 가져오기
          // print("저장 주소: $dir");
          // try {
          //   await FlutterDownloader.enqueue(
          //     url: widget.file, // file url
          //     savedDir: dir + Platform.pathSeparator, // 저장할 dir
          //     fileName: Uri.decodeFull(widget.file.split("/").last), // 파일명
          //     saveInPublicStorage: true, // 동일한 파일 있을 경우 덮어쓰기 없으면 오류발생함!
          //   ).then((value) {
          //     print("다운로드: $value");
          //   });
          //   showCustomDialog("저장주소: $dir", 1000);
          // } catch (e) {
          //   showCustomDialog("다운로드에 실패 하였습니다", 1000);
          // }
        } else {
          showCustomDialog("다운로드 기간이 만료 되었습니다.", 1000);
        }
      },
      behavior: HitTestBehavior.translucent,
      child: Container(
        width: Get.width,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            SvgPicture.asset('assets/icons/file_icon.svg'),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Uri.decodeFull(widget.file.split("/").last),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: MyTextTheme.main(context),
                  ),
                  Text(
                    "${DateFormat('yyyy년 MM월 dd일').format(widget.downLoadValidPeriod)}까지 다운로드 가능",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: MyTextTheme.main(context)
                        .copyWith(color: AppColors.dividegray),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
