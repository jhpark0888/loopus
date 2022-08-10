import 'package:flutter/material.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/widget/custom_textfield.dart';

class LabelTextFieldWidget extends StatelessWidget {
  LabelTextFieldWidget({
    Key? key,
    required this.label,
    required this.hintText,
    required this.textController,
    this.readOnly,
    this.obscureText,
    this.maxLength,
    this.ontap,
    this.validator,
    this.suffix,
  }) : super(key: key);

  String label;
  String hintText;
  TextEditingController textController;
  bool? readOnly;
  bool? obscureText;
  int? maxLength;
  Function()? ontap;
  String? Function(String?)? validator;
  Widget? suffix;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(
            height: 24,
          ),
          Text(
            label,
            style: kmainheight,
          ),
          const SizedBox(
            height: 14,
          ),
          CustomTextField(
            counterText: null,
            maxLength: null,
            textController: textController,
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
