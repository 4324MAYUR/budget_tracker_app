import 'package:budget_tracker/modals/category_modal.dart';
import 'package:budget_tracker/modals/spending_modal.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  DBHelper._();

  static DBHelper dbHelper = DBHelper._();

  Database? db;

  // Category Table Variable
  String categoryTable = "category";
  String categoryName = "category_name";
  String categoryImage = "category_image";
  String categoryImageIndex = "category_image_index";

  // Spending Table Variable
  String spendingTable = "spending";
  String spendingId = "spending_id";
  String spendingDesc = "spending_desc";
  String spendingAmount = "spending_amount";
  String spendingMode = "spending_mode";
  String spendingDate = "spending_date";
  String spendingCategoryId = "spending_category_id";

  // Category Table Create
  Future<void> initDB() async {
    String dbPath = await getDatabasesPath();

    String path = "${dbPath}budget.db";

    db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, _) async {
        String query = '''CREATE TABLE $categoryTable(
            category_id INTEGER PRIMARY KEY AUTOINCREMENT,
            $categoryName TEXT NOT NULL,
            $categoryImage BLOB NOT NULL,
            $categoryImageIndex INTEGER NOT NULL
        );''';

        await db.execute(query);

        String query2 = '''CREATE TABLE $spendingTable (
          $spendingId INTEGER PRIMARY KEY AUTOINCREMENT,
          $spendingDesc TEXT NOT NULL,
          $spendingAmount NUMERIC NOT NULL,
          $spendingMode TEXT NOT NULL,
          $spendingDate TEXT NOT NULL,
          $spendingCategoryId INTEGER NOT NULL
        );''';

        await db.execute(query2);
      },
    );
  }

  // Category Data Insert
  Future<int?> insertCategory({
    required String name,
    required Uint8List image,
    required int index,
  }) async {
    await initDB();

    String query =
        "INSERT INTO $categoryTable ($categoryName, $categoryImage,$categoryImageIndex) VALUES(?, ?, ?);";

    List arg = [name, image, index];

    return await db?.rawInsert(query, arg);
  }

  // Spending Data Insert
  Future<int?> insertSpending({required SpendingModel model}) async {
    await initDB();

    String query =
        "INSERT INTO $spendingTable ($spendingDesc,$spendingAmount,$spendingMode,$spendingDate,$spendingCategoryId) VALUES(?, ?, ?, ?, ?);";

    List args = [
      model.desc,
      model.amount,
      model.mode,
      model.date,
      model.categoryId,
    ];

    return await db?.rawInsert(query, args);
  }

  // FetchCategory Data
  Future<List<CategoryModel>> fetchCategory() async {
    await initDB();

    String query = "SELECT * FROM $categoryTable;";

    List<Map<String, dynamic>> res = await db?.rawQuery(query) ?? [];

    return res
        .map(
          (e) => CategoryModel.fromMap(data: e),
        )
        .toList();
  }

  // FetchSpending Data
  Future<List<SpendingModel>> fetchSpending() async {
    await initDB();

    String query = "SELECT *  FROM $spendingTable;";

    List<Map<String, dynamic>> res = await db?.rawQuery(query) ?? [];

    return res
        .map(
          (e) => SpendingModel.formMap(data: e),
        )
        .toList();
  }

  Future<CategoryModel> fetchSingleCategory({required int id}) async {
    await initDB();

    String query = "SELECT * FROM $categoryTable WHERE category_id = $id;";

    List<Map<String, dynamic>> res = await db?.rawQuery(query) ?? [];

    return CategoryModel(
        id: res[0]['category_id'],
        name: res[0][categoryName],
        image: res[0][categoryImage],
        index: res[0][categoryImageIndex]);
  }

  Future<List<CategoryModel>> liveSearchCategory(
      {required String search}) async {
    await initDB();

    String query =
        "SELECT * FROM $categoryTable WHERE $categoryName LIKE '%$search%';";

    List<Map<String, dynamic>> res = await db?.rawQuery(query) ?? [];

    return res
        .map(
          (e) => CategoryModel.fromMap(data: e),
        )
        .toList();
  }

  // Update Category Data
  Future<int?> updateCategory({required CategoryModel model}) async {
    await initDB();

    String query =
        "UPDATE $categoryTable SET $categoryName = ?, $categoryImage = ?, $categoryImageIndex = ? WHERE category_id = ${model.id};";
    List arg = [
      model.name,
      model.image,
      model.index,
    ];
    return await db?.rawUpdate(query, arg);
  }
  // Update Spending Data
  Future<int?> updateSpending({required SpendingModel model}) async {
    await initDB();

    String query =
        "UPDATE $spendingTable SET $spendingDesc = ?, $spendingAmount = ?, $spendingMode = ?, $spendingDate = ?, $spendingCategoryId = ? WHERE spending_id = ${model.id};";
    List arg = [
      model.desc,
      model.amount,
      model.mode,
      model.date,
      model.categoryId,
      model.id,
    ];
    return await db?.rawUpdate(query, arg);
  }



  // Delete Category Data
  Future<int?> deleteCategory({required int id}) async {
    await initDB();

    String query = "DELETE FROM $categoryTable WHERE category_id=$id;";

    return await db?.rawDelete(query);
  }

  // DeleteSpending Data
  Future<int?> deleteSpending({required int id}) async {
    await initDB();

    String query = "DELETE FROM $spendingTable WHERE spending_id=$id;";

    return await db?.rawDelete(query);
  }


}
