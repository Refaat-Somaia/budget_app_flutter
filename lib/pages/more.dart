import 'package:budget_app_flutter/custom_icons_icons.dart';
import 'package:budget_app_flutter/databaseMethods.dart';
import 'package:budget_app_flutter/pages/cloud.dart';
import 'package:budget_app_flutter/pages/linkApp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sizer/sizer.dart';

import '../global.dart';

class More extends StatefulWidget {
  final Function() darkModeMethod;
  const More({super.key, required this.darkModeMethod});

  @override
  State<More> createState() => _MoreState();
}

class _MoreState extends State<More> {
  @override
  void dispose() {
    // Add any cleanup if necessary
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Animate(
      child: Container(
        height: 90.h,
        color: bodyColor,
        child: SingleChildScrollView(
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
                    "Settings",
                    15.sp,
                    FontWeight.w600,
                    colorOfText,
                  ),
                ],
              ),
              SizedBox(
                height: 3.h,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        buttonOfMenu(primaryGreen, "Cloud", CustomIcons.cloud,
                            500.ms, 0),
                        buttonOfMenu(primaryBlue, "Dark mode", CustomIcons.dark,
                            600.ms, 1),
                        buttonOfMenu(primaryGreen, "Currency",
                            FontAwesomeIcons.dollarSign, 700.ms, 2),
                        SizedBox(
                          height: 3.h,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        buttonOfMenu(primaryBlue, "Link app",
                            Icons.qr_code_rounded, 800.ms, 3),
                        buttonOfMenu(
                            colorOfText, "Reset app", Icons.restore, 900.ms, 4),

                        // SizedBox(
                        //   height: 20.h,
                        // ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    )
        .fadeIn(duration: 500.ms, curve: curve)
        .slideY(begin: -0.06, end: 0, curve: curve, duration: 500.ms);
  }

  Widget buttonOfMenu(Color color, text, icon, duration, [index]) {
    return Animate(
      child: Container(
        margin: EdgeInsets.only(bottom: 2.h),
        width: 40.w,
        height: 27.h,
        decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(32)),
        child: TextButton(
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.zero,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32))),
          ),
          onPressed: () {
            switch (index) {
              case 0:
                Navigator.push(
                    context, CupertinoPageRoute(builder: (_) => const Cloud()));
                break;
              case 1:
                widget.darkModeMethod();
                break;
              case 2:
                _showIconPicker(context);
                break;
              case 3:
                Navigator.push(context,
                    CupertinoPageRoute(builder: (_) => const LinkApp()));
                break;
              case 4:
                showDeleteAlert();
                break;
              default:
                // Optional: Add code here to handle unexpected values of 'index' if necessary.
                break;
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 18.w,
                    color: color,
                  ),
                  icon == CustomIcons.cloud
                      ? SizedBox(width: 6.w)
                      : const SizedBox()
                ],
              ),
              setText(text, 12.sp, FontWeight.w600, colorOfText)
            ],
          ),
        ),
      ),
    )
        .slideY(begin: 1, end: 0, curve: curve, duration: duration)
        .fadeIn(duration: 500.ms);
  }

  void _showIconPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Animate(
          child: AlertDialog(
            backgroundColor: bodyColor,
            surfaceTintColor: bodyColor,
            title:
                setText("Select currency", 14.sp, FontWeight.w500, colorOfText),
            content: Container(
              width: double.maxFinite,
              height: 40.h,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                ),
                itemCount: currencies.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        indexOfCurrency = index;
                      });
                      prefs.setInt('indexOfCurrency', index);
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: Icon(currencies[index],
                        size: 7.w,
                        color: index == indexOfCurrency
                            ? primaryBlue
                            : colorOfText),
                  );
                },
              ),
            ),
          ),
        ).scale(
            begin: const Offset(1.1, 1.1),
            end: const Offset(1, 1),
            curve: curve,
            duration: 300.ms);
      },
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
                                        FontAwesomeIcons.triangleExclamation,
                                        size: 18.w,
                                        color: errorColor,
                                      ),
                                      SizedBox(
                                        height: 2.h,
                                      ),
                                      setText(
                                          "Reset the app to its default state?",
                                          11.sp,
                                          FontWeight.w600,
                                          colorOfText,
                                          TextAlign.center,
                                          true),
                                      setText(
                                          "(All of your data will be deleted)",
                                          9.sp,
                                          FontWeight.w600,
                                          colorOfText.withOpacity(0.7),
                                          TextAlign.center,
                                          true),
                                      SizedBox(
                                        height: 3.h,
                                      ),
                                      Container(
                                        width: 35.w,
                                        decoration: BoxDecoration(
                                            color: errorColor,
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        child: TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);

                                            resetDB();
                                            prefs.clear();
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
