import 'dart:ui';
import 'package:budget_app_flutter/body.dart';
import 'package:budget_app_flutter/components/budgetContainer.dart';
import 'package:budget_app_flutter/components/input.dart';
import 'package:budget_app_flutter/models/budget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:uuid/uuid.dart';
import '../databaseMethods.dart';
import '../global.dart';

class Budgets extends StatefulWidget {
  // const Budgets({super.key});

  final Function(int) onTap;

  const Budgets({super.key, required this.onTap});

  @override
  State<Budgets> createState() => _BudgetsState();
}

class _BudgetsState extends State<Budgets> {
  TextEditingController nameController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  var database;
  @override
  void initState() {
    super.initState();
    openDB();
    getBudgetsFromDB();
  }

  void getBudgetsFromDB() async {
    if (mounted) {
      setState(() {
        listOfBudgets.clear();
      });
    }
    listOfBudgets = await getBudgets();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    // Add any cleanup if necessary
    super.dispose();
  }

  bool validName = true;
  // List<Budget> listOfBudgets = [];
  bool validAmount = true;

  @override
  Widget build(BuildContext context) {
    return Animate(
      child: Container(
        height: 90.h,
        color: bodyColor,
        child: Column(
          children: [
            SizedBox(
              height: 5.h,
            ),
            SizedBox(
              child: Row(
                children: [
                  SizedBox(
                    width: 10.w,
                  ),
                  SizedBox(
                    width: 66.w,
                    child: setText("Budgets", 15.sp, FontWeight.w600,
                        colorOfText, TextAlign.start),
                  ),
                  Container(
                      width: 14.w,
                      height: 14.w,
                      decoration: BoxDecoration(
                          // color: secondary,
                          border: Border.all(
                              color: colorOfText.withOpacity(0.2), width: 2),
                          borderRadius: BorderRadius.circular(18)),
                      child: IconButton(
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16))),
                          ),
                          onPressed: () {
                            // widget.onTap(true);
                            showDialog(
                              context: context,
                              builder: (context) {
                                return StatefulBuilder(
                                  builder: (context, setState) {
                                    return Animate(
                                      child: GestureDetector(
                                        onTap: () => {
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus()
                                        },
                                        child: AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          surfaceTintColor: bodyColor,
                                          backgroundColor: bodyColor,
                                          title: setText(
                                              "Add budget",
                                              15.sp,
                                              FontWeight.w500,
                                              colorOfText,
                                              TextAlign.start),
                                          // content: Text(),
                                          actions: <Widget>[
                                            SizedBox(
                                              width: 100.w,
                                              height: 3.h,
                                            ),
                                            MyInput(
                                              controller: nameController,
                                              text: "Budeget name",
                                              errorColor: validName
                                                  ? Colors.transparent
                                                  : errorColor,
                                              isNumber: false,
                                            ),
                                            MyInput(
                                              controller: amountController,
                                              text: "Max spending",
                                              errorColor: validAmount
                                                  ? Colors.transparent
                                                  : errorColor,
                                              isNumber: true,
                                            ),
                                            SizedBox(
                                              height: 3.h,
                                            ),
                                            Center(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Container(
                                                    width: 14.w,
                                                    height: 14.w,
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: secondary),
                                                    child: IconButton(
                                                      icon: const Icon(
                                                          Icons.image),
                                                      onPressed: () {
                                                        _showIconPicker(
                                                            context);
                                                      },
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 35.w,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  12)),
                                                      gradient: grad,
                                                    ),
                                                    child: TextButton(
                                                      onPressed: () async {
                                                        if (nameController.text
                                                                .isNotEmpty &&
                                                            amountController
                                                                .text
                                                                .isNotEmpty) {
                                                          Budget budget = Budget(
                                                              id: const Uuid()
                                                                  .v4(),
                                                              name:
                                                                  nameController
                                                                      .text,
                                                              maxAmount:
                                                                  double.parse(
                                                                      amountController
                                                                          .text),
                                                              isMonthly: 0,
                                                              iconIndex:
                                                                  selectedIconIndex,
                                                              colorIndex:
                                                                  listOfBudgets
                                                                          .length %
                                                                      colors
                                                                          .length);

                                                          await insertBudget(
                                                              budget);

                                                          setState(() {
                                                            prefs.setInt(
                                                                "${budget.id},icon",
                                                                selectedIconIndex);

                                                            selectedIconIndex =
                                                                0;
                                                          });

                                                          Navigator.pop(
                                                              context);
                                                          nameController
                                                              .clear();
                                                          amountController
                                                              .clear();
                                                          setState(() {
                                                            validName = true;
                                                            validAmount = true;
                                                          });
                                                          getBudgetsFromDB();
                                                        } else {
                                                          setState(() {
                                                            if (nameController
                                                                .text.isEmpty) {
                                                              validName = false;
                                                            }
                                                            if (amountController
                                                                .text.isEmpty) {
                                                              validAmount =
                                                                  false;
                                                            }
                                                          });
                                                        }
                                                      },
                                                      child: setText(
                                                          "Add",
                                                          10.sp,
                                                          FontWeight.w600,
                                                          Colors.white),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                        .slideY(
                                            begin: -0.05,
                                            end: 0,
                                            duration: 400.ms,
                                            curve: curve)
                                        .fadeIn();
                                  },
                                );
                              },
                            );
                          },
                          icon: Icon(
                            Icons.add,
                            color: colorOfText.withOpacity(0.8),
                            size: 8.w,
                          ))),
                  SizedBox(
                    width: 5.w,
                  ),
                ],
              ),
            ),

            ////  body //////////////////////////////////////////////////////

            SizedBox(
              height: 3.h,
            ),
            Expanded(
              child: SizedBox(
                width: 100.w,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      if (listOfBudgets.isNotEmpty)
                        for (int i = 0; i < listOfBudgets.length; i++)
                          BudgetContainer(
                            budget: listOfBudgets[i],
                            color: colors[listOfBudgets[i].colorIndex],
                            icon: icons[listOfBudgets[i].iconIndex],
                            onLong: delte,
                          ),
                      if (listOfBudgets.isEmpty)
                        SizedBox(
                          height: 70.h,
                          child: Center(
                            child: setText(
                                "Click on '+' to add a budget.",
                                12.sp,
                                FontWeight.w500,
                                colorOfText.withOpacity(0.5)),
                          ),
                        ),
                      SizedBox(
                        height: 5.h,
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    )
        .fadeIn(
          duration: 500.ms,
        )
        .slideY(begin: -0.06, end: 0, curve: curve, duration: 500.ms);
  }

  delte(String id) {
    deleteBudget(id);
    Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
            builder: (_) => Body(
                  indexOfPage: 1,
                )));
    // getBudgetsFromDB();
  }

  IconData? selectedIcon;
  int selectedIconIndex = 0;

  void _showIconPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Animate(
          child: AlertDialog(
            backgroundColor: bodyColor,
            surfaceTintColor: bodyColor,
            title:
                setText("Select an icon", 14.sp, FontWeight.w500, colorOfText),
            content: Container(
              width: double.maxFinite,
              height: 40.h,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                ),
                itemCount: icons.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIcon = icons[index];
                        selectedIconIndex = index;
                      });
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: Icon(icons[index],
                        size: 7.w,
                        color: icons[index] == selectedIcon
                            ? primaryBlue
                            : colorOfText),
                  );
                },
              ),
            ),
          ),
        ).scale(
            begin: const Offset(1.2, 1.2),
            end: const Offset(1, 1),
            curve: curve,
            duration: 300.ms);
      },
    );
  }
}
