import 'package:budget_app_flutter/body.dart';
import 'package:budget_app_flutter/global.dart';
import 'package:budget_app_flutter/screens/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.black,
  ));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Image.asset('assets/images/logo.png');
    return Sizer(builder: (context, orientation, screenType) {
      return SafeArea(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          color: bodyColor,
          home: const Splash(),
          // home:SplashScreen(),
        ),
      );
    });
  }
}
