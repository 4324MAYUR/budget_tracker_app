import 'package:budget_tracker/helper/db_helper.dart';
import 'package:budget_tracker/modals/category_modal.dart';
import 'package:budget_tracker/modals/spending_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';


class CategoryController extends GetxController {
  int? categoryIndex;
  Future<List<CategoryModel>>? allCategory;
  Future<List<SpendingModel>>? allSpending;

  void getCategoryIndex({required int index}) {
    categoryIndex = index;
     update();
  }

  void assignDefaultVal() {
    categoryIndex = null;
     update();
  }

  // Insert Category Data
  Future<void> addCategoryData({
    required String name,
    required Uint8List image,
  }) async {
    int? res = await DBHelper.dbHelper
        .insertCategory(name: name, image: image, index: categoryIndex!);

    if (res != null) {
      Get.snackbar(
        "Insert",
        "$name category is inserted....$res",
        colorText: Colors.white,
        backgroundColor: Colors.green,
      );
    } else {
      Get.snackbar(
        "Failed",
        "$name category is Insertion failed....",
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
    }
    update();
  }

  // Fetch Category  Data
  void fetchCategoryData() {
    allCategory = DBHelper.dbHelper.fetchCategory();
  }
  // Fetch Spending  Data
  void fetchSpendingData() {
    allSpending = DBHelper.dbHelper.fetchSpending();
  }
  // Live Search Data
  void searchData({required String val}) {
    allCategory = DBHelper.dbHelper.liveSearchCategory(search: val);
    update();
  }

  // Delete Category Data
  Future<void> deleteCategory({required int id}) async {
    int? res = await DBHelper.dbHelper.deleteCategory(id: id);

    if (res != null) {
      fetchCategoryData();
      Get.snackbar(
        'DELETED',
        "Category is deleted...",
        backgroundColor: Colors.green.shade700,
      );
    } else {
      Get.snackbar(
        'Failed',
        "Category is deletion failed...",
        backgroundColor: Colors.red.shade700,
      );
    }

    update();
  }


  // Delete Spending Data
  Future<void> deleteSpending({required int id}) async {
    int? res = await DBHelper.dbHelper.deleteSpending(id: id);

    if (res != null) {
      fetchSpendingData();
      Get.snackbar(
        'DELETED',
        "Spending is deleted...",
        backgroundColor: Colors.green.shade700,
      );
    } else {
      Get.snackbar(
        'Failed',
        "Spending is deletion failed...",
        backgroundColor: Colors.red.shade700,
      );
    }

    update();
  }


  // Update Category Data
  Future<void> updateCategoryData({required CategoryModel model}) async {
    int? res = await DBHelper.dbHelper.updateCategory(model: model);

    if (res != null) {
      fetchCategoryData();
      Get.snackbar(
        'Update',
        "Category is updated...",
        backgroundColor: Colors.green.shade700,
      );
    } else {
      Get.snackbar(
        'Failed',
        "Category is updation failed...",
        backgroundColor: Colors.red.shade700,
      );
    }
    update();
  }

  // Update Spending Data
  Future<void> updateSpendingData({required SpendingModel model}) async {
    int? res = await DBHelper.dbHelper.updateSpending(model: model);

    if (res != null) {
      fetchSpendingData();
      Get.snackbar(
        'Update',
        "Spending is updated...",
        backgroundColor: Colors.green.shade700,
      );
    } else {
      Get.snackbar(
        'Failed',
        "Spending is updation failed...",
        backgroundColor: Colors.red.shade700,
      );
    }
    update();
  }

  String? mode;
  DateTime? dateTime;

  int? spendingIndex;
  int categoryId = 0;

  void getSpendingMode(String? value) {
    mode = value;
    update();
  }

  void getSpendingDate({required DateTime date}) {
    dateTime = date;
    update();
  }

  void getSpendingIndex({required int index, required int id}) {
    spendingIndex = index;
    categoryId = id;
    update();
  }

  void assignDefaultValue() {
    mode = dateTime = spendingIndex = null;
    update();
  }

  Future<void> addSpendingData({required SpendingModel model}) async {
    int? res = await DBHelper.dbHelper.insertSpending(model: model);

    if (res != null) {
      Get.snackbar(
        "Inserted",
        "spending inserted....",
        backgroundColor: Colors.green.shade400,
      );
    } else {
      Get.snackbar(
        "Failed",
        "spending failed....",
        backgroundColor: Colors.red.shade700,
      );
    }
  }

}
