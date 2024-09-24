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

class ExpesnseContainer extends StatefulWidget {
  final Expense expesnse;
  final Budget budget;
  const ExpesnseContainer(
      {super.key, required this.expesnse, required this.budget});

  @override
  State<ExpesnseContainer> createState() => _ExpesnseContainerState();
}

class _ExpesnseContainerState extends State<ExpesnseContainer> {
  TextEditingController nameController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController.text = widget.expesnse.name;
    amountController.text = widget.expesnse.amount.toString();
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
          setText(widget.expesnse.name, 11.sp, FontWeight.bold, colorOfText,
              TextAlign.start),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              setText(
                  formatNumberWithCommas(widget.expesnse.amount),
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
                                              onPressed: () async {
                                                print(DateTime.now().weekday);
                                                if (nameController
                                                        .text.isNotEmpty &&
                                                    amountController
                                                        .text.isNotEmpty) {
                                                  updateExpense(Expense(
                                                      id: widget.expesnse.id,
                                                      budgetId: widget
                                                          .expesnse.budgetId,
                                                      name: nameController.text,
                                                      week:
                                                          widget.expesnse.week,
                                                      amount: double.parse(
                                                          amountController
                                                              .text),
                                                      day: widget.expesnse.day,
                                                      month:
                                                          widget.expesnse.month,
                                                      year: widget
                                                          .expesnse.year));

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
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      setText("Edit", 10.sp, FontWeight.w600, primaryBlue),
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
                    deleteExpense(widget.expesnse.id);
                    Navigator.pushReplacement(
                        context,
                        CupertinoPageRoute(
                            builder: (_) => Expneses(
                                  budget: widget.budget,
                                )));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      setText("Delete", 10.sp, FontWeight.w600, errorColor),
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
