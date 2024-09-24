import 'package:budget_app_flutter/body.dart';
import 'package:budget_app_flutter/custom_icons_icons.dart';
import 'package:budget_app_flutter/databaseMethods.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:uuid/uuid.dart';
import 'dart:math' as math;

import '../global.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPrefs();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(CupertinoPageRoute(
          builder: (_) => Sizer(builder: (context, orientation, screenType) {
                return Body(
                  indexOfPage: 0,
                );
              })));
    });
    openDB();
    getBudgetsFromDB();
  }

  void getPrefs() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs.getString('mode') == 'dark') {
      bodyColor = const Color(0xff171717);
      colorOfText = const Color.fromARGB(255, 224, 224, 224);
      secondary = const Color.fromARGB(255, 41, 44, 50);
    }

    if (prefs.getInt('indexOfCurrency') != null) {
      setState(() {
        indexOfCurrency = prefs.getInt('indexOfCurrency')!;
      });

      if (prefs.getString("linkKey") == null) {
        prefs.setString("linkKey", const Uuid().v4());
      }
    }

    setState(() {});
  }

  void getBudgetsFromDB() async {
    setState(() {
      listOfBudgets.clear();
    });
    listOfBudgets = await getBudgets();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: bodyColor,
      child: Animate(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Animate(
                  child: Transform.rotate(
                    angle: 135 * math.pi / 180,
                    child: Container(
                      width: 1.w,
                      height: 3.h,
                      color: primaryBlue,
                    ),
                  ),
                )
                    .slide(
                        delay: 1000.ms,
                        begin: const Offset(0, 0),
                        end: const Offset(-15, -2),
                        curve: curve,
                        duration: 1000.ms)
                    .fadeIn(delay: 1000.ms)
                    .fadeOut(delay: 1100.ms),
                Animate(
                  child: Positioned(
                    left: 11.w,
                    bottom: 10.h,
                    child: Transform.rotate(
                      angle: 0 * math.pi / 180,
                      child: Container(
                        width: 1.w,
                        height: 4.h,
                        color: primaryBlue,
                      ),
                    ),
                  ),
                )
                    .slide(
                        begin: const Offset(0, 0),
                        end: const Offset(0, -2),
                        curve: curve,
                        delay: 1000.ms,
                        duration: 1000.ms)
                    .fadeIn(delay: 1000.ms)
                    .fadeOut(delay: 1100.ms),
                Animate(
                  child: Positioned(
                    left: 23.w,
                    child: Transform.rotate(
                      angle: 45 * math.pi / 180,
                      child: Container(
                        width: 1.w,
                        height: 4.h,
                        color: primaryBlue,
                      ),
                    ),
                  ),
                )
                    .slide(
                        begin: const Offset(0, 0),
                        end: const Offset(15, -2),
                        curve: curve,
                        delay: 1000.ms,
                        duration: 1000.ms)
                    .fadeIn(delay: 1000.ms)
                    .fadeOut(delay: 1100.ms),
                Image.asset(
                  'assets/images/logo.png',
                  width: 25.w,
                ),
              ],
            ),
            setText("My Budget", 14.sp, FontWeight.w600, colorOfText)
          ],
        ),
      )
          .slideY(begin: -0.07, end: 0, curve: curve, duration: 900.ms)
          .fadeIn(duration: 900.ms),
    );
  }
}
