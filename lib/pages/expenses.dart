import 'package:budget_app_flutter/components/expenseContainer.dart';
import 'package:budget_app_flutter/components/input.dart';
import 'package:budget_app_flutter/databaseMethods.dart';
import 'package:budget_app_flutter/global.dart';
import 'package:budget_app_flutter/models/expense.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:uuid/uuid.dart';

import '../models/budget.dart';

class Expneses extends StatefulWidget {
  final Budget budget;
  const Expneses({super.key, required this.budget});

  @override
  State<Expneses> createState() => _ExpnesesState();
}

class _ExpnesesState extends State<Expneses> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    openDB();

    getExpensesFromDB();
  }

  List<Expense> listOfExpesnses = [];

  void getExpensesFromDB() async {
    setState(() {
      listOfExpesnses.clear();
    });
    listOfExpesnses = await getExpensesBudget(widget.budget.id);

    setState(() {});

    // print(await sumOfExpenses(widget.budget.id));
  }

  @override
  Widget build(BuildContext context) {
    return Animate(
        child: Container(
            height: 90.h,
            color: bodyColor,
            child: Column(children: [
              SizedBox(
                height: 5.h,
              ),
              SizedBox(
                child: Row(
                  children: [
                    SizedBox(
                      width: 7.w,
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
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.arrow_back_rounded,
                              color: colorOfText.withOpacity(0.8),
                              size: 8.w,
                            ))),
                    SizedBox(
                      width: 5.w,
                    ),
                    SizedBox(
                      width: 65.w,
                      child: setText("'${widget.budget.name}' expenses", 15.sp,
                          FontWeight.w600, colorOfText, TextAlign.start, true),
                    ),
                    // Container(
                    //     width: 14.w,
                    //     height: 14.w,
                    //     decoration: BoxDecoration(
                    //         // color: secondary,
                    //         border: Border.all(
                    //             color: colorOfText.withOpacity(0.2), width: 2),
                    //         borderRadius: BorderRadius.circular(18)),
                    //     child: IconButton(
                    //         onPressed: () {
                    //           Navigator.pop(context);
                    //         },
                    //         icon: Icon(
                    //           Icons.arrow_back_rounded,
                    //           color: colorOfText.withOpacity(0.8),
                    //           size: 8.w,
                    //         ))),
                  ],
                ),
              ),
              SizedBox(
                height: 3.h,
              ),
              SizedBox(
                width: 85.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                        width: 85.w,
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
                                                "Add expnese",
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
                                                text: "Expnese",
                                                errorColor: validName
                                                    ? Colors.transparent
                                                    : errorColor,
                                                isNumber: false,
                                              ),
                                              MyInput(
                                                controller: amountController,
                                                text: "Amount",
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
                                                          print(DateTime.now()
                                                              .weekday);
                                                          if (nameController
                                                                  .text
                                                                  .isNotEmpty &&
                                                              amountController
                                                                  .text
                                                                  .isNotEmpty) {
                                                            insertExpense(Expense(
                                                                amount: double.parse(
                                                                    amountController
                                                                        .text),
                                                                week:
                                                                    getCurrentWeekNumber(),
                                                                name:
                                                                    nameController
                                                                        .text,
                                                                budgetId: widget
                                                                    .budget.id,
                                                                id: const Uuid()
                                                                    .v4(),
                                                                day: DateTime
                                                                        .now()
                                                                    .weekday,
                                                                month: DateTime
                                                                        .now()
                                                                    .month,
                                                                year: DateTime
                                                                        .now()
                                                                    .year));

                                                            Navigator.pop(
                                                                context);
                                                            nameController
                                                                .clear();
                                                            amountController
                                                                .clear();
                                                            setState(() {
                                                              validName = true;
                                                              validAmount =
                                                                  true;
                                                            });

                                                            // getBudgetsFromDB();
                                                            getExpensesFromDB();
                                                          } else {
                                                            setState(() {
                                                              if (nameController
                                                                  .text
                                                                  .isEmpty) {
                                                                validName =
                                                                    false;
                                                              }
                                                              if (amountController
                                                                  .text
                                                                  .isEmpty) {
                                                                validAmount =
                                                                    false;
                                                              }
                                                            });
                                                          }
                                                        },
                                                        child: setText(
                                                            "Add",
                                                            11.sp,
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
                            icon: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                setText(
                                    "Add", 10.sp, FontWeight.bold, colorOfText),
                                Icon(
                                  Icons.add,
                                  color: colorOfText.withOpacity(0.8),
                                  size: 8.w,
                                ),
                              ],
                            ))),
                  ],
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              SizedBox(
                width: 85.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                        width: 85.w,
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        decoration: BoxDecoration(
                            gradient: grad,
                            color: listOfExpesnses.isNotEmpty
                                ? Colors.black.withOpacity(1)
                                : Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(18)),
                        child: IconButton(
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16))),
                            ),
                            onPressed: () {
                              if (listOfExpesnses.isNotEmpty) {
                                showSaveAndResetAlert();
                              }
                            },
                            icon: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                setText("Save and reset", 11.sp,
                                    FontWeight.bold, Colors.white),
                                SizedBox(
                                  width: 2.w,
                                ),
                                Icon(
                                  FontAwesomeIcons.fileArrowDown,
                                  color: Colors.white,
                                  size: 8.w,
                                ),
                              ],
                            ))),
                  ],
                ),
              ),
              SizedBox(
                height: 3.h,
              ),
              Expanded(
                child: SizedBox(
                  width: 100.w,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 2.h,
                        ),
                        for (int i = 0; i < listOfExpesnses.length; i++)
                          ExpesnseContainer(
                            expesnse: listOfExpesnses[i],
                            budget: widget.budget,
                          ),
                        if (listOfExpesnses.isEmpty)
                          SizedBox(
                            width: 80.w,
                            child: setText("No expenses yet...", 12.sp,
                                FontWeight.w500, colorOfText.withOpacity(0.5)),
                          ),

                        // ExpneseContainer(),
                        // ExpneseContainer(),
                        // ExpneseContainer(),
                        // ExpneseContainer(),
                        SizedBox(
                          height: 6.h,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ])));
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  bool validName = true;
  bool validAmount = true;

  void showSaveAndResetAlert() {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Animate(
                    child: GestureDetector(
                        onTap: () =>
                            {FocusManager.instance.primaryFocus?.unfocus()},
                        child: AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32),
                            ),
                            surfaceTintColor: bodyColor,
                            backgroundColor: bodyColor,

                            // content: Text(),
                            actions: <Widget>[
                              SizedBox(
                                width: 80.w,
                                // height: 35.h,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 5.h,
                                      ),
                                      Icon(
                                        FontAwesomeIcons.fileArrowDown,
                                        size: 18.w,
                                        color: primaryBlue,
                                      ),
                                      SizedBox(
                                        height: 2.h,
                                      ),
                                      setText(
                                          "Reset the content of this budget while saving the data of the current expenses in the statistcs.",
                                          10.sp,
                                          FontWeight.w500,
                                          colorOfText,
                                          TextAlign.center,
                                          true),
                                      SizedBox(
                                        height: 4.h,
                                      ),
                                      Container(
                                        width: 35.w,
                                        decoration: BoxDecoration(
                                            gradient: grad,
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        child: TextButton(
                                          onPressed: () {
                                            listOfExpesnses.forEach((element) {
                                              saveAndReset(element);
                                            });

                                            Navigator.pop(context);
                                            Navigator.pushReplacement(
                                                context,
                                                CupertinoPageRoute(
                                                    builder: (_) => Expneses(
                                                          budget: widget.budget,
                                                        )));
                                          },
                                          child: setText("Confirm", 10.sp,
                                              FontWeight.bold, Colors.white),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ])))
                .fadeIn(duration: 500.ms, curve: curve)
                .slideY(begin: -0.06, end: 0, curve: curve, duration: 500.ms);
          });
        });
  }
}
