import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/api/chat_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/message_controller.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/screen/websocet_screen.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/disconnect_reload_widget.dart';
import 'package:loopus/widget/error_reload_widget.dart';
import 'package:loopus/widget/no_ul_textfield_widget.dart';
import 'package:loopus/widget/search_text_field_widget.dart';
import 'package:sqlite_viewer/sqlite_viewer.dart';

class MessageScreen extends StatelessWidget {
  MessageController messageController = Get.put(MessageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget(
          leading: IconButton(
            onPressed: () {
              // Get.back();
             Get.to(() => DatabaseList());
            },
            icon: SvgPicture.asset('assets/icons/Arrow.svg'),
          ),
          bottomBorder: false,
          title: '메시지',
        ),
        // body: Obx(
        //   () => messageController.chatroomscreenstate.value ==
        //           ScreenState.loading
        //       ? Center(
        //           child: Column(
        //               mainAxisAlignment: MainAxisAlignment.center,
        //               children: [
        //                 Image.asset(
        //                   'assets/icons/loading.gif',
        //                   scale: 9,
        //                 ),
        //                 SizedBox(
        //                   height: 4,
        //                 ),
        //                 Text(
        //                   '메시지 목록을 받아오는 중이에요...',
        //                   style: TextStyle(
        //                     fontSize: 10,
        //                     color: mainblue,
        //                     fontWeight: FontWeight.w500,
        //                   ),
        //                 )
        //               ]),
        //         )
        //       : messageController.chatroomscreenstate.value ==
        //               ScreenState.disconnect
        //           ? DisconnectReloadWidget(reload: () {
        //               getmessageroomlist();
        //             })
        //           : messageController.chatroomscreenstate.value ==
        //                   ScreenState.error
        //               ? ErrorReloadWidget(reload: () {
        //                   getmessageroomlist();
        //                 })
        //               : messageController.chattingroomlist.isNotEmpty
        //                   ? SingleChildScrollView(
        //                       child: Column(
        //                           children: messageController.chattingroomlist))
        //                   : SafeArea(
        // child:
        body: Obx(
          () => messageController.chattingRoomList.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
                  child: Column(
                    children: [
                      SizedBox(
                          height: 36,
                          child: SearchTextFieldWidget(
                            ontap: () {},
                            hinttext: '검색',
                            readonly: false,
                            controller: messageController.searchName,
                            onchanged: (name) {
                              if (name != '') {
                                messageController.searchRoomList.value =
                                    messageController.chattingRoomList
                                        .where((p0) =>
                                            p0.chatRoom.value.user.toString() ==
                                            name)
                                        .toList();
                              } else {
                                messageController.searchRoomList.value =
                                    messageController.chattingRoomList;
                              }
                            },
                          )),
                      Expanded(
                        child: ListView.separated(
                          padding: EdgeInsets.only(top: 24),
                          separatorBuilder: (context, index) {
                            return const SizedBox(height: 24);
                          },
                          itemBuilder: (context, index) {
                            return messageController.searchRoomList[index];
                          },
                          itemCount: messageController.searchRoomList.length,
                          // children: messageController.cacac.map((element) => Text(element)).toList(),
                        ),
                      ),
                    ],
                  ),
                )
              : Container(
                  width: Get.width,
                  height: Get.height * 0.75,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Get.to(() => WebsoketScreen(
                          //       partnerId: 2,
                          //       roomid: 27,
                          //     ));
                        },
                        child: Text(
                          '메시지 목록이 비어있어요',
                          style: kSubTitle3Style.copyWith(
                            color: mainblack.withOpacity(0.38),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        )
        // ),
        );
    // ));
  }
}
