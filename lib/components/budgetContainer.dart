import 'dart:async';

import 'package:budget_app_flutter/body.dart';
import 'package:budget_app_flutter/components/input.dart';
import 'package:budget_app_flutter/databaseMethods.dart';
import 'package:budget_app_flutter/pages/expenses.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sizer/sizer.dart';

import '../global.dart';
import '../models/budget.dart';

class BudgetContainer extends StatefulWidget {
  //  const BudgetHome({super.key});
  final Function(String) onLong;

  final Budget budget;
  final Color color;
  final IconData icon;
  const BudgetContainer(
      {super.key,
      required this.budget,
      required this.color,
      required this.icon,
      required this.onLong});

  @override
  State<BudgetContainer> createState() => _BudgetContainerState();
}

class _BudgetContainerState extends State<BudgetContainer>
    with TickerProviderStateMixin {
  late AnimationController controller = AnimationController(
    duration: 500.ms,
    vsync: this,
  );
  bool isDelete = false;
  int duration = 600;

  TextEditingController nameController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController.text = widget.budget.name;
    amountController.text = widget.budget.maxAmount.toString();
  }

  double sum = 0;
  void getSumOfExpenses() async {
    sum = await sumOfExpenses(widget.budget.id);
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    // Add any cleanup if necessary
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    getSumOfExpenses();

    return Animate(
      child: Container(
        width: 90.w,
        height: 20.h,
        margin: EdgeInsets.only(bottom: 3.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: secondary,
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 39, 55, 74).withOpacity(0.1),
              spreadRadius: 0.1,
              blurRadius: 7,
              offset: Offset(0, 5), // changes position of shadow
            ),
          ],
        ),
        child: TextButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: widget.color,
            padding: EdgeInsets.zero,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16))),
          ),
          onPressed: () {
            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (_) => Expneses(
                          budget: widget.budget,
                        )));
          },
          onLongPress: () {
            showDialog(
                context: context,
                builder: (context) {
                  return StatefulBuilder(builder: (context, setState) {
                    return Animate(
                            child: GestureDetector(
                                onTap: () => {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus()
                                    },
                                child: AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(32),
                                    ),
                                    surfaceTintColor: bodyColor,
                                    backgroundColor: bodyColor,

                                    // content: Text(),
                                    actions: <Widget>[
                                      SizedBox(
                                        width: 60.w,
                                        // height: 35.h,
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                height: 5.h,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Column(
                                                    children: [
                                                      Container(
                                                        width: 18.w,
                                                        height: 18.w,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        18),
                                                            color: primaryBlue
                                                                .withOpacity(
                                                                    0.1)),
                                                        child: IconButton(
                                                          onPressed: () {
                                                            showEditAlert();
                                                          },
                                                          icon: Icon(
                                                            FontAwesomeIcons
                                                                .pen,
                                                            color: primaryBlue,
                                                            size: 9.w,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 1.h,
                                                      ),
                                                      setText(
                                                          "Edit",
                                                          10.sp,
                                                          FontWeight.w600,
                                                          primaryBlue),
                                                    ],
                                                  ),
                                                  Column(
                                                    children: [
                                                      Container(
                                                        width: 18.w,
                                                        height: 18.w,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        18),
                                                            color: errorColor
                                                                .withOpacity(
                                                                    0.1)),
                                                        child: IconButton(
                                                          onPressed: () {
                                                            showDeleteAlert();
                                                          },
                                                          icon: Icon(
                                                            FontAwesomeIcons
                                                                .trashCan,
                                                            color: errorColor,
                                                            size: 9.w,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 1.h,
                                                      ),
                                                      setText(
                                                          "Delete",
                                                          10.sp,
                                                          FontWeight.w600,
                                                          errorColor),
                                                    ],
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    ])))
                        .fadeIn(duration: 500.ms, curve: curve)
                        .scale(
                            begin: Offset(1.2, 1.2),
                            end: Offset(1, 1),
                            curve: curve,
                            duration: 400.ms);
                  });
                });
            //  showDeleteAlert();
          },
          child: Stack(
            children: [
              Positioned(
                right: -25.w,
                top: 5.h,
                child: Container(
                  width: 50.w,
                  height: 50.w,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: widget.color),
                  child: Stack(
                    children: [
                      Positioned(
                          top: 6.5.h,
                          left: 10.w,
                          child: Icon(
                            widget.icon,
                            size: widget.icon == FontAwesomeIcons.xmark
                                ? 0.w
                                : 10.w,
                            color: const Color.fromARGB(255, 39, 55, 74),
                          )),
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  SizedBox(
                    height: 2.h,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 5.w,
                      ),
                      SizedBox(
                        width: 70.w,
                        height: 4.h,
                        child: setText(widget.budget.name, 12.sp,
                            FontWeight.bold, colorOfText, TextAlign.start),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 0.5.h,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 6.w,
                      ),
                      SizedBox(
                        child: setText(formatNumberWithCommas(sum), 11.sp,
                            FontWeight.w500, colorOfText, TextAlign.start),
                      ),
                      SizedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            setText(
                                " /${formatNumberWithCommas(widget.budget.maxAmount)}",
                                11.sp,
                                FontWeight.w500,
                                colorOfText.withOpacity(0.5),
                                TextAlign.start),
                            Icon(
                              currencies[indexOfCurrency],
                              color: colorOfText.withOpacity(0.5),
                              size: 13.sp,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 5.w,
                      ),
                      Stack(
                        children: [
                          Container(
                            width: 58.w,
                            height: 1.h,
                            decoration: BoxDecoration(
                                color: colorOfText.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(32)),
                          ),
                          Container(
                            width: ((sum / widget.budget.maxAmount) <= 1
                                    ? ((sum / widget.budget.maxAmount) * 58)
                                    : 58)
                                .w,
                            height: 1.h,
                            decoration: BoxDecoration(
                                color: (sum / widget.budget.maxAmount) < 1
                                    ? widget.color
                                    : errorColor,
                                borderRadius: BorderRadius.circular(32)),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    )
        .animate(controller: controller, autoPlay: false)
        .slideX(begin: 0, end: 1, curve: curve, duration: duration.ms)
        .fadeOut(
          curve: curve,
          duration: duration.ms,
        );
  }

  void showDeleteAlert() {
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
                            width: 60.w,
                            // height: 35.h,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  Icon(
                                    FontAwesomeIcons.trashCan,
                                    size: 18.w,
                                    color: errorColor,
                                  ),
                                  SizedBox(
                                    height: 2.h,
                                  ),
                                  setText("Delete '${widget.budget.name}'?",
                                      11.sp, FontWeight.w600, colorOfText),
                                  SizedBox(
                                    height: 4.h,
                                  ),
                                  Container(
                                    width: 35.w,
                                    decoration: BoxDecoration(
                                        color: errorColor,
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: TextButton(
                                      onPressed: () {
                                        controller.forward();

                                        setState(() {
                                          isDelete = true;
                                        });
                                        Navigator.pop(context);
                                        Navigator.pop(context);

                                        Timer(Duration(milliseconds: duration),
                                            () {
                                          widget.onLong(widget.budget.id);
                                          isDelete = false;
                                          controller.dispose();
                                        });
                                      },
                                      child: setText("Confirm", 10.sp,
                                          FontWeight.bold, Colors.white),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ]))).fadeIn(duration: 500.ms, curve: curve).slideY(
                begin: -0.06, end: 0, curve: curve, duration: 500.ms);
          });
        });
  }

  void showEditAlert() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Animate(
              child: GestureDetector(
                onTap: () => {FocusManager.instance.primaryFocus?.unfocus()},
                child: AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  surfaceTintColor: bodyColor,
                  backgroundColor: bodyColor,
                  title: setText("Edit budget", 15.sp, FontWeight.w500,
                      colorOfText, TextAlign.start),
                  // content: Text(),
                  actions: <Widget>[
                    SizedBox(
                      width: 100.w,
                      height: 3.h,
                    ),
                    MyInput(
                      controller: nameController,
                      text: "Budeget name",
                      errorColor: validName ? Colors.transparent : errorColor,
                      isNumber: false,
                    ),
                    MyInput(
                      controller: amountController,
                      text: "Max spending",
                      errorColor: validAmount ? Colors.transparent : errorColor,
                      isNumber: true,
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            width: 35.w,
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12)),
                              gradient: grad,
                            ),
                            child: TextButton(
                              onPressed: () async {
                                if (nameController.text.isNotEmpty &&
                                    amountController.text.isNotEmpty) {
                                  Budget budget = Budget(
                                      id: widget.budget.id,
                                      name: nameController.text,
                                      maxAmount:
                                          double.parse(amountController.text),
                                      isMonthly: 0,
                                      iconIndex: widget.budget.iconIndex,
                                      colorIndex: widget.budget.colorIndex);

                                  await insertBudget(budget);

                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.pushReplacement(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (_) => Body(
                                                indexOfPage: 1,
                                              )));
                                  nameController.clear();
                                  amountController.clear();
                                  setState(() {
                                    validName = true;
                                    validAmount = true;
                                  });
                                  updateBudget(budget);
                                } else {
                                  setState(() {
                                    if (nameController.text.isEmpty) {
                                      validName = false;
                                    }
                                    if (amountController.text.isEmpty) {
                                      validAmount = false;
                                    }
                                  });
                                }
                              },
                              child: setText(
                                  "Save", 10.sp, FontWeight.w600, Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
                .slideY(begin: -0.05, end: 0, duration: 400.ms, curve: curve)
                .fadeIn();
          },
        );
      },
    );
  }

  bool validName = true;
  // List<Budget> listOfBudgets = [];
  bool validAmount = true;
}
