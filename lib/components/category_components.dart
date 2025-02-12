import 'package:budget_tracker/controllers/category_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

List<String> categoryImages = [
  "assets/images/bill.png",
  "assets/images/cash.png",
  "assets/images/communication.png",
  "assets/images/deposit.png",
  "assets/images/food.png",
  "assets/images/gift.png",
  "assets/images/health.png",
  "assets/images/movie.png",
  "assets/images/rupee.png",
  "assets/images/salary.png",
  "assets/images/shopping.png",
  "assets/images/transport.png",
  "assets/images/wallet.png",
  "assets/images/withdraw.png",
  "assets/images/other.png",
];
GlobalKey<FormState> categoryKey = GlobalKey<FormState>();
GlobalKey<FormState> spendingKey = GlobalKey<FormState>();
TextEditingController categoryNameController = TextEditingController();
TextEditingController spendingNameController = TextEditingController();
TextEditingController spendingAmountController = TextEditingController();
class CategoryComponents extends StatelessWidget {
  const CategoryComponents({super.key});

  @override
  Widget build(BuildContext context) {
    CategoryController controller = Get.put(CategoryController());

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: categoryKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category title
                Center(
                  child: Text(
                    "Choose a Category !",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Category Name Enter
                TextFormField(
                  controller: categoryNameController,
                  validator: (val) =>
                  val!.isEmpty ? "Required category name" : null,
                  decoration: InputDecoration(
                    labelText: "Category",
                    hintText: "Enter your category",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.deepPurpleAccent,
                        width: 2,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.redAccent),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.redAccent),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Category Image Show
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                    ),
                    itemCount: categoryImages.length,
                    itemBuilder: (context, index) =>
                        GetBuilder<CategoryController>(
                          builder: (controller) {
                            return GestureDetector(
                              onTap: () {
                                controller.getCategoryIndex(index: index);
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: (controller.categoryIndex == index)
                                        ? Colors.green
                                        : Colors.transparent,
                                    width: 3,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  image: DecorationImage(
                                    image: AssetImage(categoryImages[index]),
                                    fit: BoxFit.cover,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.white,
                                      blurRadius: 4,
                                      offset: const Offset(2, 4),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                  ),
                ),
                const SizedBox(height: 80), // Floating button ni jagya mate jagya muki
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: Center(
            child: FloatingActionButton.extended(
              onPressed: () async {
                if (categoryKey.currentState!.validate() &&
                    controller.categoryIndex != null) {
                  String name = categoryNameController.text;
                  String assetPath = categoryImages[controller.categoryIndex!];

                  ByteData byteData = await rootBundle.load(assetPath);
                  Uint8List image = byteData.buffer.asUint8List();

                  controller.addCategoryData(name: name, image: image);
                } else {
                  Get.snackbar(
                    "Required",
                    "Category name and image are required.",
                    colorText: Colors.white,
                    backgroundColor: Colors.redAccent,
                  );
                }
                categoryNameController.clear();
                controller.assignDefaultVal();
              },
              icon: const Icon(CupertinoIcons.add_circled),
              label: const Text("Add Category"),
              backgroundColor: Colors.green,
            ),
          ),
        ),
      ],
    );
  }
}
