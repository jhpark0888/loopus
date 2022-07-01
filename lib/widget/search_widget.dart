import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/model/tag_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/screen/tag_detail_screen.dart';
import 'package:loopus/widget/tag_widget.dart';
import 'package:loopus/widget/user_image_widget.dart';

class SearchUserWidget extends StatelessWidget {
  SearchUserWidget({Key? key, required this.user}) : super(key: key);

  User user;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print('dddd');
      },
      splashColor: kSplashColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          children: [
            UserImageWidget(
              imageUrl: user.profileImage ?? '',
              width: 36,
              height: 36,
            ),
            const SizedBox(
              width: 14,
            ),
            RichText(
                text: TextSpan(children: [
              TextSpan(text: user.realName, style: kmainbold),
              TextSpan(text: ' · 땡땡대 · ${user.department}', style: kmain),
            ]))
          ],
        ),
      ),
    );
  }
}

class SearchTagWidget extends StatelessWidget {
  SearchTagWidget({Key? key, required this.tag}) : super(key: key);

  Tag tag;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(() => TagDetailScreen(
              tag: tag,
            ));
      },
      splashColor: kSplashColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          children: [
            Tagwidget(
              tag: tag,
            ),
            const Spacer(),
            Text(
              '${tag.count}회',
              style: kmain,
            )
          ],
        ),
      ),
    );
  }
}
