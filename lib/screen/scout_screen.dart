import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/scout_report_controller.dart';
import 'package:loopus/widget/company_widget.dart';
import 'package:loopus/widget/contact_widget.dart';
import 'package:loopus/widget/divide_widget.dart';
import 'package:loopus/widget/scroll_noneffect_widget.dart';

class ScoutScreen extends StatelessWidget {
  ScoutScreen({Key? key}) : super(key: key);

  final ScoutReportController _controller = Get.put(ScoutReportController());

  Widget _tabWidget({required String text, bool right = true}) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Tab(
            text: text,
          ),
          if (right)
            VerticalDivider(
              thickness: 1,
              width: 28,
              indent: 14,
              endIndent: 14,
              color: dividegray,
            )
        ],
      ),
    );
  }

  Widget _scoutCompany() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 24,
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "스카우트 중인 기업",
            style: kmainbold,
          ),
        ),
        const SizedBox(
          height: 14,
        ),
        SizedBox(
          height: 100,
          child: ListView.separated(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemBuilder: (context, index) {
                return CompanyWidget(company: _controller.companyList[index]);
              },
              separatorBuilder: (context, index) {
                return const SizedBox(
                  width: 14,
                );
              },
              itemCount: _controller.companyList.length),
        ),
        const SizedBox(
          height: 24,
        ),
      ],
    );
  }

  Widget _scouterContact() {
    return Column(
      children: [
        const SizedBox(
          height: 12,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              const Text(
                "스카우트 컨택",
                style: kmainbold,
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {},
                child: SvgPicture.asset(
                  "assets/icons/Search_Inactive.svg",
                  width: 20,
                  height: 20,
                  color: mainblack,
                ),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 24,
        ),
        Obx(
          () => ListView.separated(
              primary: false,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return ContactWidget(contact: _controller.contactList[index]);
              },
              separatorBuilder: (context, index) => DivideWidget(
                    height: 24,
                  ),
              itemCount: _controller.contactList.length),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: false,
          titleSpacing: 20,
          title: const Padding(
            padding: EdgeInsets.fromLTRB(0, 24, 0, 24),
            child: Text(
              '스카우트 리포트',
              style: ktitle,
            ),
          ),
          excludeHeaderSemantics: false,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: GestureDetector(
                onTap: () {},
                child: SvgPicture.asset(
                  'assets/icons/Question copy.svg',
                ),
              ),
            ),
          ],
        ),
        body: NestedScrollView(
          headerSliverBuilder: (context, value) {
            return [
              SliverAppBar(
                toolbarHeight: 80,
                automaticallyImplyLeading: false,
                elevation: 0,
                floating: false,
                pinned: false,
                flexibleSpace: Column(
                  children: [
                    ScrollNoneffectWidget(
                      child: TabBar(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        controller: _controller.tabController,
                        indicatorColor: Colors.transparent,
                        labelPadding: EdgeInsets.zero,
                        labelColor: mainblack,
                        labelStyle: ktitle,
                        unselectedLabelColor: dividegray,
                        tabs: [
                          _tabWidget(
                            text: "전체",
                          ),
                          _tabWidget(
                            text: "IT",
                          ),
                          // Tab(
                          //     child: Text(
                          //   "IT",
                          //   style: TextStyle(
                          //       height: 1.4,
                          //       fontSize: 27.5,
                          //       fontWeight: FontWeight.w600,
                          //       fontFamily: 'SUIT'),
                          // )),
                          _tabWidget(
                            text: "디자인",
                          ),
                          _tabWidget(
                            text: "경영",
                          ),
                          _tabWidget(
                            text: "제조",
                          ),
                          _tabWidget(text: "건설", right: false),
                        ],
                        isScrollable: true,
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    DivideWidget(
                      height: 0,
                    )
                  ],
                ),
                // bottom: PreferredSize(child: DivideWidget(
                //       height: 0,
                //     ), preferredSize: const Size.fromHeight(24)),
              ),
            ];
          },
          body: ScrollNoneffectWidget(
            child: TabBarView(
              controller: _controller.tabController,
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      _scoutCompany(),
                      // // const SizedBox(height: 48),
                      _scouterContact(),
                      // _ScoutContactList(),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      _scoutCompany(),
                      // _ScouterContact(),
                      // _ScoutContactList(),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      _scoutCompany(),
                      // _ScouterContact(),
                      // _ScoutContactList(),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      _scoutCompany(),
                      // _ScouterContact(),
                      // _ScoutContactList(),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      _scoutCompany(),
                      // _ScouterContact(),
                      // _ScoutContactList(),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      _scoutCompany(),
                      // _ScouterContact(),
                      // _ScoutContactList(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
