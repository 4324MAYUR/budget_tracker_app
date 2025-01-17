import 'package:budget_tracker/components/category_components.dart';
import 'package:budget_tracker/controllers/category_controller.dart';
import 'package:budget_tracker/helper/db_helper.dart';
import 'package:budget_tracker/modals/spending_modal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllSpendingComponents extends StatelessWidget {
  const AllSpendingComponents({super.key});

  @override
  Widget build(BuildContext context) {
    CategoryController controller = Get.put(CategoryController());
    controller.fetchSpendingData();
    return GetBuilder<CategoryController>(
      builder: (controller) {
        return FutureBuilder(
          future: controller.allSpending,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<SpendingModel> spendingData = snapshot.data ?? [];

              return (spendingData.isNotEmpty)
                  ? ListView.builder(
                      itemCount: spendingData.length,
                      itemBuilder: (context, index) {
                        var data = spendingData[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black45,
                                blurRadius: 6,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data.desc,
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "₹ ${data.amount}",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 12),
                                Row(
                                  children: [
                                    Text(
                                      "DATE : ",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      data.date,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12),
                                FutureBuilder(
                                  future: DBHelper.dbHelper
                                      .fetchSingleCategory(id: data.categoryId),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return Text(
                                        snapshot.data!.name,
                                        style: const TextStyle(
                                          color: Colors.black,
                                        ),
                                      );
                                    }
                                    return Container();
                                  },
                                ),
                                SizedBox(height: 12),
                                GetBuilder<CategoryController>(
                                  builder: (controller) {
                                    return Row(
                                      children: [
                                        FutureBuilder(
                                          future: DBHelper.dbHelper
                                              .fetchSingleCategory(
                                                  id: data.categoryId),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              return (snapshot.data != null)
                                                  ? Image.memory(
                                                      snapshot.data!.image,
                                                      height: 50)
                                                  : Container();
                                            }
                                            return Container();
                                          },
                                        ),
                                        SizedBox(width: 20),
                                        ActionChip(
                                          label: Text(
                                            data.mode,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          backgroundColor:
                                              (data.mode == "offline")
                                                  ? Colors.lightBlue
                                                  : Colors.blueAccent,
                                        ),
                                        Spacer(),
                                        IconButton(
                                          onPressed: () {
                                            spendingNameController.text =
                                                data.desc;
                                            spendingAmountController.text =
                                                data.amount.toString();
                                            Get.bottomSheet(
                                              Container(
                                                width: double.infinity,
                                                padding:
                                                    const EdgeInsets.all(16),
                                                decoration: const BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(20),
                                                    topRight:
                                                        Radius.circular(20),
                                                  ),
                                                ),
                                                child: Form(
                                                  key: categoryKey,
                                                  child: Column(
                                                    children: [
                                                      SizedBox(height: 10),
                                                      const Text(
                                                        "Update Category",
                                                        style: TextStyle(
                                                          fontSize: 25,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      SizedBox(height: 20),
                                                      TextFormField(
                                                        controller:
                                                            spendingNameController,
                                                        validator: (val) =>
                                                            val!.isEmpty
                                                                ? "Required..."
                                                                : null,
                                                        decoration:
                                                            InputDecoration(
                                                          labelText:
                                                              "Spending Desc",
                                                          hintText:
                                                              "Enter Desc...",
                                                          enabledBorder:
                                                              OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              12),
                                                                  borderSide:
                                                                      const BorderSide(
                                                                    color: Colors
                                                                        .grey,
                                                                  )),
                                                          focusedBorder: OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12),
                                                              borderSide:
                                                                  const BorderSide(
                                                                      color: Colors
                                                                          .deepPurpleAccent)),
                                                          errorBorder:
                                                              OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              12),
                                                                  borderSide:
                                                                      const BorderSide(
                                                                    color: Colors
                                                                        .redAccent,
                                                                  )),
                                                          focusedErrorBorder:
                                                              OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              12),
                                                                  borderSide:
                                                                      const BorderSide(
                                                                    color: Colors
                                                                        .redAccent,
                                                                  )),
                                                        ),
                                                      ),
                                                      SizedBox(height: 20),
                                                      TextFormField(
                                                        controller:
                                                            spendingAmountController,
                                                        validator: (val) =>
                                                            val!.isEmpty
                                                                ? "Required..."
                                                                : null,
                                                        decoration:
                                                            InputDecoration(
                                                          labelText: "Spending",
                                                          hintText:
                                                              "Enter Amount...",
                                                          enabledBorder:
                                                              OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              12),
                                                                  borderSide:
                                                                      const BorderSide(
                                                                    color: Colors
                                                                        .grey,
                                                                  )),
                                                          focusedBorder: OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12),
                                                              borderSide:
                                                                  const BorderSide(
                                                                      color: Colors
                                                                          .deepPurpleAccent)),
                                                          errorBorder:
                                                              OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              12),
                                                                  borderSide:
                                                                      const BorderSide(
                                                                    color: Colors
                                                                        .redAccent,
                                                                  )),
                                                          focusedErrorBorder:
                                                              OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              12),
                                                                  borderSide:
                                                                      const BorderSide(
                                                                    color: Colors
                                                                        .redAccent,
                                                                  )),
                                                        ),
                                                      ),
                                                      SizedBox(height: 10),
                                                      DropdownButton(
                                                        value: controller.mode,
                                                        hint: const Text(
                                                            "Select"),
                                                        items: const [
                                                          DropdownMenuItem(
                                                            value: "online",
                                                            child:
                                                                Text("online"),
                                                          ),
                                                          DropdownMenuItem(
                                                            value: "offline",
                                                            child:
                                                                Text("offline"),
                                                          ),
                                                        ],
                                                        onChanged: controller
                                                            .getSpendingMode,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            "DATE : ",
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          IconButton(
                                                            onPressed:
                                                                () async {
                                                              DateTime? date =
                                                                  await showDatePicker(
                                                                context:
                                                                    context,
                                                                initialDate:
                                                                    DateTime
                                                                        .now(),
                                                                firstDate:
                                                                    DateTime(
                                                                        2000),
                                                                lastDate:
                                                                    DateTime(
                                                                        2026),
                                                              );

                                                              if (date !=
                                                                  null) {
                                                                controller
                                                                    .getSpendingDate(
                                                                        date:
                                                                            date);
                                                              }
                                                            },
                                                            icon: const Icon(
                                                                Icons
                                                                    .date_range),
                                                          ),
                                                          if (controller
                                                                  .dateTime !=
                                                              null)
                                                            Text(
                                                              "${controller.dateTime?.day}/${controller.dateTime?.month}/${controller.dateTime?.year}",
                                                            )
                                                          else
                                                            const Text(
                                                                "DD/MM/YYYY"),
                                                        ],
                                                      ),
                                                      FloatingActionButton
                                                          .extended(
                                                        onPressed: () async {
                                                          if (spendingKey
                                                              .currentState!
                                                              .validate()) {
                                                            String desc =
                                                                spendingNameController
                                                                    .text;
                                                            double amount =
                                                                spendingAmountController
                                                                        .value
                                                                    as double;

                                                            SpendingModel
                                                                model =
                                                                SpendingModel(
                                                              desc: desc,
                                                              amount: amount,
                                                              mode: controller
                                                                  .mode
                                                                  .toString(),
                                                              date: controller
                                                                  .dateTime
                                                                  .toString(),
                                                              id: controller
                                                                  .categoryId,
                                                              categoryId: controller
                                                                  .spendingIndex!,
                                                            );

                                                            controller
                                                                .updateSpendingData(
                                                                    model:
                                                                        model);
                                                            Get.back();
                                                          }
                                                        },
                                                        label: const Text(
                                                          "Update Spending",
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                            Get.back();
                                            Navigator.pop(context);
                                          },
                                          icon: Icon(Icons.edit,
                                              color: Colors.black,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            controller.deleteSpending(
                                                id: data.id);
                                          },
                                          icon: Icon(Icons.delete,
                                              color: Colors.redAccent),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                                ],
                            ),
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: Text("No Spending Data Available"),
                    );
            }
            return const Center(child: CircularProgressIndicator());
          },
        );
      },
    );
  }
}
