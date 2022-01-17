import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:get/get.dart';

class TransitionAnimationController extends GetxController
    with GetTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<Alignment> alignmentAnimation;
  late Animation<double> scaleAnimation;
  Rx<Alignment> dragAlignment = Alignment.center.obs;
  Rx<Size> size = Get.size.obs;

  @override
  void onInit() {
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    scaleAnimation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    );
    controller.addListener(() {
      dragAlignment.value = alignmentAnimation.value;
    });
    super.onInit();
  }

  void runAnimation(Offset pixelsperSecond, Size size) {
    alignmentAnimation = controller.drive(
      AlignmentTween(
        begin: dragAlignment.value,
        end: Alignment.center,
      ),
    );
    scaleAnimation = controller.drive(Tween(begin: 0.0, end: 1.0));

    final unitsPerSecondX = pixelsperSecond.dx / size.width;
    final unitsPerSecondY = pixelsperSecond.dx / size.height;
    final unitsPerSecond = Offset(unitsPerSecondX, unitsPerSecondY);
    final RxDouble unitVelocity = unitsPerSecond.distance.obs;

    final spring = SpringDescription(mass: 30, stiffness: 1, damping: 1);

    final simulation = SpringSimulation(spring, 0, 1, -unitVelocity.value);

    controller.animateWith(simulation);
  }
}
