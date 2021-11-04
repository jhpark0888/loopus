// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';

class ActivityWidget extends StatelessWidget {
  ActivityWidget(
      {Key? key,
      this.title,
      this.startday,
      this.endday,
      this.period,
      this.posting_num,
      this.reponse_num})
      : super(key: key);

  String? title;
  String? startday;
  String? endday;
  String? period;
  int? posting_num;
  int? reponse_num;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 347,
          height: 288,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              image: DecorationImage(
                  image: NetworkImage(
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRWpol9gKXdfW9lUlFiWuujRUhCQbw9oHVIkQ&usqp=CAU',
                  ),
                  fit: BoxFit.cover)),
        ),
        Positioned(
          bottom: 0,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.only(
                topLeft: Radius.zero,
                topRight: Radius.zero,
                bottomLeft: Radius.circular(4),
                bottomRight: Radius.circular(4),
              ),
            ),
            width: 347,
            height: 138,
          ),
        ),
        Positioned(
          bottom: 0,
          child: Container(
            padding: EdgeInsets.fromLTRB(12, 16, 12, 20),
            width: 347,
            height: 138,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  '인공지능 스터디',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Text(
                      '2020.04 ~ ',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.white,
                      ),
                      width: 55,
                      height: 20,
                      child: Center(
                        child: Text(
                          '진행중',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '포스팅 33  답변 24',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    Row(children: [
                      FavoriteButton(iconSize: 40, valueChanged: () {}),
                      Text(
                        '999+',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ])
                  ],
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
