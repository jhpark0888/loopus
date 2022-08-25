import 'dart:ffi';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

extension _TextMeasurer on RichText {
  List<TextBox> measure(BuildContext context, Constraints constraints) {
    final renderObject = createRenderObject(context)..layout(constraints);
    return renderObject.getBoxesForSelection(
      TextSelection(
        baseOffset: 0,
        extentOffset: text.toPlainText().length,
      ),
    );
  }
}

class ExpandableText extends StatefulWidget {
  final TextSpan textSpan;
  final TextSpan moreSpan;
  final int maxLines;

  const ExpandableText({
    Key? key,
    required this.textSpan,
    required this.maxLines,
    required this.moreSpan,
  })  : assert(textSpan != null),
        assert(maxLines != null),
        assert(moreSpan != null),
        super(key: key);

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  static const String _ellipsis = ""; // Unicode symbols for "… "

  bool _isExpanded = false;
  String get _lineEnding => "$_ellipsis${widget.moreSpan.text}";
  // GestureRecognizer get _tapRecognizer => TapGestureRecognizer()
  //   ..onTap = () {
  //     print(_isExpanded);
  //     setState(() {
  //       // _isExpanded = !_isExpanded;
  //     });
  //   };

  @override
  Widget build(BuildContext context) =>
      LayoutBuilder(builder: (context, constraints) {
        final maxLines = widget.maxLines;

        final richText = Text.rich(widget.textSpan).build(context) as RichText;
        final boxes = richText.measure(context, constraints);

        if (_getBoxesMaxLinesIndex(boxes, maxLines) ==
                boxes.indexOf(boxes.last) ||
            _isExpanded) {
          return RichText(text: widget.textSpan);
        } else {
          final croppedText = _ellipsizeText(boxes);
          final ellipsizedText = _buildEllipsizedText(
            croppedText,
          );

          if (ellipsizedText.measure(context, constraints).length <= maxLines) {
            return ellipsizedText;
          } else {
            final fixedEllipsizedText = croppedText.characters.getRange(
                0, croppedText.characters.length - _lineEnding.length);

            return _buildEllipsizedText(
              fixedEllipsizedText.string,
            );
          }
        }
      });

  double _calculateLinesLength(List<TextBox> boxes) => boxes
      .map((box) => box.right - box.left)
      .reduce((acc, value) => acc += value);

  String _ellipsizeText(List<TextBox> boxes) {
    final text = widget.textSpan.text;
    final maxLines = widget.maxLines;

    final requiredLength = _calculateLinesLength(
        boxes.sublist(0, _getBoxesMaxLinesIndex(boxes, maxLines) + 1));
    final totalLength = _calculateLinesLength(boxes);

    final requiredTextFraction = requiredLength / totalLength;
    return text!.characters
        .getRange(0, (text.characters.length * requiredTextFraction).floor())
        .string;
  }

  RichText _buildEllipsizedText(
    String text,
  ) =>
      RichText(
        text: TextSpan(
          // recognizer: tapRecognizer,
          text: text,
          style: widget.textSpan.style,
          children: [widget.moreSpan],
        ),
      );

  int _getBoxesMaxLinesIndex(List<TextBox> boxes, int maxLines) {
    int linenum = 0;
    for (int i = 0; i < boxes.length; i++) {
      if (boxes[i].left == 0) {
        linenum += 1;
      }
      if (linenum == maxLines + 1) {
        return i - 1;
      }
    }

    return boxes.indexOf(boxes.last);
  }
}
