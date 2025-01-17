import 'package:budget_tracker/controllers/category_controller.dart';
import 'package:budget_tracker/helper/db_helper.dart';
import 'package:budget_tracker/modals/category_modal.dart';
import 'package:budget_tracker/modals/spending_modal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

TextEditingController descController = TextEditingController();
TextEditingController amountController = TextEditingController();
GlobalKey<FormState> spendingKey = GlobalKey<FormState>();

class SpendingComponents extends StatelessWidget {
  const SpendingComponents({super.key});

  @override
  Widget build(BuildContext context) {
    CategoryController controller = Get.put(CategoryController());
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GetBuilder<CategoryController>(builder: (ctx) {
        return Form(
          key: spendingKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Add Spending",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                // Spending Description Field
                TextFormField(
                  maxLines: 2,
                  controller: descController,
                  validator: (val) =>
                  val!.isEmpty ? "Description is required." : null,
                  decoration: InputDecoration(
                    labelText: "Description",
                    hintText: "Enter spending description",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                // Spending Amount Field
                TextFormField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  validator: (val) =>
                  val!.isEmpty ? "Amount is required." : null,
                  decoration: InputDecoration(
                    labelText: "Amount",
                    hintText: "Enter spending amount",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                // Spending Mode Dropdown
                Row(
                  children: [
                    const Text(
                      "Mode:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 15),
                    DropdownButton<String>(
                      value: controller.mode,
                      hint: const Text("Select Mode"),
                      items: const [
                        DropdownMenuItem(
                          value: "online",
                          child: Text("Online"),
                        ),
                        DropdownMenuItem(
                          value: "offline",
                          child: Text("Offline"),
                        ),
                      ],
                      onChanged: controller.getSpendingMode,
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                // Spending Date Picker
                Row(
                  children: [
                    const Text(
                      "Date:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        DateTime? date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2026),
                        );

                        if (date != null) {
                          controller.getSpendingDate(date: date);
                        }
                      },
                      icon: const Icon(Icons.date_range),
                    ),
                    Text(
                      controller.dateTime != null
                          ? "${controller.dateTime?.day}/${controller.dateTime?.month}/${controller.dateTime?.year}"
                          : "DD/MM/YYYY",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                // Category Selection Grid
                const Text(
                  "Select Category:",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                FutureBuilder(
                  future: DBHelper.dbHelper.fetchCategory(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<CategoryModel> categories =
                          snapshot.data ?? [];

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        itemCount: categories.length,
                        itemBuilder: (context, index) => GestureDetector(
                          onTap: () {
                            controller.getSpendingIndex(
                              index: index,
                              id: categories[index].id,
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: index == controller.spendingIndex
                                    ? Colors.deepPurpleAccent
                                    : Colors.transparent,
                              ),
                              image: DecorationImage(
                                image: MemoryImage(categories[index].image),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
                const SizedBox(height: 20),
                // Add Spending Button
                Center(
                  child: FloatingActionButton.extended(
                    onPressed: () {
                      if (spendingKey.currentState!.validate() &&
                          controller.mode != null &&
                          controller.dateTime != null &&
                          controller.spendingIndex != null) {
                        controller.addSpendingData(
                          model: SpendingModel(
                            id: 0,
                            desc: descController.text,
                            amount: num.parse(amountController.text),
                            mode: controller.mode!,
                            date:
                            "${controller.dateTime?.day}/${controller.dateTime?.month}/${controller.dateTime?.year}",
                            categoryId: controller.categoryId,
                          ),
                        );
                        descController.clear();
                        amountController.clear();
                        controller.assignDefaultValue();
                      } else {
                        Get.snackbar(
                          "Error",
                          "All fields are required.",
                          backgroundColor: Colors.redAccent,
                          colorText: Colors.white,
                        );
                      }
                    },
                    label: const Text("Add Spending"),
                    icon: const Icon(Icons.add),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
