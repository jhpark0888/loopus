import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/message_detail_controller.dart';
import 'package:loopus/model/socket_message_model.dart';
import 'package:loopus/screen/other_profile_screen.dart';
import 'package:loopus/utils/duration_calculate.dart';
import 'package:loopus/model/message_model.dart';
import 'package:loopus/model/user_model.dart';

class MessageWidget extends StatelessWidget {
  MessageWidget({required this.message});
  // late MessageDetailController controller =
  //     Get.find(tag: user.userid.toString());

  Chat message;
  
  // var image;
  // String content;
  // int isSender;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      child: message.sender == 1
          ? Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Obx(() => (message.issending.value)
                //     ? Container(
                //         padding:
                //             const EdgeInsets.fromLTRB(12.0, 12.0, 8.0, 12.0),
                //         width: 20,
                //         height: 20,
                //         child: Opacity(
                //           opacity: 0.6,
                //           child: Icon(
                //             Icons.reply_rounded,
                //             color: mainblack,
                //             size: 20,
                //           ),
                //         ),
                //       )
                //     : Container()),
                // SizedBox(
                //   width: 2,
                // ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12.0, 18.0, 8.0, 0.0),
                  child: Text(
                    "${messagedurationCaculate(startDate: message.date, endDate: DateTime.now())}",
                    style: kCaptionStyle.copyWith(
                      color: mainblack.withOpacity(0.6),
                    ),
                  ),
                ),
                hasTextOverflow(message.content, kBody2Style)
                    ? Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              color: mainblue,
                              borderRadius: BorderRadius.circular(8)),
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                message.content,
                                style: kSubTitle3Style.copyWith(height: 1.5,color: mainblack),
                              )),
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                            color: mainblue,
                            borderRadius: BorderRadius.circular(8)),
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              message.content,
                              style: kSubTitle3Style.copyWith(height: 1.5,color: mainWhite),
                            )),
                      ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    // Get.to(() => OtherProfileScreen(
                    //       userid: message.sender!,
                    //       realname: user.realName,
                    //     ));
                  },
                  child: ClipOval(
                      child: 
                      // user.profileImage == null
                      //     ? 
                          Image.asset(
                              "assets/illustrations/default_profile.png",
                              height: 32,
                              width: 32,
                            )
                          // : CachedNetworkImage(
                          //     height: 32,
                          //     width: 32,
                          //     imageUrl: user.profileImage!,
                          //     placeholder: (context, url) => CircleAvatar(
                          //       backgroundColor: Color(0xffe7e7e7),
                          //       child: Container(),
                          //     ),
                          //     fit: BoxFit.cover,
                          )
                            ,
                ),
                SizedBox(
                  width: 10,
                ),
               hasTextOverflow(message.content, kBody2Style, maxWidth: Get.width * (2/3))
                    ? Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Color(0xffe7e7e7),
                              ),
                              borderRadius: BorderRadius.circular(8)),
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                message.content,
                                style: kBody2Style,
                              )),
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Color(0xffe7e7e7),
                            ),
                            borderRadius: BorderRadius.circular(8)),
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              message.content,
                              style: kBody2Style,
                            )),
                      ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 18.0, 12.0, 0.0),
                  child: Text(
                    messagedurationCaculate(startDate: message.date, endDate: DateTime.now()),
                    style: kCaptionStyle.copyWith(
                        color: mainblack.withOpacity(0.6)),
                  ),
                )
              ],
            ),
    );
  }
   bool hasTextOverflow(String text, TextStyle style,
      {double minWidth = 0, double maxWidth = 10, int maxLines = 1}) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: maxLines,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: minWidth, maxWidth: maxWidth);
    return textPainter.didExceedMaxLines;
  }
}
