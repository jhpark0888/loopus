import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/api/project_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/career_detail_controller.dart';
import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/select_career_group_member_controller.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/screen/loading_screen.dart';
import 'package:loopus/utils/error_control.dart';
import 'package:loopus/widget/Link_widget.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/loading_widget.dart';
import 'package:loopus/widget/search_text_field_widget.dart';
import 'package:loopus/widget/user_image_widget.dart';

class SelectCareerGroupMemberScreen extends StatelessWidget {
  SelectCareerGroupMemberScreen({Key? key, required this.careerId})
      : super(key: key);
  SelectCareerGroupMemberController controller =
      Get.put(SelectCareerGroupMemberController());
  TextEditingController searchController = TextEditingController();
  int careerId;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBarWidget(
          title: '함께하는 친구 추가',
          bottomBorder: false,
          actions: [
            IconButton(
                padding: const EdgeInsets.only(left: 0, right: 12.5),
                onPressed: () {
                  if (controller.selectList.isNotEmpty) {
                    loading();

                    controller.selectList
                        .sort((a, b) => a.name.compareTo(b.name));
                    updateCareer(
                            Get.find<CareerDetailController>(
                                    tag: careerId.toString())
                                .career
                                .value
                                .id,
                            controller.selectList,
                            null,null,
                            ProjectUpdateType.looper)
                        .then((value) {
                      if (value.isError == false) {
                        Get.find<CareerDetailController>(
                                tag: careerId.toString())
                            .members
                            .addAll(controller.selectList);
                        Get.find<CareerDetailController>(
                                tag: careerId.toString())
                            .members
                            .refresh();
                        getbacks(2);
                        showCustomDialog('추가되었습니다.', 1200);
                      } else {
                        Get.back();
                        errorSituation(value);
                      }
                    });
                  }
                },
                icon: Obx(
                  () => Text(
                    '확인',
                    style: kNavigationTitle.copyWith(
                        color: controller.selectList.isNotEmpty
                            ? mainblue
                            : maingray),
                  ),
                ))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          child: Column(children: [
            searchField(),
            const SizedBox(height: 24),
            memberList(context)
          ]),
        ),
      ),
    );
  }

  Widget searchField() {
    return SizedBox(
      height: 36,
      child: SearchTextFieldWidget(
          onchanged: (text) {
            controller.searchList.value = controller.followList
                .where((p0) => p0.name.contains(text))
                .toList();
          },
          ontap: () {},
          hinttext: '검색',
          readonly: false,
          controller: searchController),
    );
  }

  Widget memberList(BuildContext context) {
    return Obx(() => Expanded(
        child: controller.isSearchLoadaing.value
            ? const LoadingWidget()
            : ListView.separated(
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 24);
                },
                itemBuilder: (context, index) {
                  return KeepAliveWidget(
                      child: followingTile(controller.searchList[index]));
                },
                itemCount: controller.searchList.length,
              )));
  }

  Widget followingTile(Person user) {
    RxBool activeStatus = false.obs;
    return GestureDetector(
      onTap: () {
        if (Get.find<CareerDetailController>(tag: careerId.toString())
            .members
            .where((element) => element.userId == user.userId)
            .isEmpty) {
          activeStatus(!activeStatus.value);
          selectListCheck(user);
        }
      },
      child: SizedBox(
        width: Get.width,
        child: Row(children: [
          UserImageWidget(
            imageUrl: user.profileImage,
            width: 36,
            height: 36,
            userType: user.userType,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    user.name,
                    style: kmainbold,
                  ),
                  const SizedBox(height: 7),
                  Text(
                    "${(user as Person).univName} · ${user.department}",
                    style: kmain,
                    overflow: TextOverflow.ellipsis,
                  ),
                ]),
          ),
          const SizedBox(width: 14),
          if (Get.find<CareerDetailController>(tag: careerId.toString())
              .members
              .where((element) => element.userId == user.userId)
              .isEmpty)
            Obx(() => SvgPicture.asset(
                  'assets/icons/check_${activeStatus.value ? 'active' : 'inactive'}.svg',
                  width: 32,
                  height: 32,
                ))
        ]),
      ),
    );
  }

  void selectListCheck(Person user) {
    if (controller.selectList.where((p0) => p0 == user).toList().isEmpty) {
      controller.selectList.add(user);
    } else {
      controller.selectList.remove(user);
    }
  }
}
