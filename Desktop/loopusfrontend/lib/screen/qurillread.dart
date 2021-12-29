import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/widgets/simple_viewer.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:tuple/tuple.dart';

class QuillreadScreen extends StatefulWidget {
  const QuillreadScreen({Key? key}) : super(key: key);

  @override
  _QuillreadScreenState createState() => _QuillreadScreenState();
}

QuillController _controller = QuillController.basic();
FocusNode focusNode = FocusNode();
QuillController _excontroller = QuillController(
    selection: TextSelection.collapsed(offset: 0),
    document: Document.fromJson(
      [
        {'insert': '\ㅁ\ㄴ\ㅇ\ㄴ\ㅁ\ㅇ\ㄴ\ㅁ\\\\n\\\\n\\\\n\\\\n'},
        {
          'insert': '\ㅁ\ㄴ\ㅇ\ㄴ\ㅁ\ㅇ\ㅁ\ㄴ',
          'attributes': {'bold': true}
        },
        {
          'insert': '\ㄴ\ㅁ\ㅇ\ㅁ\ㄴ\ㅇ\ㄴ\ㅁ',
          'attributes': {'bold': true, 'underline': true}
        },
        {'insert': '\\\\n\\\\n\\\\n\\\\n\ㅁ\ㄴ\ㅇ\ㅁ\ㄴ\ㅇ\\\\n'},
        {
          'insert': {
            'image':
                'https://loopus.s3.ap-northeast-2.amazonaws.com/image_cropper_1640152840589.jpg'
          }
        },
        {'insert': '\\\\n\\\\n\\\\n\\\\n\ㄴ\ㅁ\ㅇ\ㅁ\ㄴ\ㅇ\ㅁ\ㄴ\\\\n'}
      ],
    ));

class _QuillreadScreenState extends State<QuillreadScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
                child: Container(
              child: QuillEditor(
                controller: _excontroller,
                showCursor: false,
                readOnly: true,
                focusNode: focusNode,
                scrollable: true,
                scrollController: ScrollController(),
                expands: false,
                padding: EdgeInsets.zero,
                autoFocus: false,
                customStyles: DefaultStyles(
                  h1: DefaultTextBlockStyle(
                      TextStyle(
                        fontSize: 34,
                        color: Colors.black,
                        height: 1.15,
                        fontWeight: FontWeight.w300,
                      ),
                      const Tuple2(16, 0),
                      const Tuple2(0, 0),
                      null),
                  h2: DefaultTextBlockStyle(
                      TextStyle(
                        fontSize: 24,
                        color: Colors.black,
                        height: 1.15,
                        fontWeight: FontWeight.normal,
                      ),
                      const Tuple2(8, 0),
                      const Tuple2(0, 0),
                      null),
                  h3: DefaultTextBlockStyle(
                      TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        height: 1.25,
                        fontWeight: FontWeight.w500,
                      ),
                      const Tuple2(8, 0),
                      const Tuple2(0, 0),
                      null),
                ),
              ),
            )),
            TextButton(
                onPressed: () {
                  List text = _excontroller.document.toDelta().toJson();
                  print(jsonEncode(text));
                },
                child: Icon(Icons.add_alert_outlined)),
            // QuillSimpleViewer(controller: _excontroller, readOnly: true)
          ],
        ),
      ),
    );
  }
}
