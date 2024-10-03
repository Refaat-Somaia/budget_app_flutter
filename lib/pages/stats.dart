import 'package:budget_app_flutter/components/chart.dart';
import 'package:budget_app_flutter/databaseMethods.dart';
import 'package:budget_app_flutter/pages/history.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:sizer/sizer.dart';

import '../global.dart';

class Stats extends StatefulWidget {
  const Stats({super.key});

  @override
  State<Stats> createState() => _StatsState();
}

class _StatsState extends State<Stats> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getStats();
  }

  @override
  void dispose() {
    // Add any cleanup if necessary
    super.dispose();
  }

  double total = 0;
  double weekly = 0;
  double monthly = 0;
  double yearly = 0;
  double thisWeek = 0;
  double thisMonth = 0;
  Map<String, double> weekValues = {};
  Map<String, double> monthValues = {};
  Map<String, double> yearValues = {};
  List<double> weeks = [];
  List<double> days = [];
  List<double> months = [];
  int budgetsCount = 0;
  int expensesCount = 0;
  int overBudgetsCount = 0;
  void getStats() async {
    total = await getExpensesTotal();
    weekly = await getExpensesSumWeek(getCurrentWeekNumber());
    monthly = await getExpensesSumMonth(DateTime.now().month);
    yearly = await getExpensesSumYear(DateTime.now().year);
    budgetsCount = await getBudgetsCount();
    expensesCount = await getExpensesCount();
    // overBudgetsCount = await getOverBudgetsCount();

    setState(() {
      conts.clear();
    });
    conts.add(Container(
      padding: const EdgeInsets.all(12),
      width: 90.w,
      height: 42.h,
      decoration: BoxDecoration(
          color: secondary, borderRadius: BorderRadius.circular(32)),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        setText(
            "This week", 10.sp, FontWeight.w600, colorOfText.withOpacity(0.7)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            setText(formatNumberWithCommas(weekly), 12.sp, FontWeight.w600,
                colorOfText),
            Icon(
              currencies[indexOfCurrency],
              color: colorOfText,
              size: 14.sp,
            )
          ],
        ),
        SizedBox(
          height: 1.h,
        ),
        Chart(
          values: weekValues,
          amountMax: weekly,
          height: 28,
        )
      ]),
    ));

    conts.add(Container(
      width: 90.w,
      height: 42.h,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: secondary, borderRadius: BorderRadius.circular(32)),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        setText(
            "This month", 10.sp, FontWeight.w600, colorOfText.withOpacity(0.7)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            setText(formatNumberWithCommas(monthly), 12.sp, FontWeight.w600,
                colorOfText),
            Icon(
              currencies[indexOfCurrency],
              color: colorOfText,
              size: 14.sp,
            )
          ],
        ),
        SizedBox(
          height: 1.h,
        ),
        Chart(values: monthValues, amountMax: monthly, height: 28)
      ]),
    ));

    conts.add(Container(
      width: 90.w,
      height: 42.h,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: secondary, borderRadius: BorderRadius.circular(32)),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        setText(
            "This year", 10.sp, FontWeight.w600, colorOfText.withOpacity(0.7)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            setText(formatNumberWithCommas(yearly), 12.sp, FontWeight.w600,
                colorOfText),
            Icon(
              currencies[indexOfCurrency],
              color: colorOfText,
              size: 14.sp,
            )
          ],
        ),
        SizedBox(
          height: 1.h,
        ),
        Chart(values: yearValues, amountMax: yearly, height: 28)
      ]),
    ));

    weeks.clear();
    days.clear();
    months.clear();

    for (int i = 1; i < 8; i++) {
      days.add(await getExpenseOfDay(i));
    }

    int startingWeek = DateTime.now().month * 4;
    int endingWeek = startingWeek + 4;
    for (int i = startingWeek; i < endingWeek; i++) {
      weeks.add(await getExpensesSumWeek(i));
    }

    for (int i = 1; i <= DateTime.now().month; i++) {
      months.add(await getExpensesSumMonth(i));
    }

    yearValues.clear();
    for (int i = 0; i < months.length; i++) {
      if (months[i] != 0) yearValues["${i + 1}"] = months[i];
    }
    // print(weeks);

    setState(() {
      monthValues.clear();
      monthValues["week 1"] = weeks[0];
      monthValues["week 2"] = weeks[1];
      monthValues["week 3"] = weeks[2];
      monthValues["week 4"] = weeks[3];

      weekValues.clear();

      weekValues['Mon'] = days[0];
      weekValues['Tue'] = days[1];
      weekValues['Wed'] = days[2];
      weekValues['Thu'] = days[3];
      weekValues['Fri'] = days[4];
      weekValues['Sat'] = days[5];
      weekValues['Sun'] = days[6];
    });
  }

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
              width: 100.w,
            ),
            Row(
              children: [
                SizedBox(
                  width: 10.w,
                ),
                setText(
                  "Stats",
                  14.sp,
                  FontWeight.w600,
                  colorOfText,
                ),
              ],
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
                      Container(
                        width: 85.w,
                        height: 18.h,
                        margin: EdgeInsets.only(bottom: 3.h),
                        decoration: BoxDecoration(
                            color: secondary,
                            borderRadius: BorderRadius.circular(32)),
                        child: Center(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                setText(
                                    "Total spending: ",
                                    11.sp,
                                    FontWeight.w500,
                                    colorOfText.withOpacity(0.7)),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    setText(formatNumberWithCommas(total),
                                        14.sp, FontWeight.w600, colorOfText),
                                    Icon(
                                      currencies[indexOfCurrency],
                                      color: colorOfText,
                                      size: 14.sp,
                                    )
                                  ],
                                ),
                              ]),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 42.h,
                        child: Swiper(
                          viewportFraction: 0.85,
                          scale: 0.9,
                          itemBuilder: (context, index) {
                            return conts[index];
                          },
                          indicatorLayout: PageIndicatorLayout.COLOR,
                          autoplay: true,
                          autoplayDelay: 5000,
                          fade: 0.8,
                          itemCount: conts.length,
                        ),
                      ),
                      SizedBox(
                        height: 3.h,
                      ),
                      SizedBox(
                        width: 90.w,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(32),
                                  color: secondary),
                              child: Column(
                                children: [
                                  Container(
                                    width: 40.w,

                                    // height: 15.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(32),
                                    ),
                                    child: Center(
                                      child: Container(
                                        decoration: const BoxDecoration(
                                            shape: BoxShape.circle),
                                        width: 40.w,
                                        height: 15.h,
                                        child: CircularPercentIndicator(
                                          radius: 13.w,
                                          lineWidth: 3,
                                          percent: monthly > 0
                                              ? (weekly / monthly)
                                              : 0,
                                          center: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              setText(
                                                  "${monthly > 0 ? (weekly / monthly * 100).toStringAsFixed(0) : 0}%",
                                                  10.sp,
                                                  FontWeight.bold,
                                                  colorOfText),
                                              SizedBox(
                                                width: 18.w,
                                                child: setText(
                                                    "Of the month's total",
                                                    5.sp,
                                                    FontWeight.w600,
                                                    colorOfText
                                                        .withOpacity(0.5),
                                                    TextAlign.center,
                                                    true),
                                              ),
                                            ],
                                          ),
                                          backgroundColor: Colors.grey,
                                          progressColor: primaryBlue,
                                        ),
                                      ),
                                    ),
                                  ),
                                  setText("Weekly rate", 9.sp, FontWeight.w600,
                                      colorOfText.withOpacity(0.7)),
                                  SizedBox(
                                    height: 2.h,
                                  )
                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(32),
                                  color: secondary),
                              child: Column(
                                children: [
                                  Container(
                                    width: 40.w,
                                    // height: 15.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(32),
                                    ),
                                    child: Center(
                                      child: Container(
                                        decoration: const BoxDecoration(
                                            shape: BoxShape.circle),
                                        width: 40.w,
                                        height: 15.h,
                                        child: CircularPercentIndicator(
                                          radius: 13.w,
                                          lineWidth: 3,
                                          percent: yearly > 0
                                              ? (monthly / yearly)
                                              : 0,
                                          center: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              setText(
                                                  "${yearly > 0 ? (monthly / yearly * 100).toStringAsFixed(0) : 0}%",
                                                  10.sp,
                                                  FontWeight.bold,
                                                  colorOfText),
                                              SizedBox(
                                                width: 18.w,
                                                child: setText(
                                                    "Of the year's total",
                                                    5.sp,
                                                    FontWeight.w600,
                                                    colorOfText
                                                        .withOpacity(0.5),
                                                    TextAlign.center,
                                                    true),
                                              ),
                                            ],
                                          ),
                                          backgroundColor: Colors.grey,
                                          progressColor: primaryBlue,
                                        ),
                                      ),
                                    ),
                                  ),
                                  setText("Monthly rate", 9.sp, FontWeight.w600,
                                      colorOfText.withOpacity(0.7)),
                                  SizedBox(
                                    height: 2.h,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 3.h,
                      ),
                      SizedBox(
                        width: 90.w,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(32),
                                  color: secondary),
                              child: Column(
                                children: [
                                  Container(
                                    width: 40.w,

                                    // height: 15.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(32),
                                    ),
                                    child: Center(
                                      child: Container(
                                        decoration: const BoxDecoration(
                                            shape: BoxShape.circle),
                                        width: 40.w,
                                        height: 15.h,
                                        child: CircularPercentIndicator(
                                          radius: 13.w,
                                          lineWidth: 3,
                                          percent: 1,
                                          center: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              setText("$budgetsCount", 10.sp,
                                                  FontWeight.bold, colorOfText),
                                            ],
                                          ),
                                          backgroundColor: Colors.grey,
                                          progressColor: primaryBlue,
                                        ),
                                      ),
                                    ),
                                  ),
                                  setText(
                                      "Total budgets",
                                      9.sp,
                                      FontWeight.w600,
                                      colorOfText.withOpacity(0.7)),
                                  SizedBox(
                                    height: 2.h,
                                  )
                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(32),
                                  color: secondary),
                              child: Column(
                                children: [
                                  Container(
                                    width: 40.w,
                                    // height: 15.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(32),
                                    ),
                                    child: Center(
                                      child: Container(
                                        decoration: const BoxDecoration(
                                            shape: BoxShape.circle),
                                        width: 40.w,
                                        height: 15.h,
                                        child: CircularPercentIndicator(
                                          radius: 13.w,
                                          lineWidth: 3,
                                          percent: 1,
                                          center: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              setText("$expensesCount", 10.sp,
                                                  FontWeight.bold, colorOfText),
                                            ],
                                          ),
                                          backgroundColor: Colors.grey,
                                          progressColor: primaryBlue,
                                        ),
                                      ),
                                    ),
                                  ),
                                  setText(
                                      "Total expenses",
                                      9.sp,
                                      FontWeight.w600,
                                      colorOfText.withOpacity(0.7)),
                                  SizedBox(
                                    height: 2.h,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 85.w,
                        height: 10.h,
                        margin: EdgeInsets.only(top: 3.h),
                        decoration: BoxDecoration(
                            // color: secondary,
                            border: Border.all(
                                color: colorOfText.withOpacity(0.2), width: 2),
                            borderRadius: BorderRadius.circular(32)),
                        child: Center(
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (_) => History()));
                            },
                            style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(32)))),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  setText("History", 12.sp, FontWeight.w500,
                                      colorOfText),
                                  SizedBox(
                                    width: 3.w,
                                  ),
                                  Icon(
                                    FontAwesomeIcons.clockRotateLeft,
                                    color: colorOfText,
                                    size: 18.sp,
                                  ),
                                ]),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 8.h,
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
        .fadeIn(duration: 500.ms, curve: curve)
        .slideY(begin: -0.06, end: 0, curve: curve, duration: 500.ms);
  }

  List<Widget> conts = [];
}
