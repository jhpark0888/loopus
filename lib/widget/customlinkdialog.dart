import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as Quill;

class CustomLinkDialog extends StatefulWidget {
  const CustomLinkDialog({this.dialogTheme, Key? key}) : super(key: key);

  final Quill.QuillDialogTheme? dialogTheme;

  @override
  CustomLinkDialogState createState() => CustomLinkDialogState();
}

class CustomLinkDialogState extends State<CustomLinkDialog> {
  String _link = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: widget.dialogTheme?.dialogBackgroundColor,
      content: TextField(
        style: widget.dialogTheme?.inputTextStyle,
        decoration: InputDecoration(
            labelText: '링크를 입력해주세요',
            labelStyle: widget.dialogTheme?.labelTextStyle,
            floatingLabelStyle: widget.dialogTheme?.labelTextStyle),
        autofocus: true,
        onChanged: _linkChanged,
      ),
      actionsAlignment: MainAxisAlignment.start,
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('아니요'),
        ),
        TextButton(
          onPressed: _link.isNotEmpty ? _applyLink : null,
          child: Text('네'),
        ),
      ],
    );
  }

  void _linkChanged(String value) {
    setState(() {
      _link = value;
    });
  }

  void _applyLink() {
    Navigator.pop(context, _link);
  }
}
