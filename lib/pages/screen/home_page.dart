import 'package:budget_tracker/components/all_category_components.dart';
import 'package:budget_tracker/components/all_spending_components.dart';
import 'package:budget_tracker/components/category_components.dart';
import 'package:budget_tracker/components/spending_components.dart';
import 'package:budget_tracker/controllers/navigation_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final NavigationController controller = Get.put(NavigationController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: true,
        title: const Text(
          "Budget Tracker",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 2,
      ),
      body: PageView(
        controller: controller.pageController,
        onPageChanged: (index) {
          controller.getNavigationIndex(index: index);
        },
        children: const [
          AllSpendingComponents(),
          SpendingComponents(),
          AllCategoryComponents(),
          CategoryComponents(),
        ],
      ),
      bottomNavigationBar: Obx(
            () {
          return BottomNavigationBar(
            currentIndex: controller.navigationIndex.value,
            onTap: (index) {
              controller.getNavigationIndex(index: index);
              controller.changePageView(index: index);
            },
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.white,
            backgroundColor: Colors.yellow,
            selectedLabelStyle: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.normal,
            ),
             items: const [
              BottomNavigationBarItem(
                icon: Icon(
                  CupertinoIcons.creditcard,
                ),
                label: "All Spending",
                backgroundColor: Colors.green,
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  CupertinoIcons.chart_bar,
                ),
                label: "Spending",
                backgroundColor: Colors.green,
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  CupertinoIcons.list_bullet,
                ),
                label: "All Category",
                backgroundColor: Colors.green,
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.category_sharp,
                ),
                label: "Category",
                backgroundColor: Colors.green,
              ),
            ],
          );
        },
      ),
    );
  }
}
