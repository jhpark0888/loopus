import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/model/project_model.dart';

class CareerWidget extends StatelessWidget {
  CareerWidget({Key? key, required this.career}) : super(key: key);

  Project career;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      decoration: BoxDecoration(
          color: career.thumbnail == "" ? cardGray : null,
          borderRadius: BorderRadius.circular(8),
          image: career.thumbnail == ""
              ? null
              : DecorationImage(
                  image: NetworkImage(career.thumbnail),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      const Color(0x00000000).withOpacity(0.4),
                      BlendMode.srcOver))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            career.careerName,
            style: kmainbold.copyWith(
                color: career.thumbnail == "" ? mainblack : mainWhite),
          ),
          const SizedBox(
            height: 7,
          ),
          Row(
            children: [
              Text(
                "최근 포스트 ${DateFormat('yyyy.MM.dd.').format(career.updateDate!)}",
                style: kmain.copyWith(
                    color: career.thumbnail == "" ? mainblack : mainWhite),
              ),
            ],
          )
        ],
      ),
    );
  }
}
