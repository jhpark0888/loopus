import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

enum SmartTextType { H1, T, QUOTE, BULLET }

extension SmartTextStyle on SmartTextType {
  TextStyle get textStyle {
    switch (this) {
      case SmartTextType.QUOTE:
        return TextStyle(
            fontSize: 16.0, fontStyle: FontStyle.italic, color: Colors.black);
      case SmartTextType.H1:
        return TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold);
        break;
      default:
        return TextStyle(fontSize: 16.0);
    }
  }

  EdgeInsets get padding {
    switch (this) {
      case SmartTextType.H1:
        return EdgeInsets.fromLTRB(16, 24, 16, 8);
        break;
      case SmartTextType.BULLET:
        return EdgeInsets.fromLTRB(24, 8, 16, 8);
      default:
        return EdgeInsets.fromLTRB(16, 8, 16, 8);
    }
  }

  TextAlign get align {
    switch (this) {
      case SmartTextType.QUOTE:
        return TextAlign.center;
        break;
      default:
        return TextAlign.start;
    }
  }

  String? get prefix {
    switch (this) {
      case SmartTextType.BULLET:
        return '\u2022 ';
        break;
      default:
        return null;
    }
  }
}

class SmartTextField extends StatelessWidget {
  const SmartTextField(
      {Key? key, required this.type, this.controller, this.focusNode})
      : super(key: key);

  final Rx<SmartTextType> type;
  final TextEditingController? controller;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => TextField(
          controller: controller,
          focusNode: focusNode,
          autofocus: true,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          cursorColor: Colors.teal,
          textAlign: type.value.align,
          decoration: InputDecoration(
              border: InputBorder.none,
              prefixText: type.value.prefix,
              prefixStyle: type.value.textStyle,
              isDense: true,
              contentPadding: type.value.padding),
          style: type.value.textStyle,
          toolbarOptions: ToolbarOptions(copy: true, paste: true)),
    );
  }
}

class CustomToolbarOptions extends ToolbarOptions {}
