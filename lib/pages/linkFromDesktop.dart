import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:sizer/sizer.dart';

import '../global.dart';

class LinkFromDesktop extends StatefulWidget {
  const LinkFromDesktop({super.key});

  @override
  State<LinkFromDesktop> createState() => _LinkFromDesktopState();
}

class _LinkFromDesktopState extends State<LinkFromDesktop> {
  @override
  Widget build(BuildContext context) {
    return Animate(
        child: Container(
            height: 90.h,
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
                            child: setText(
                                "Link with desktop",
                                15.sp,
                                FontWeight.w600,
                                colorOfText,
                                TextAlign.start,
                                true),
                          ),
                          // Container(
                          //     width: 14.w,
                          //     height: 14.w,
                          //     decoration: BoxDecoration(
                          //         // color: secondary,
                          //         border: Border.all(
                          //             color: colorOfText.withOpacity(0.2), width: 2),
                          //         borderRadius: BorderRadius.circular(18)),
                          //     child: IconButton(
                          //         onPressed: () {
                          //           Navigator.pop(context);
                          //         },
                          //         icon: Icon(
                          //           Icons.arrow_back_rounded,
                          //           color: colorOfText.withOpacity(0.8),
                          //           size: 8.w,
                          //         ))),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    setText("Link key", 15.sp, FontWeight.w600, colorOfText),
                    Container(
                        margin: EdgeInsets.only(bottom: 1.h),
                        width: 90.w,
                        child: setText(
                            (prefs.getString('linkKey') != null)
                                ? (prefs.getString('linkKey')!)
                                : "***-***-***",
                            14.sp,
                            FontWeight.bold,
                            (prefs.getString("lastUpload") == null)
                                ? colorOfText.withOpacity(0.5)
                                : colorOfText,
                            TextAlign.center,
                            (prefs.getString("lastUpload") != null))),
                    if (prefs.getString("lastUpload") != null)
                      SizedBox(
                          width: 85.w,
                          child: setText(
                              "Enter this key on your desktop app.",
                              10.sp,
                              FontWeight.w500,
                              colorOfText.withOpacity(0.5),
                              TextAlign.center,
                              true)),
                    SizedBox(
                      height: 2.h,
                    ),
                    if (prefs.getString("lastUpload") == null)
                      SizedBox(
                          width: 85.w,
                          child: setText(
                              "You haven't uploaded any data to the cloud yet. You need to upload first.",
                              10.sp,
                              FontWeight.w600,
                              errorColor.withOpacity(0.8),
                              TextAlign.center,
                              true)),
                  ]),
            ).slideY(begin: -0.06, end: 0, curve: curve, duration: 500.ms)));
  }
}
