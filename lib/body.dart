import 'package:budget_app_flutter/components/navBar.dart';
import 'package:budget_app_flutter/global.dart';
import 'package:budget_app_flutter/pages/budgets.dart';
import 'package:budget_app_flutter/pages/more.dart';
import 'package:budget_app_flutter/pages/stats.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sizer/sizer.dart';
import 'pages/home.dart';

class Body extends StatefulWidget {
  int indexOfPage;
  Body({super.key, required this.indexOfPage});

  @override
  State<Body> createState() => _Body();
}

class _Body extends State<Body> {
  // int indexOfPage = 0;
  bool showDialog = false;
  @override
  void initState() {
    super.initState();
  }

  void updateIndex(int index) {
    setState(() {
      widget.indexOfPage = index;
    });
  }

  void setShowDialog(bool show) {
    setState(() {
      showDialog = show;
    });
  }

  void changeMode() {
    if (bodyColor != const Color(0xff171717)) {
      setState(() {
        bodyColor = const Color(0xff171717);
        colorOfText = const Color.fromARGB(255, 224, 224, 224);
        secondary = const Color.fromARGB(255, 35, 38, 43);
      });
      prefs.setString('mode', 'dark');
    } else {
      setState(() {
        bodyColor = const Color(0xFFF5F5F5);
        colorOfText = const Color.fromARGB(255, 39, 55, 74);
        secondary = const Color.fromARGB(255, 238, 238, 238);
      });
      prefs.setString('mode', 'light');
    }
  }

  var pages = [];

  @override
  Widget build(BuildContext context) {
    // widget.indexOfPage = 2;
    pages = [
      const Home(),
      Budgets(
        onTap: updateIndex,
      ),
      Stats(),
      More(
        darkModeMethod: changeMode,
      ),
    ];
    return Scaffold(
      body: Container(
        height: 100.h,
        color: bodyColor,
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                    height: 95.h,
                    color: bodyColor,
                    child: pages[widget
                        .indexOfPage] // You might want to display different content based on indexOfPage
                    ),
              ],
            ),
            Positioned(
                bottom: 0,
                child: NavBar(
                  onTap: updateIndex,
                  index: widget.indexOfPage,
                )),
          ],
        ),
      ),
    );
  }
}
