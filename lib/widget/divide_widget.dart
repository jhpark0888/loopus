import 'package:flutter/material.dart';
import 'package:loopus/constant.dart';

class DivideWidget extends StatelessWidget {
  const DivideWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 14, 24, 14),
      child: const Divider(
        thickness: 1,
        color: cardGray,
      ),
    );
  }
}
