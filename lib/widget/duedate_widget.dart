import 'package:flutter/material.dart';
import 'package:loopus/constant.dart';

class DueDateWidget extends StatelessWidget {
  DueDateWidget({Key? key, required this.dueDate}) : super(key: key);

  DateTime dueDate;

  String _diffDueDateFromNow() {
    Duration diff = dueDate.difference(DateTime.now());

    if (diff.isNegative) {
      return "마감";
    } else if (diff.inDays == 0) {
      return "오늘 마감";
    } else {
      return "D-${diff.inDays}";
    }
  }

  Color _dueDateColor() {
    Duration diff = dueDate.difference(DateTime.now());

    if (diff.isNegative) {
      return AppColors.maingray;
    } else {
      return AppColors.mainblue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: _dueDateColor(),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Text(
        _diffDueDateFromNow(),
        style:
            MyTextTheme.mainbold(context).copyWith(color: AppColors.mainWhite),
      ),
    );
  }
}
