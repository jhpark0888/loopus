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
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/person_image_widget.dart';
import 'package:loopus/widget/search_text_field_widget.dart';

class SelectCareerGroupMemberScreen extends StatelessWidget {
  SelectCareerGroupMemberScreen({Key? key}) : super(key: key);
  SelectCareerGroupMemberController controller =
      Get.put(SelectCareerGroupMemberController());
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBarWidget(
          title: '함께하는 친구 추가',
          actions: [
            IconButton(
                padding: const EdgeInsets.only(left: 0, right: 12.5),
                onPressed: () {
                  if (controller.selectList.isNotEmpty) {
                    controller.selectList
                        .sort((a, b) => a.realName.compareTo(b.realName));
                    addGroupMember(controller.selectList,
                            CareerDetailController.to.career.id)
                        .then((value) {
                      if (value.isError == false) {
                        Get.back();
                        showCustomDialog('추가되었습니다.', 1200);

                        CareerDetailController.to.members
                            .addAll(controller.selectList);
                        CareerDetailController.to.members.refresh();
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
                            : mainblack),
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
    return SearchTextFieldWidget(
        onchanged: (text) {
          controller.searchList.value = controller.followList
              .where((p0) => p0.realName.contains(text))
              .toList();
        },
        ontap: () {},
        hinttext: '검색',
        readonly: false,
        controller: searchController);
  }

  Widget memberList(BuildContext context) {
    return Obx(() => Expanded(
            child: ListView.separated(
          separatorBuilder: (context, index) {
            return const SizedBox(height: 24);
          },
          itemBuilder: (context, index) {
            return followingTile(controller.searchList[index]);
          },
          itemCount: controller.searchList.length,
        )));
  }

  Widget followingTile(User user) {
    RxBool activeStatus = false.obs;
    return GestureDetector(
      onTap: () {
        if (CareerDetailController.to.members
            .where((element) => element.userid == user.userid)
            .isEmpty) {
          activeStatus(!activeStatus.value);
          selectListCheck(user);
        }
      },
      child: SizedBox(
        width: Get.width,
        child: Row(children: [
          PersonImageWidget(
            user: user,
            width: 36,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    user.realName,
                    style: kmainbold,
                  ),
                  const SizedBox(height: 7),
                  Text(
                    "${user.univName} · ${user.department}",
                    style: kmain,
                    overflow: TextOverflow.ellipsis,
                  ),
                ]),
          ),
          const SizedBox(width: 14),
          if (CareerDetailController.to.members
              .where((element) => element.userid == user.userid)
              .isEmpty)
            Obx(() => SvgPicture.asset(
                'assets/icons/check_${activeStatus.value ? 'active' : 'inactive'}.svg'))
        ]),
      ),
    );
  }

  void selectListCheck(User user) {
    if (controller.selectList.where((p0) => p0 == user).toList().isEmpty) {
      controller.selectList.add(user);
    } else {
      controller.selectList.remove(user);
    }
  }
}
