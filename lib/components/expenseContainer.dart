import 'package:budget_app_flutter/components/input.dart';
import 'package:budget_app_flutter/databaseMethods.dart';
import 'package:budget_app_flutter/models/budget.dart';
import 'package:budget_app_flutter/models/expense.dart';
import 'package:budget_app_flutter/pages/expenses.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sizer/sizer.dart';

import '../global.dart';

class expenseContainer extends StatefulWidget {
  final Expense expense;
  final Budget budget;
  const expenseContainer(
      {super.key, required this.expense, required this.budget});

  @override
  State<expenseContainer> createState() => _expenseContainerState();
}

class _expenseContainerState extends State<expenseContainer> {
  TextEditingController nameController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController.text = widget.expense.name;
    amountController.text = widget.expense.amount.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90.w,
      margin: EdgeInsets.only(bottom: 3.h),
      // height: 10.h,
      decoration: BoxDecoration(
        color: secondary,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorOfText.withOpacity(0.1),
            spreadRadius: 0.1,
            blurRadius: 10,
            offset: Offset(0, 5), // changes position of shadow
          ),
        ],
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                setText(widget.expense.name, 11.sp, FontWeight.bold,
                    colorOfText, TextAlign.start),
                setText(
                    widget.expense.year.toString() +
                        "/" +
                        widget.expense.month.toString() +
                        "/" +
                        widget.expense.day.toString(),
                    9.sp,
                    FontWeight.w500,
                    colorOfText.withOpacity(0.5),
                    TextAlign.start),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              setText(
                  formatNumberWithCommas(widget.expense.amount),
                  11.sp,
                  FontWeight.w500,
                  colorOfText.withOpacity(0.7),
                  TextAlign.start),
              Icon(
                currencies[indexOfCurrency],
                color: colorOfText.withOpacity(0.7),
                size: 12.sp,
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [],
          ),
          SizedBox(
            height: 3.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: primaryBlue)),
                width: 30.w,
                child: TextButton(
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16))),
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
                                  FocusManager.instance.primaryFocus?.unfocus()
                                },
                                child: AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  surfaceTintColor: bodyColor,
                                  backgroundColor: bodyColor,
                                  title: setText(
                                      "Edit expnese",
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
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Container(
                                            width: 35.w,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(12)),
                                              gradient: grad,
                                            ),
                                            child: TextButton(
                                              style: TextButton.styleFrom(
                                                  padding: EdgeInsets.zero),
                                              onPressed: () async {
                                                print(DateTime.now().weekday);
                                                if (nameController
                                                        .text.isNotEmpty &&
                                                    amountController
                                                        .text.isNotEmpty) {
                                                  updateExpense(Expense(
                                                      id: widget.expense.id,
                                                      budgetId: widget
                                                          .expense.budgetId,
                                                      name: nameController.text,
                                                      week: widget.expense.week,
                                                      amount: double.parse(
                                                          amountController
                                                              .text),
                                                      day: widget.expense.day,
                                                      month:
                                                          widget.expense.month,
                                                      year:
                                                          widget.expense.year));

                                                  Navigator.pop(context);
                                                  nameController.clear();
                                                  amountController.clear();
                                                  setState(() {
                                                    validName = true;
                                                    validAmount = true;
                                                  });
                                                  Navigator.pushReplacement(
                                                      context,
                                                      CupertinoPageRoute(
                                                          builder: (_) =>
                                                              Expneses(
                                                                budget: widget
                                                                    .budget,
                                                              )));

                                                  // getBudgetsFromDB();
                                                  // getExpensesFromDB();
                                                } else {
                                                  setState(() {
                                                    if (nameController
                                                        .text.isEmpty) {
                                                      validName = false;
                                                    }
                                                    if (amountController
                                                        .text.isEmpty) {
                                                      validAmount = false;
                                                    }
                                                  });
                                                }
                                              },
                                              child: setText(
                                                  "Save",
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      setText("Edit", 10.sp, FontWeight.w600, primaryBlue),
                      SizedBox(
                        width: 2.w,
                        height: 5.5.h,
                      ),
                      Icon(
                        FontAwesomeIcons.pen,
                        size: 5.w,
                        color: primaryBlue,
                      )
                    ],
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: errorColor)),
                width: 30.w,
                child: TextButton(
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16))),
                  ),
                  onPressed: () {
                    deleteExpense(widget.expense.id);
                    Navigator.pushReplacement(
                        context,
                        CupertinoPageRoute(
                            builder: (_) => Expneses(
                                  budget: widget.budget,
                                )));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      setText("Delete", 10.sp, FontWeight.w600, errorColor),
                      SizedBox(
                        width: 2.w,
                        height: 5.5.h,
                      ),
                      Icon(
                        FontAwesomeIcons.trashCan,
                        size: 5.w,
                        color: errorColor,
                      )
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  bool validName = true;
  // List<Budget> listOfBudgets = [];
  bool validAmount = true;
}
