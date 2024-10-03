import 'package:budget_app_flutter/body.dart';
import 'package:budget_app_flutter/components/expenseContainer.dart';
import 'package:budget_app_flutter/databaseMethods.dart';
import 'package:budget_app_flutter/global.dart';
import 'package:budget_app_flutter/models/expense.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:sizer/sizer.dart';

import '../models/budget.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    openDB();

    getExpensesFromDB();
  }

  List<Expense> listOfExpesnses = [];
  List<Widget> expenses = [];

  void getExpensesFromDB() async {
    setState(() {
      listOfExpesnses.clear();
    });
    listOfExpesnses = await getAllExpenses();

    listOfExpesnses.forEach((element) async {
      expenses.add(await container(element));
      setState(() {});
    });

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
                              Navigator.pushReplacement(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (_) => Body(
                                            indexOfPage: 2,
                                          )));
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
                      child: setText("History", 15.sp, FontWeight.w600,
                          colorOfText, TextAlign.start, true),
                    ),
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
                        for (int i = 0; i < expenses.length; i++) expenses[i],
                        if (expenses.isEmpty)
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

  Future<Widget> container(Expense expense) async {
    Budget budget = await getBudgetUsingId(expense.budgetId);
    return Container(
      width: 90.w,
      margin: EdgeInsets.only(bottom: 3.h),
      // height: 10.h,
      decoration: BoxDecoration(
        color: colors[budget.colorIndex].withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
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
                setText(expense.name, 11.sp, FontWeight.bold, colorOfText,
                    TextAlign.start),
                setText(
                    "${expense.year}/${expense.month}/${expense.day}",
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
                  formatNumberWithCommas(expense.amount),
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
          setText("From: '${budget.name}'", 9.sp, FontWeight.w600, colorOfText)
        ],
      ),
    );
  }
}
