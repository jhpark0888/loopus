import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/project_add_controller.dart';

class EndDateTextFormField extends StatelessWidget {
  EndDateTextFormField(
      {Key? key,
      required this.controller,
      this.focusNode,
      required this.maxLenght,
      this.hinttext,
      required this.isongoing,
      this.validator})
      : super(key: key);

  ProjectAddController projectaddcontroller = Get.find();
  TextEditingController controller;
  FocusNode? focusNode;
  int maxLenght;
  String? hinttext;
  RxBool isongoing;
  String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Obx(
        () => TextFormField(
          validator: projectaddcontroller.isongoing.value ? null : validator,
          focusNode: focusNode,
          readOnly: isongoing.value,
          controller: controller,
          cursorColor: mainblack,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              counterText: '',
              enabledBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(2),
                borderSide: BorderSide(
                    color: projectaddcontroller.isongoing.value
                        ? mainblack.withOpacity(0.38)
                        : mainblack,
                    width: 2),
              ),
              focusedBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(2),
                borderSide: BorderSide(
                    color: projectaddcontroller.isongoing.value
                        ? mainblack.withOpacity(0.38)
                        : mainblack,
                    width: 2),
              ),
              errorBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(2),
                borderSide: BorderSide(
                    color: projectaddcontroller.isongoing.value
                        ? mainblack.withOpacity(0.38)
                        : mainpink,
                    width: 2),
              ),
              focusedErrorBorder: projectaddcontroller.isongoing.value
                  ? UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(2),
                      borderSide: BorderSide(
                        color: mainblack.withOpacity(0.38),
                      ),
                    )
                  : null,
              hintText: hinttext ?? '',
              hintStyle: TextStyle(
                  color: projectaddcontroller.isongoing.value
                      ? mainblack.withOpacity(0.38)
                      : null)),
          textAlign: TextAlign.center,
          autocorrect: false,
          cursorWidth: 1.5,
          cursorRadius: Radius.circular(2),
          maxLength: maxLenght,
        ),
      ),
      height: 75,
      width: 48,
    );
  }
}
