import 'package:budget_tracker/components/category_components.dart';
import 'package:budget_tracker/controllers/category_controller.dart';
import 'package:budget_tracker/modals/category_modal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AllCategoryComponents extends StatelessWidget {
  const AllCategoryComponents({super.key});

  @override
  Widget build(BuildContext context) {
    CategoryController controller = Get.put(CategoryController());
    controller.fetchCategoryData();
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Category Search TextField
          TextField(
            onChanged: (val) async {
              controller.searchData(val: val);
            },
            decoration: const InputDecoration(
              prefixIcon: Icon(CupertinoIcons.search),
              hintText: "Search",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: GetBuilder<CategoryController>(
              builder: (context) {
                return FutureBuilder(
                  future: controller.allCategory,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text("ERROR: ${snapshot.error}"),
                      );
                    } else if (snapshot.hasData) {
                      List<CategoryModel> allCategoryData = snapshot.data ?? [];
                      return allCategoryData.isNotEmpty
                          ? ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: allCategoryData.length,
                        itemBuilder: (context, index) {
                          CategoryModel data = CategoryModel(
                            id: allCategoryData[index].id,
                            name: allCategoryData[index].name,
                            image: allCategoryData[index].image,
                            index: allCategoryData[index].index,
                          );
                          return Card(
                            elevation: 5,
                            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15),),
                            child: ListTile(
                              leading: CircleAvatar(
                                radius: 26,
                                backgroundImage: MemoryImage(data.image),
                              ),
                              title: Text(
                                data.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      categoryNameController.text = data.name;

                                      controller.assignDefaultVal();

                                      Get.bottomSheet(
                                        Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.all(16),
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(25),
                                              topRight: Radius.circular(25),
                                            ),
                                          ),
                                          child: Form(
                                            key: categoryKey,
                                            child: Column(
                                              children: [
                                                const Text(
                                                  "Update Category ",
                                                  style: TextStyle(
                                                    fontSize: 26,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(height: 10),
                                                TextFormField(
                                                  controller: categoryNameController,
                                                  validator: (val) => val!.isEmpty
                                                      ? "Required..."
                                                      : null,
                                                  decoration: InputDecoration(
                                                    labelText: "Category",
                                                    hintText: "Enter category...",
                                                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                                                        borderSide: const BorderSide(color: Colors.grey,)),
                                                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                                                        borderSide: const BorderSide(color: Colors.deepPurpleAccent,)),
                                                    errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                                                        borderSide: const BorderSide(color: Colors.redAccent,)),
                                                    focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                                                        borderSide: const BorderSide(color: Colors.redAccent)),
                                                  ),
                                                ),
                                                SizedBox(height: 10),
                                                Expanded(
                                                  child: GridView.builder(gridDelegate:
                                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 5,
                                                  ),
                                                    itemCount: categoryImages.length,
                                                    itemBuilder: (context, index) =>
                                                        GetBuilder<CategoryController>(
                                                          builder: (context) {
                                                            return GestureDetector(
                                                              onTap: () {
                                                                controller.getCategoryIndex(index: index);
                                                              },
                                                              child: Container(
                                                                margin: const EdgeInsets.all(5),
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(12),
                                                                  border: Border.all(
                                                                    color: (controller.categoryIndex != null)
                                                                        ? (controller.categoryIndex == index)
                                                                        ? Colors.grey
                                                                        : Colors.transparent
                                                                        : (index == data.index)
                                                                        ? Colors.grey
                                                                        : Colors.transparent,
                                                                  ),
                                                                  image: DecorationImage(
                                                                    image: AssetImage(categoryImages[index],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                  ),
                                                ),
                                                FloatingActionButton.extended(
                                                  onPressed: () async {
                                                    if (categoryKey.currentState!.validate() &&
                                                        controller.categoryIndex != null) {
                                                      String name = categoryNameController.text;

                                                      String assetPath = categoryImages[controller.categoryIndex!];

                                                      ByteData byteData = await rootBundle.load(assetPath);
                                                      Uint8List image = byteData.buffer.asUint8List();

                                                      CategoryModel
                                                      model = CategoryModel(
                                                        id: data.id,
                                                        name: name,
                                                        image: image,
                                                        index: controller.categoryIndex!,
                                                      );

                                                      controller.updateCategoryData(model: model);
                                                      Get.back();
                                                    }
                                                  },
                                                  label: const Text(
                                                    "Update Category",
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.green.shade100,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.green.withOpacity(0.4),
                                            offset: const Offset(2, 2),
                                            blurRadius: 4,
                                          ),
                                        ],
                                      ),
                                      child: const Icon(
                                        Icons.edit,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  InkWell(
                                    onTap: () {
                                      controller.deleteCategory(id: data.id);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.red.shade100,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.red.withOpacity(0.4),
                                            offset: const Offset(2, 2),
                                            blurRadius: 4,
                                          ),
                                        ],
                                      ),
                                      child: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                          : const Center(
                        child: Text("No Category Available"),
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
