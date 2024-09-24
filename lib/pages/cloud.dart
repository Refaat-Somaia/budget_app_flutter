import 'dart:async';

import 'package:budget_app_flutter/custom_icons_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_ping/dart_ping.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';

import '../global.dart';
import '../models/budget.dart';

class Cloud extends StatefulWidget {
  const Cloud({super.key});

  @override
  State<Cloud> createState() => _CloudState();
}

bool isLoading = false;
bool isSuccess = false;
bool isFail = false;

class _CloudState extends State<Cloud> with TickerProviderStateMixin {
  late AnimationController controller = AnimationController(
    duration: 500.ms,
    vsync: this,
  );
  Future<void> uploadData() async {
    if (listOfBudgets.isEmpty) {
      setState(() {
        textOfLoading = "Bro u have no budgets yet...";
        isLoading = true;
        isFail = true;
      });
      controller.forward();
      closeLoading("Checking your internet connection");
    } else {
      listOfBudgets.forEach((element) {
        saveBudget(element);
      });
    }
  }

  Future<void> saveBudget(Budget budget) async {
    setState(() {
      isLoading = true;
      textOfLoading = "Checking your internet connection";
    });
    final result = await Ping('google.com', count: 1).stream.first;

    // Get a reference to the Firestore collection "budgets"
    if (result.response != null && listOfBudgets.isNotEmpty) {
      setState(() {
        textOfLoading = "Uploading to Firestore...";
      });
      Timer(const Duration(seconds: 10), () {
        if (isLoading == true) {
          setState(() {
            textOfLoading = 'womp womp u live in syria use a vpn';
            isFail = true;
          });
          closeLoading("Checking your internet connection");
        }
      });

      CollectionReference budgets =
          FirebaseFirestore.instance.collection('budgets');

      try {
        // Add a new document to the collection with the Budget object
        await budgets.doc(budget.id).set({
          'name': budget.name,
          'maxAmount': budget.maxAmount,
          'isMonthly': budget.isMonthly,
          'iconIndex': budget.iconIndex,
          'colorIndex': budget.colorIndex,
          'userId': prefs.getString('linkKey')
        });

        prefs.setString("lastUpload", DateTime.now().toString().split(" ")[0]);

        setState(() {
          textOfLoading = 'Data was uploaded successfully!';
          isSuccess = true;
        });
      } catch (e) {
        setState(() {
          textOfLoading = 'Error while uploading data (${e})';
          isFail = true;
        });
      }
      closeLoading("Checking your internet connection");
    } else {
      setState(() {
        textOfLoading = "Please check your internet connection and try again";

        isFail = true;
      });

      closeLoading("Checking your internet connection");
    }
  }

  void closeLoading(String msg) {
    Timer(const Duration(seconds: 3), () {
      controller.reverse();
      Timer(const Duration(milliseconds: 800), () {
        setState(() {
          isLoading = false;
          textOfLoading = msg;
          isSuccess = false;
          isFail = false;
        });
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // isLoading = false;
    return Animate(
        child: Stack(
      children: [
        Container(
            height: 100.h,
            color: bodyColor,
            child: Animate(
              child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 5.h,
                      width: 100.w,
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
                                      color: colorOfText.withOpacity(0.2),
                                      width: 2),
                                  borderRadius: BorderRadius.circular(18)),
                              child: IconButton(
                                  style: OutlinedButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(16))),
                                  ),
                                  onPressed: () {
                                    // Navigator.of(context).pushAndRemoveUntil(
                                    //     CupertinoPageRoute(
                                    //         builder: (context) => Body(
                                    //               indexOfPage: 3,
                                    //             )),
                                    //     (Route<dynamic> route) => false);
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
                            child: setText("Cloud", 15.sp, FontWeight.w600,
                                colorOfText, TextAlign.start, true),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 12.h,
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 1.h),
                      width: 80.w,
                      child: Icon(
                        CustomIcons.cloud,
                        size: 40.w,
                        color: colorOfText,
                      ),
                    ),
                    SizedBox(
                        width: 85.w,
                        child: setText(
                            "Upload your current budgets and expneses data to the cloud so you can link this data with the desktop version of the app.",
                            10.sp,
                            FontWeight.w500,
                            colorOfText.withOpacity(0.6),
                            TextAlign.center,
                            true)),
                    SizedBox(
                      height: 2.h,
                    ),
                    SizedBox(
                        width: 85.w,
                        child: setText(
                          "Last upload: ${prefs.getString('lastUpload') ?? "Never"}",
                          11.sp,
                          FontWeight.w500,
                          colorOfText.withOpacity(1),
                          TextAlign.center,
                        )),
                    SizedBox(
                      height: 5.h,
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 2.h),
                      width: 50.w,
                      decoration: BoxDecoration(
                          gradient: grad,
                          borderRadius: BorderRadius.circular(12)),
                      child: TextButton(
                        onPressed: () {
                          // controller.reset();
                          controller.forward();
                          uploadData();
                        },
                        child: setText(
                            "Upload", 12.sp, FontWeight.bold, Colors.white),
                      ),
                    ),
                  ]),
            ).slideY(begin: -0.06, end: 0, curve: curve, duration: 500.ms)),
        if (isLoading)
          Animate(
            child: Container(
              height: 100.h,
              color: Colors.black.withOpacity(0.7),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 100.w),
                  isSuccess
                      ? Icon(
                          Icons.cloud_done_rounded,
                          size: 30.w,
                          color: primaryBlue,
                        )
                      : isFail
                          ? Icon(
                              Icons.cloud_off_rounded,
                              size: 30.w,
                              color: errorColor,
                            )
                          : LoadingAnimationWidget.threeArchedCircle(
                              color: primaryBlue,
                              size: 30.w,
                            ),
                  SizedBox(
                    height: 2.h,
                  ),
                  SizedBox(
                      width: 80.w,
                      child: setText(textOfLoading, 13.sp, FontWeight.w600,
                          Colors.white, TextAlign.center, true))
                ],
              ),
            ),
          )
              .animate(
                controller: controller,
              )
              .scale(
                  begin: const Offset(1.2, 1.2),
                  end: const Offset(1, 1),
                  curve: curve,
                  duration: 500.ms)
              .fadeIn(duration: 500.ms),
      ],
    ));
  }

  String textOfLoading = "Please wait...";
}
