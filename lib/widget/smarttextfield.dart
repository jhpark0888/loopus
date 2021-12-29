import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';

enum SmartTextType { H1, H2, T, QUOTE, BULLET }

extension SmartTextStyle on SmartTextType {
  TextStyle get textStyle {
    switch (this) {
      case SmartTextType.QUOTE:
        return TextStyle(
          fontSize: 16.0,
          fontStyle: FontStyle.italic,
          color: mainblack,
          height: 1.5,
        );
      case SmartTextType.H1:
        return TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          height: 1.6,
          color: mainblack,
        );
      case SmartTextType.H2:
        return TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          height: 1.6,
          color: mainblack,
        );
        break;
      default:
        return TextStyle(fontSize: 16.0, height: 1.6, color: mainblack);
    }
  }

  EdgeInsets get padding {
    switch (this) {
      case SmartTextType.H1:
        return EdgeInsets.fromLTRB(16, 8, 16, 0);
      case SmartTextType.H2:
        return EdgeInsets.fromLTRB(16, 8, 16, 0);
        break;
      case SmartTextType.BULLET:
        return EdgeInsets.fromLTRB(24, 8, 16, 0);
      default:
        return EdgeInsets.fromLTRB(16, 8, 16, 0);
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
          autocorrect: false,
          controller: controller,
          focusNode: focusNode,
          autofocus: true,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          cursorColor: mainblue,
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
