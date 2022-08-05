import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/model/tag_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/screen/other_profile_screen.dart';
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
        Get.to(
            () => OtherProfileScreen(
                user: user, userid: user.userid, realname: user.realName),
            preventDuplicates: false);
      },
      splashColor: kSplashColor,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 6, 0, 6),
        child: Row(
          children: [
            const SizedBox(width: 20),
            UserImageWidget(
                imageUrl: user.profileImage ?? "", width: 36, height: 36),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.realName, style: kmainbold),
                const SizedBox(height: 7),
                Text('${user.univName} · ${user.department}', style: kmain),
              ],
            ),
            const SizedBox(width: 20),
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
