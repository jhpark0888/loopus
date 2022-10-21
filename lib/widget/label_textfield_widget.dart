import 'package:flutter/material.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/widget/custom_textfield.dart';

class LabelTextFieldWidget extends StatelessWidget {
  LabelTextFieldWidget({
    Key? key,
    required this.label,
    required this.hintText,
    required this.textController,
    this.labelBold = true,
    this.readOnly,
    this.obscureText,
    this.maxLength,
    this.ontap,
    this.validator,
    this.suffix,
    this.keyboardType,
  }) : super(key: key);

  String label;
  bool labelBold;
  String hintText;
  TextEditingController textController;
  bool? readOnly;
  bool? obscureText;
  int? maxLength;
  Function()? ontap;
  String? Function(String?)? validator;
  Widget? suffix;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            label,
            style: labelBold ? kmainbold : kmainheight,
          ),
          const SizedBox(
            height: 14,
          ),
          CustomTextField(
            counterText: null,
            maxLength: null,
            textController: textController,
            keyboardType: keyboardType,
            hintText: hintText,
            suffix: suffix,
            validator: validator,
            obscureText: obscureText ?? false,
            readOnly: readOnly,
            maxLines: 1,
            ontap: ontap,
          ),
        ],
      ),
    );
  }
}
