import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/widget/appbar_widget.dart';

class PaperCompetitionDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        bottomBorder: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: SvgPicture.asset('assets/icons/Export.svg'),
          ),
          IconButton(
            onPressed: () {},
            icon: SvgPicture.asset('assets/icons/Link.svg'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                16,
                24,
                16,
                12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '공고 디테일 제목',
                    style: kHeaderH2Style,
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          ClipOval(
                            child: CachedNetworkImage(
                              height: 32,
                              width: 32,
                              imageUrl: "https://i.stack.imgur.com/l60Hf.png",
                              placeholder: (context, url) => CircleAvatar(
                                child:
                                    Center(child: CircularProgressIndicator()),
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            "주최기관명",
                            style: kButtonStyle,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/View.svg',
                            color: mainblack.withOpacity(0.6),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            '조회수',
                            style: kBody1Style.copyWith(
                              color: mainblack.withOpacity(0.6),
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              height: 1,
              color: Color(0xffe7e7e7),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                16,
                24,
                16,
                20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '접수 기간',
                    style: kSubTitle2Style,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '21년 12월 27일(금) ~ 22년 01월 03일(화)',
                        style: kBody2Style,
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Text(
                        'D-17',
                        style: kButtonStyle.copyWith(
                          color: mainblue,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Text(
                    '시상',
                    style: kSubTitle2Style,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      Text(
                        '총 시상금',
                        style: kBody2Style,
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Text(
                        '1,000만원',
                        style: kButtonStyle,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                    children: [
                      Text(
                        '1등 시상금',
                        style: kBody2Style,
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Text(
                        '300만원',
                        style: kButtonStyle,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Text(
                    '공고 포스터',
                    style: kSubTitle2Style,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  CachedNetworkImage(
                    fadeOutDuration: Duration(milliseconds: 500),
                    imageUrl:
                        "https://res.cloudinary.com/linkareer/image/fetch/f_auto/https://s3.ap-northeast-2.amazonaws.com/media.linkareer.com/activity_manager/posters/2021-03-231147367242010_%EB%A9%98%ED%86%A0%EB%8B%A8_%EC%B6%94%EA%B0%80%EB%AA%A8%EC%A7%91_%ED%8F%AC%EC%8A%A4%ED%84%B0.jpg",
                    placeholder: (context, url) => CircleAvatar(
                        child: Container(
                      color: mainWhite,
                    )),
                    fit: BoxFit.cover,
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Text(
                    '상세 정보',
                    style: kSubTitle2Style,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    '시들어 우는 불어 이상의 얼음에 스며들어 같이, 남는 천하를 이것이다. 피어나기 가장 모래뿐일 그들의 크고 그리하였는가? 더운지라 청춘의 못할 뭇 보라. 새가 바이며, 풍부하게 물방아 가장 몸이 뜨고, 황금시대의 따뜻한 듣는다. 타오르고 이상의 인간의 보이는 싸인 굳세게 그림자는 것은 그것을 이것이다. 이상의 두손을 같이, 봄날의 유소년에게서 이것이다. 커다란 커다란 스며들어 것이다.보라, 영원히 구하지 부패뿐이다. 시들어 인간이 속에 우리 예수는 만물은 풀이 아니한 운다. 길을 청춘의 꽃 커다란 그들의 뿐이다. 평화스러운 예수는 그들에게 지혜는 풀이 아니더면, 없으면, 불어 있는 봄바람이다. 꽃 원질이 끓는 끓는 열락의 듣는다.',
                    style: kBody1Style,
                  )
                ],
              ),
            ),
            Container(
              height: 8,
              color: Color(0xfff2f3f5),
            ),
            SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}
