import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:loopus/model/post_model.dart';
import 'package:tuple/tuple.dart';

class PostingEditor extends StatelessWidget {
  PostingEditor(
      {Key? key,
      required this.controller,
      this.readonly,
      this.showcursor,
      this.placeholder})
      : super(key: key);

  QuillController controller;
  bool? readonly;
  bool? showcursor;
  String? placeholder;

  @override
  Widget build(BuildContext context) {
    print(readonly);
    return QuillEditor(
      placeholder: placeholder ?? '',
      controller: controller,
      readOnly: readonly ?? false,
      showCursor: showcursor ?? true,
      focusNode: FocusNode(),
      scrollable: true,
      scrollController: ScrollController(),
      expands: false,
      padding: EdgeInsets.zero,
      autoFocus: false,
      customStyles: DefaultStyles(
        paragraph: DefaultTextBlockStyle(
            TextStyle(
              fontSize: 14,
              color: Colors.black,
              height: 1.5,
            ),
            const Tuple2(0, 0),
            const Tuple2(0, 0),
            null),
        h1: DefaultTextBlockStyle(
            TextStyle(
              fontSize: 20,
              color: Colors.black,
              height: 1.6,
              fontWeight: FontWeight.bold,
            ),
            const Tuple2(16, 0),
            const Tuple2(0, 0),
            null),
        h2: DefaultTextBlockStyle(
            TextStyle(
              fontSize: 16,
              color: Colors.black,
              height: 1.6,
              fontWeight: FontWeight.bold,
            ),
            const Tuple2(8, 0),
            const Tuple2(0, 0),
            null),
        h3: DefaultTextBlockStyle(
            TextStyle(
              fontSize: 16,
              color: Colors.black,
              height: 1.6,
              fontWeight: FontWeight.w500,
            ),
            const Tuple2(8, 0),
            const Tuple2(0, 0),
            null),
      ),
    );
  }
}

Widget getReadEditor(List<dynamic> json) {
  QuillController readController = QuillController(
    document: Document.fromJson(json),
    selection: const TextSelection.collapsed(offset: 0),
  );
  return PostingEditor(
    controller: readController,
    readonly: true,
    showcursor: false,
  );
}
