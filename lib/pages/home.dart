import 'package:budget_app_flutter/components/budgetHome.dart';
import 'package:budget_app_flutter/components/chart.dart';
import 'package:budget_app_flutter/databaseMethods.dart';
import 'package:budget_app_flutter/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:sizer/sizer.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _Home();
}

class _Home extends State<Home> with TickerProviderStateMixin {
  late AnimationController controller = AnimationController(
    duration: 700.ms,
    vsync: this,
  );
  late AnimationController controllerChart = AnimationController(
    duration: 700.ms,
    vsync: this,
  );
  double weekly = 0;
  double monthly = 0;
  double yearly = 0;
  double amountCurrent = 0;

  void getStats() async {
    weekly = await getExpensesSumWeek(getCurrentWeekNumber());
    monthly = await getExpensesSumMonth(DateTime.now().month);
    yearly = await getExpensesSumYear(DateTime.now().year);
    if (mounted) {
      setState(() {
        amountCurrent = weekly;
        // controller.forward();
      });
    }
  }

  List<double> days = [];
  List<double> weeks = [];
  List<double> month = [];
  Map<String, double> vals = {};

  void fillChart() async {
    days.clear();

    for (int i = 1; i < 8; i++) {
      days.add(await getExpenseOfDay(i));
    }

    setState(() {
      activeChartIndex = 0;
      amountCurrent = weekly;
      vals.clear();

      vals['Mon'] = days[0];
      vals['Tue'] = days[1];
      vals['Wed'] = days[2];
      vals['Thu'] = days[3];
      vals['Fri'] = days[4];
      vals['Sat'] = days[5];
      vals['Sun'] = days[6];
    });
  }

  void fillChartMonth() async {
    weeks.clear();
    int startingWeek = DateTime.now().month * 4;
    int endingWeek = startingWeek + 4;
    for (int i = startingWeek; i < endingWeek; i++) {
      weeks.add(await getExpensesSumWeek(i));
    }

    setState(() {
      activeChartIndex = 1;
      amountCurrent = monthly;
      vals.clear();
      vals["week 1"] = weeks[0];
      vals["week 2"] = weeks[1];
      vals["week 3"] = weeks[2];
      vals["week 4"] = weeks[3];
    });
    controllerChart.forward();
    controllerChart.reverse();
  }

  void fillChartYear() async {
    month.clear();

    for (int i = 1; i <= DateTime.now().month; i++) {
      month.add(await getExpensesSumMonth(i));
    }
    print(month);
    setState(() {
      activeChartIndex = 2;
      amountCurrent = yearly;
      vals.clear();
    });
    for (int i = 0; i < month.length; i++) {
      if (month[i] != 0) vals["${i + 1}"] = month[i];
    }
    setState(() {});
    controllerChart.forward();
    controllerChart.reverse();
  }

  @override
  void initState() {
    super.initState();
    openDB();
    getBudgetsFromDB();
    getStats();
  }

  void getBudgetsFromDB() async {
    if (mounted) {
      setState(() {
        listOfBudgets.clear();
      });
    }
    listOfBudgets = await getBudgets();
    // Update UI if the widget is still mounted
    if (mounted) {
      setState(() {});
    }
    fillChart();
  }

  @override
  void dispose() {
    // Add any cleanup if necessary
    controller.dispose();
    controllerChart.dispose();
    super.dispose();
  }

  String welcomeText = DateTime.now().hour <= 12
      ? "Good morning"
      : (DateTime.now().hour < 17)
          ? "Good afternoon "
          : "Good Evening";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bodyColor,
        body: Animate(
          child: Container(
            height: 95.h,
            color: bodyColor,
            child: SingleChildScrollView(
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 30.h,
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF6AD0C1),
                            Color.fromARGB(255, 34, 190, 228),
                          ],
                          begin: FractionalOffset(0.0, 0.0),
                          end: FractionalOffset(1.0, 0.0),
                          stops: [0.0, 1.0],
                          tileMode: TileMode.clamp,
                        ),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(50),
                            bottomRight: Radius.circular(50))),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 5.h,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 5.w,
                            ),
                            setText(welcomeText, 15.sp, FontWeight.bold,
                                Colors.white)
                          ],
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            PeriodButton("Weekly", 0),
                            PeriodButton("Monthly", 1),
                            PeriodButton("Yearly", 2),
                          ],
                        ),
                        SizedBox(
                          height: 3.h,
                        ),
                        Animate(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              setText(formatNumberWithCommas(amountCurrent),
                                  18.sp, FontWeight.bold, Colors.white),
                              Icon(
                                currencies[indexOfCurrency],
                                color: Colors.white,
                                size: 20.sp,
                              )
                            ],
                          ),
                        )
                            .animate(controller: controller)
                            // .fadeIn(curve: curve, duration: 800.ms)
                            .fade()
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Animate(
                      child: Chart(
                    amountMax: amountCurrent,
                    values: vals,
                    height: 33,
                  )).animate(controller: controller).fade(),
                  if (listOfBudgets.isNotEmpty)
                    for (int i = 0; i < listOfBudgets.length; i++)
                      BudgetHome(
                        budget: listOfBudgets[i],
                        color: colors[listOfBudgets[i].colorIndex],
                        icon: icons[listOfBudgets[i].iconIndex],
                        // onLong: delte,
                        onPress: (String) {},
                      ),
                  SizedBox(
                    height: 5.h,
                  )
                ],
              ),
            ),
          ),
        )
            .fadeIn(
              duration: 500.ms,
            )
            .slideY(begin: -0.06, end: 0, curve: curve, duration: 500.ms));
  }

  // ignore: non_constant_identifier_names

  Widget PeriodButton(String text, [index]) {
    return TextButton(
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
            borderRadius: index == 0
                ? const BorderRadius.only(
                    topLeft: Radius.circular(32),
                    bottomLeft: Radius.circular(32))
                : index == 2
                    ? const BorderRadius.only(
                        topRight: Radius.circular(32),
                        bottomRight: Radius.circular(32))
                    : BorderRadius.circular(0)),
      ),
      onPressed: () {
        if (index == 0) {
          fillChart();
        } else if (index == 1) {
          fillChartMonth();
        } else {
          fillChartYear();
          // setState(() {
          //   activeChartIndex = 2;
          //   amountCurrent = monthly;
          // });
          // controller.reset();
          // controller.forward();
        }
        controller.reset();
        controller.forward();
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: activeChartIndex == index
                ? bodyColor
                : bodyColor.withOpacity(0.5),
            borderRadius: index == 0
                ? const BorderRadius.only(
                    topLeft: Radius.circular(32),
                    bottomLeft: Radius.circular(32))
                : index == 2
                    ? const BorderRadius.only(
                        topRight: Radius.circular(32),
                        bottomRight: Radius.circular(32))
                    : BorderRadius.circular(0)),
        child:
            setText(text, 8.sp, FontWeight.w600, colorOfText.withOpacity(0.8)),
      ),
    );
  }
}
