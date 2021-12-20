import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:loopus/controller/posting_add_controller.dart';
import 'package:loopus/widget/posting_add_content_widget.dart';
import 'package:loopus/widget/posting_add_fileimage_widget.dart';
import 'package:loopus/widget/posting_add_title_widget.dart';

Future<void> postingaddRequest() async {
  PostingAddController postingAddController = Get.find();
  String? token = await FlutterSecureStorage().read(key: 'token');
  String? user_id = await FlutterSecureStorage().read(key: 'id');
  // Uri uri = Uri.parse('http://52.79.75.189:8000/user_api/profile_update/customizing/$user_id/');
  Uri uri =
      Uri.parse('http://3.35.253.151:8000/post_api/posting_upload/$user_id/');

  var request = new http.MultipartRequest('POST', uri);

  final headers = {
    'Authorization': 'Token $token',
    'Content-Type': 'multipart/form-data',
  };

  request.headers.addAll(headers);

  List<Map> customprofile = [];

  List<int> imageData =
      await File(postingAddController.thumbnail.value.path).readAsBytes();
  var stream = http.ByteStream.fromBytes(imageData);
  var length = imageData.length;
  var multipartFile = http.MultipartFile(
    'thumbnail',
    stream,
    length,
  );
  request.files.add(multipartFile);

  for (int i = 0; i < postingAddController.images.length; i++) {
    List<int> imageData =
        await File(postingAddController.images[i].path).readAsBytes();
    var stream = http.ByteStream.fromBytes(imageData);
    var length = imageData.length;
    var multipartFile = http.MultipartFile(
      'image',
      stream,
      length,
    );
    request.files.add(multipartFile);
  }

  request.fields['title'] =
      json.encode(postingAddController.titlecontroller.text);
  request.fields['content'] = json
      .encode(postingAddController.postcontroller.document.toDelta().toJson());

  print(request.fields);
  print(request.files);

  http.StreamedResponse response = await request.send();
  if (response.statusCode == 200) {
    print("success!");

    String responsebody = await response.stream.bytesToString();

    // responsemap = jsonDecode(responsebody).cast<Map>();
    // print(responsemap);
    // myProfileController.customlist.clear();
    // responsemap.forEach((map) {
    //   if (map["type"] == "title") {
    //     myProfileController.customlist.add(ProfileTitleWidget(
    //       title: map["contents"],
    //     ));
    //   } else if (map["type"] == "content") {
    //     myProfileController.customlist.add(ProfileContentWidget(
    //       content: map["contents"],
    //     ));
    //   } else if (map["type"] == "imageURL") {
    //     String image = map["contents"];

    //     myProfileController.customlist.add(ProfileImageWidget(
    //       image: image,
    //     ));
    //   } else if (map["type"] == "imageFILE") {
    //     String image = map["contents"];

    //     myProfileController.customlist.add(ProfileImageWidget(
    //       image: image,
    //     ));
    //   } else if (map["type"] == "feed") {
    //     myProfileController.customlist.add(Center(
    //       child: ProfileFeedWidget(
    //         feed: FeedItem.fromJson(map["contents"]),
    //       ),
    //     ));
    //   }
    // };
  } else if (response.statusCode == 400) {
    print("lose");
  } else {
    print(response.statusCode);
  }
}
