import 'package:flutter/material.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/widget/user_image_widget.dart';

class RecommandUserWidget extends StatelessWidget {
  RecommandUserWidget({Key? key, required this.user}) : super(key: key);

  User user;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      decoration: BoxDecoration(
        color: cardGray,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Column(
            children: [
              UserImageWidget(imageUrl: user.profileImage ?? ''),
              const SizedBox(
                height: 7,
              ),
            ],
          ),
          const SizedBox(
            width: 24,
          ),
        ],
      ),
    );
  }
}
