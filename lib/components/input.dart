import 'package:budget_app_flutter/global.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class MyInput extends StatefulWidget {
  // const MyInput({super.key});
  final TextEditingController controller;
  final String text;
  final Color errorColor;
  final bool isNumber;
  const MyInput(
      {super.key,
      required this.controller,
      required this.text,
      required this.isNumber,
      required this.errorColor});

  @override
  State<MyInput> createState() => _MyInputState();
}

class _MyInputState extends State<MyInput> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: 2.h),
        width: 90.w,
        height: 7.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border(
            bottom: BorderSide(width: 4, color: widget.errorColor),
          ),
        ),
        child: PhysicalModel(
          borderRadius: BorderRadius.circular(12),
          color: const Color(0xFFF6F6F6),
          elevation: 0,
          child: TextFormField(
            textAlign: TextAlign.start,
            controller: widget.controller,
            style: TextStyle(
                fontFamily: 'poppins',
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
                color: colorOfText),
            maxLength: 35,
            keyboardType:
                widget.isNumber ? TextInputType.number : TextInputType.text,
            textAlignVertical: TextAlignVertical.center,
            // style:
            // controller: controller,
            decoration: InputDecoration(
              counterText: '',
              counterStyle: const TextStyle(fontSize: 0),
              labelText: widget.text,
              floatingLabelStyle: TextStyle(
                  fontFamily: 'poppins',
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                  color: colorOfText.withOpacity(0.9)),
              labelStyle: TextStyle(
                  fontFamily: 'poppins',
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                  color: colorOfText.withOpacity(0.5)),
              filled: true,
              fillColor: secondary,
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                      color: Color.fromARGB(0, 234, 19, 19), width: 2)),
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ));
  }
}
