import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/question_controller.dart';
import 'package:loopus/model/question_model.dart';
import 'package:loopus/screen/question_detail_screen.dart';
import 'package:loopus/widget/tag_widget.dart';

class MyQuestionPostingWidget extends StatelessWidget {
  QuestionController questionController = Get.put(QuestionController());
  final QuestionItem item;
  final int index;

  MyQuestionPostingWidget(
      {required Key key, required this.item, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: mainWhite,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 3,
            offset: Offset(0.0, 1.0),
            color: Colors.black.withOpacity(0.1),
          ),
          BoxShadow(
            blurRadius: 2,
            offset: Offset(0.0, 1.0),
            color: Colors.black.withOpacity(0.06),
          ),
        ],
      ),
      child: InkWell(
        onTap: () async {
          await questionController.loadItem(item.id);
          await questionController.addanswer();
          Get.to(() => QuestionDetailScreen());
          print("click posting");
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
                child: Container(
                  height: 48,
                  child: Text(
                    "${item.content}",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: kSubTitle1Style,
                  ),
                ),
              ),
              SizedBox(
                height: 24,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      ClipOval(
                          child: item.profileimage == null
                              ? Image.asset(
                                  "assets/illustrations/default_profile.png",
                                  height: 32,
                                  width: 32,
                                )
                              : CachedNetworkImage(
                                  height: 32,
                                  width: 32,
                                  imageUrl: item.profileimage ?? "",
                                  placeholder: (context, url) => CircleAvatar(
                                    child: Center(
                                        child: CircularProgressIndicator()),
                                  ),
                                  fit: BoxFit.cover,
                                )),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        "${item.realname}님에게 남긴 질문",
                        style: kButtonStyle.copyWith(
                          color: mainblack.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SvgPicture.asset("assets/icons/Comment.svg"),
                      Text(
                        " ${item.answercount}",
                        style: kButtonStyle,
                      )
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
