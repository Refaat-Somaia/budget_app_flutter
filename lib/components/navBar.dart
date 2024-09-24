import 'package:budget_app_flutter/custom_icons_icons.dart';
import 'package:budget_app_flutter/global.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class NavBar extends StatefulWidget {
  final Function(int) onTap;
  int index;
  NavBar({super.key, required this.onTap, required this.index});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  // var index = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      // padding: EdgeInsets.only(top: 1.h),
      // height: 8.h,
      color: bodyColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: Column(children: [
              Row(
                children: [
                  Icon(
                    CustomIcons.home,
                    size: 7.w,
                    color: widget.index == 0
                        ? colorOfText
                        : colorOfText.withOpacity(0.3),
                  ),
                  SizedBox(
                    width: 1.5.w,
                  )
                ],
              ),
              setText(
                "Home",
                8.sp,
                FontWeight.w500,
                widget.index == 0 ? colorOfText : colorOfText.withOpacity(0.5),
              )
            ]),
            onPressed: () {
              setState(() {
                widget.index = 0;
              });
              widget.onTap(widget.index);
            },
          ),
          IconButton(
            icon: Column(children: [
              Row(
                children: [
                  Icon(
                    CustomIcons.menu,
                    size: 7.w,
                    color: widget.index == 1
                        ? colorOfText
                        : colorOfText.withOpacity(0.3),
                  ),
                  SizedBox(
                    width: 0.5.w,
                  ),
                ],
              ),
              setText(
                "Budgets",
                8.sp,
                FontWeight.w500,
                widget.index == 1 ? colorOfText : colorOfText.withOpacity(0.5),
              )
            ]),
            onPressed: () {
              setState(() {
                widget.index = 1;
              });
              widget.onTap(1);
            },
          ),
          IconButton(
            icon: Column(children: [
              Icon(
                CustomIcons.chart,
                size: 7.w,
                color: widget.index == 2
                    ? colorOfText
                    : colorOfText.withOpacity(0.3),
              ),
              setText(
                "Stats",
                8.sp,
                FontWeight.w500,
                widget.index == 2 ? colorOfText : colorOfText.withOpacity(0.5),
              )
            ]),
            onPressed: () {
              widget.onTap(2);
            },
          ),
          IconButton(
            icon: Column(children: [
              Icon(
                CustomIcons.gear,
                size: 7.w,
                color: widget.index == 3
                    ? colorOfText
                    : colorOfText.withOpacity(0.5),
              ),
              setText(
                "Settings",
                8.sp,
                FontWeight.w500,
                widget.index == 3 ? colorOfText : colorOfText.withOpacity(0.5),
              )
            ]),
            onPressed: () {
              setState(() {
                widget.index = 3;
              });
              widget.onTap(3);
            },
          ),
        ],
      ),
    );
  }
}
