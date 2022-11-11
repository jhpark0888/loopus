import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/api/chat_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/message_controller.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/screen/message_detail_screen.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/disconnect_reload_widget.dart';
import 'package:loopus/widget/error_reload_widget.dart';
import 'package:loopus/widget/loading_widget.dart';
import 'package:loopus/widget/no_ul_textfield_widget.dart';
import 'package:loopus/widget/scroll_noneffect_widget.dart';
import 'package:loopus/widget/search_text_field_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sqlite_viewer/sqlite_viewer.dart';

class MessageScreen extends StatelessWidget {
  MessageController messageController = Get.put(MessageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget(
          bottomBorder: false,
          title: '메세지',
          // actions: [
          //   GestureDetector(
          //       onTap: () {
          //         Get.to(() => DatabaseList());
          //       },
          //       child: SvgPicture.asset('assets/icons/appbar_more_option.svg'))
          // ],
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
        body: Obx(() => messageController.chatroomscreenstate.value ==
                ScreenState.success
            ? Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
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
                            if (name.trim() != '') {
                              messageController.searchRoomList.value =
                                  messageController.chattingRoomList
                                      .where((chattingRoom) => chattingRoom
                                          .user.value.name
                                          .contains(name))
                                      .toList();
                            } else {
                              messageController.searchRoomList.value =
                                  messageController.chattingRoomList;
                            }
                          },
                        )),
                    const SizedBox(height: 16),
                    messageController.searchRoomList.isNotEmpty
                        ? Obx(
                          ()=> Expanded(
                              child: SlidableAutoCloseBehavior(
                                closeWhenOpened: true,
                                closeWhenTapped: true,
                                child: ListView.builder(
                                  shrinkWrap: false,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: const EdgeInsets.only(bottom: 24),
                                  // separatorBuilder: (context, index) {
                                  //   return const SizedBox(height: 24);
                                  // },
                                  itemBuilder: (context, index) {
                                    if(messageController
                                        .searchRoomList[index].user.value.banned.value == BanState.normal){
                                    return messageController
                                        .searchRoomList[index];
                                        }else{
                                          return const SizedBox.shrink();
                                        }
                                  },
                                  itemCount:
                                      messageController.searchRoomList.length,
                                ),
                              ),
                            ),
                        )
                        : Expanded(
                            child: SizedBox(
                              width: Get.width,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '메시지 목록이 비어있어요',
                                    style: kmain.copyWith(
                                      color: mainblack.withOpacity(0.38),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                  ],
                ),
              )
            : const Center(child: LoadingWidget())));
  }
}
