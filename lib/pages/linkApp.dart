import 'package:budget_app_flutter/global.dart';
import 'package:budget_app_flutter/pages/linkFromDesktop.dart';
import 'package:budget_app_flutter/pages/linkFromMobile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sizer/sizer.dart';

class LinkApp extends StatefulWidget {
  const LinkApp({super.key});

  @override
  State<LinkApp> createState() => _LinkAppState();
}

class _LinkAppState extends State<LinkApp> {
  @override
  Widget build(BuildContext context) {
    return Animate(
      child: Container(
        height: 90.h,
        color: bodyColor,
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
                    child: setText("Link app", 15.sp, FontWeight.w600,
                        colorOfText, TextAlign.start, true),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 15.h,
            ),
            Animate(
              child: Container(
                width: 85.w,
                height: 22.h,
                // padding: EdgeInsets.symmetric(horizontal: 2.w),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    color: primaryBlue.withOpacity(0.1)),
                child: TextButton(
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 2.w),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(32))),
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        CupertinoPageRoute(builder: (_) => LinkFromMobile()));
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            FontAwesomeIcons.mobile,
                            size: 10.w,
                            color: primaryBlue,
                          ),
                          Icon(
                            Icons.arrow_back_rounded,
                            size: 10.w,
                            color: primaryBlue,
                          ),
                          Icon(
                            FontAwesomeIcons.laptop,
                            size: 10.w,
                            color: primaryBlue,
                          ),
                          // SizedBox(
                          //   width: 0.1.w,
                          // )
                        ],
                      ),
                      SizedBox(
                        height: 3.h,
                      ),
                      SizedBox(
                        width: 75.w,
                        child: setText(
                            "Transfer data from desktop to mobile",
                            11.sp,
                            FontWeight.w500,
                            colorOfText.withOpacity(0.9),
                            TextAlign.center,
                            true),
                      )
                    ],
                  ),
                ),
              ),
            ).slideY(begin: 1, end: 0, curve: curve, duration: 500.ms),
            SizedBox(
              height: 3.h,
            ),
            Animate(
              child: Container(
                width: 85.w,
                height: 22.h,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    color: primaryGreen.withOpacity(0.1)),
                child: TextButton(
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 2.w),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(32))),
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        CupertinoPageRoute(builder: (_) => LinkFromDesktop()));
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            FontAwesomeIcons.laptop,
                            size: 10.w,
                            color: primaryGreen,
                          ),

                          Icon(
                            Icons.arrow_back_rounded,
                            size: 10.w,
                            color: primaryGreen,
                          ),
                          Icon(
                            FontAwesomeIcons.mobile,
                            size: 10.w,
                            color: primaryGreen,
                          ),
                          // SizedBox(
                          //   width: 0.1.w,
                          // )
                        ],
                      ),
                      SizedBox(
                        height: 3.h,
                      ),
                      SizedBox(
                        width: 75.w,
                        child: setText(
                            "Transfer data from mobile to desktop",
                            11.sp,
                            FontWeight.w500,
                            colorOfText.withOpacity(0.9),
                            TextAlign.center,
                            true),
                      )
                    ],
                  ),
                ),
              ),
            ).slideY(begin: 1, end: 0, curve: curve, duration: 700.ms),
          ],
        ),
      ),
    );
  }
}
