import 'package:budget_app_flutter/custom_icons_icons.dart';
import 'package:budget_app_flutter/models/budget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

var bodyColor = const Color(0xFFF5F5F5);
Color colorOfText = const Color.fromARGB(255, 39, 55, 74);
Color secondary = const Color.fromARGB(255, 238, 238, 238);
const curve = Curves.ease;
late SharedPreferences prefs;
bool animateHome = true;
// DatabaseReference fireBaseRef = FirebaseDatabase.instance.ref("budgets");
const colors = [
  Color.fromARGB(255, 166, 205, 255),
  Color.fromARGB(255, 253, 224, 157),
  Color.fromARGB(255, 140, 238, 221),
  Color.fromARGB(255, 152, 219, 255),
  Color.fromARGB(255, 255, 190, 213),
  Color.fromARGB(255, 255, 220, 190),
  Color.fromARGB(255, 180, 180, 180),
];

Color primaryBlue = const Color.fromARGB(255, 34, 190, 228);
Color primaryGreen = const Color.fromARGB(255, 85, 202, 194);
Color errorColor = const Color(0xffE43F5A);
var database;
bool isArabic = false;
int indexOfCurrency = 0;
int activeChartIndex = 0;

List<Budget> listOfBudgets = [];

var grad = LinearGradient(
  colors: [
    primaryGreen,
    primaryBlue,
  ],
  begin: const FractionalOffset(0.0, 0.0),
  end: const FractionalOffset(1.0, 0.0),
  stops: const [0.0, 1.0],
  tileMode: TileMode.clamp,
);

List<IconData> icons = [
  FontAwesomeIcons.xmark, // Wallet
  FontAwesomeIcons.house, // Wallet
  FontAwesomeIcons.user, // Wallet
  FontAwesomeIcons.car, // Wallet
  FontAwesomeIcons.mobile, // Wallet
  FontAwesomeIcons.laptop, // Wallet
  FontAwesomeIcons.wallet, // Wallet
  FontAwesomeIcons.briefcase, // Wallet
  FontAwesomeIcons.coins, // Coins
  FontAwesomeIcons.moneyBillWave, // Money Bill
  FontAwesomeIcons.receipt, // Receipt
  FontAwesomeIcons.tag, // Tag
  FontAwesomeIcons.chartPie, // Pie Chart (budget visualization)

  // Cupertino Icons
  CupertinoIcons.creditcard, // Credit Card
  CupertinoIcons.cart, // Cart
  CupertinoIcons.bolt, // Investments (indicates energy or financial growth)

  // Flutter Built-in Icons
  Icons.account_balance, // Account Balance
  Icons.family_restroom_rounded, // Account Balance
  Icons.attach_money, // Attach Money
  Icons.receipt_long, // Long Receipt
  Icons.shopping_basket, // Shopping Basket
  Icons.trending_up, // Trending Up (financial growth)
  Icons.savings, // Savings (for saving icons)
];

List<IconData> currencies = [
  // FontAwesome Currency Icons
  FontAwesomeIcons.dollarSign, // US Dollar
  CustomIcons.syp,
  FontAwesomeIcons.euroSign, // Euro
  FontAwesomeIcons.sterlingSign, // British Pound
  FontAwesomeIcons.rupeeSign, // Indian Rupee
  FontAwesomeIcons.wonSign, // South Korean Won
  FontAwesomeIcons.rubleSign, // Russian Ruble
  FontAwesomeIcons.yenSign, // Chinese Yuan
  FontAwesomeIcons.bitcoin, // Bitcoin
  FontAwesomeIcons.ethereum, // Ethereum
  FontAwesomeIcons.liraSign, // Turkish Lira
  FontAwesomeIcons.kipSign, // Laotian Kip

  // Cupertino Currency Icons (limited set)
];

Text setText(String text, double size, FontWeight weight, Color color,
    [dircetion, wrap]) {
  return Text(
    text,
    softWrap: true,
    textAlign: dircetion ?? TextAlign.center,
    style: TextStyle(
        fontSize: size,
        fontWeight: weight,
        color: color,
        decoration: TextDecoration.none,
        overflow: wrap == true ? null : TextOverflow.ellipsis,
        fontFamily: "poppins"),
  );
}
// Map<String,String> englishMap={
//   "gm":"Good morning",
//   "ge":"Good evening",
//   "gn":"Good morning",

// };

String formatNumberWithCommas(double number) {
  // Using NumberFormat to format the number
  final NumberFormat formatter = NumberFormat('#,###');
  return formatter.format(number);
}
