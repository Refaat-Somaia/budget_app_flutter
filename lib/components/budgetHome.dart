import 'package:budget_app_flutter/databaseMethods.dart';
import 'package:budget_app_flutter/global.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sizer/sizer.dart';

import '../models/budget.dart';
import '../pages/expenses.dart';

class BudgetHome extends StatefulWidget {
  @override
  State<BudgetHome> createState() => _BudgetHomeState();

  final Function(String) onPress;

  final Budget budget;
  final Color color;
  final IconData icon;
  const BudgetHome(
      {super.key,
      required this.budget,
      required this.icon,
      required this.color,
      required this.onPress});
}

class _BudgetHomeState extends State<BudgetHome> {
  double sum = 0;

  void getSumOfExpenses() async {
    sum = await sumOfExpenses(widget.budget.id);
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSumOfExpenses();
  }

  @override
  void dispose() {
    // Add any cleanup if necessary
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Animate(
      child: Container(
        margin: EdgeInsets.only(bottom: 2.h),
        width: 95.w,
        height: 11.h,
        padding: EdgeInsets.symmetric(horizontal: 2.w),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 39, 55, 74).withOpacity(0.1),
            spreadRadius: 0.05,
            blurRadius: 5,
            offset: Offset(0, 5), // changes position of shadow
          ),
        ], borderRadius: BorderRadius.circular(16), color: bodyColor),
        child: TextButton(
          onPressed: () {
            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (_) => Expneses(
                          budget: widget.budget,
                        )));
          },
          onLongPress: () {},
          style: OutlinedButton.styleFrom(
            foregroundColor: widget.color,
            padding: EdgeInsets.zero,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16))),
          ),
          child: Row(
            children: [
              Container(
                width: 16.w,
                margin: EdgeInsets.symmetric(horizontal: 2.w),
                height: 10.h,
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: widget.color),
                child: Icon(
                  widget.icon,
                  color: const Color.fromARGB(255, 39, 55, 74),
                  size: widget.icon == FontAwesomeIcons.xmark ? 0.w : 8.w,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 2.h,
                  ),
                  SizedBox(
                      width: 40.w,
                      height: 4.h,
                      child: SizedBox(
                        width: 30.w,
                        child: setText(widget.budget.name, 11.sp,
                            FontWeight.bold, colorOfText, TextAlign.start),
                      ))
                ],
              ),
              SizedBox(
                width: 10.w,
              ),
              Column(
                children: [
                  SizedBox(
                    height: 2.h,
                  ),
                  SizedBox(
                      width: 20.w,
                      height: 13.sp,
                      child: Center(
                        child: setText(formatNumberWithCommas(sum), 9.sp,
                            FontWeight.w600, colorOfText),
                      )),
                  SizedBox(
                    height: 0.5.h,
                  ),
                  SizedBox(
                      width: 20.w,
                      height: 13.sp,
                      child: Center(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            setText(
                                formatNumberWithCommas(widget.budget.maxAmount),
                                8.sp,
                                FontWeight.w600,
                                colorOfText.withOpacity(0.5)),
                            Icon(
                              currencies[indexOfCurrency],
                              color: colorOfText.withOpacity(0.5),
                              size: 9.sp,
                            )
                          ],
                        ),
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    )
        .slideX(begin: 0.2, end: 0, curve: curve, duration: 500.ms)
        .fade(curve: curve, duration: 500.ms);
  }
}
