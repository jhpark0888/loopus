import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:loopus/widget/paper_competition_widget.dart';
import 'package:loopus/widget/paper_internship_widget.dart';

class PaperController extends GetxController {
  static PaperController get to => Get.find();
  List<PapercompetitionWidget> posting = [];
  List<PaperinternshipWidget> posting_internship = [];

  @override
  void onInit() {
    for (int i = 0; i < 4; i++) {
      posting.add(PapercompetitionWidget());
      posting_internship.add(PaperinternshipWidget());
    }
    ;
    super.onInit();
  }
}
