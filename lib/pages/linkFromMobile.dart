import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:sizer/sizer.dart';

import '../global.dart';

class LinkFromMobile extends StatefulWidget {
  const LinkFromMobile({super.key});

  @override
  State<LinkFromMobile> createState() => _LinkFromMobileState();
}

class _LinkFromMobileState extends State<LinkFromMobile> {
  final GlobalKey qrKey = GlobalKey();
  QRViewController? controller;
  String qrText = "";

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrText = scanData.code!;
      });
      // Optionally, you can navigate to another page or use the scanned data here
      // Navigator.pop(context, qrText); // For example, to return the scanned text
    });
  }

  void _startScan() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Animate(
          child: AlertDialog(
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            content: Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(32)),
              height: 60.h,
              width: 100.w,
              child: QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
              ),
            ),
            actions: <Widget>[],
          ),
        )
            .scale(
                begin: const Offset(1.2, 1.2),
                end: const Offset(1, 1),
                curve: curve,
                duration: 500.ms)
            .fadeIn(duration: 500.ms);
      },
    );
  }

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
                        Icons.qr_code_scanner_rounded,
                        size: 55.w,
                        color: colorOfText,
                      ),
                    ),
                    SizedBox(
                        width: 85.w,
                        child: setText(
                            "Click on the 'Link app' on your desktop app to scan the QR code and transfer the data to this app.",
                            10.sp,
                            FontWeight.w500,
                            colorOfText.withOpacity(0.5),
                            TextAlign.center,
                            true)),
                    SizedBox(
                      height: 5.h,
                    ),
                    Container(
                      width: 50.w,
                      decoration: BoxDecoration(
                          gradient: grad,
                          borderRadius: BorderRadius.circular(12)),
                      child: TextButton(
                        onPressed: _startScan, // Call the scan method
                        child: setText(
                            "Scan", 12.sp, FontWeight.bold, Colors.white),
                      ),
                    ),
                  ]),
            ).slideY(begin: -0.06, end: 0, curve: curve, duration: 500.ms)));
  }
}
