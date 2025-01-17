import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavigationController extends GetxController {
  RxInt navigationIndex = 0.obs;
  PageController pageController = PageController(initialPage: 0);

  void getNavigationIndex({required int index}) {
    navigationIndex.value = index;
  }

  void changePageView({required int index}) {
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    );

    update();
  }
}
