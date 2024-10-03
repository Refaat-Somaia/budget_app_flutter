import 'package:budget_app_flutter/global.dart';
import 'package:budget_app_flutter/models/expense.dart';
import 'package:budget_app_flutter/pages/expenses.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import 'models/budget.dart';

void openDB() async {
  // Define the SQL statements for creating the tables.
  String createBudgetsTable = """
    CREATE TABLE budgets (
      id TEXT PRIMARY KEY,
      name TEXT,
      maxAmount REAL,
      isMonthly NUMBER,
      iconIndex NUMBER,
      colorIndex NUMBER
    );
  """;

  String createExpensesTable = """
    CREATE TABLE expenses (
      id TEXT PRIMARY KEY,
      name TEXT,
      budgetId TEXT,
      amount REAL,
      month NUMBER,
      year NUMBER,
      week NUMBER,
      day NUMBER
    );
  """;

  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Open the database
  database = await openDatabase(
    join(await getDatabasesPath(), 'budget_app.db'),
    onCreate: (db, version) async {
      // Execute each create table statement separately
      await db.execute(createBudgetsTable);
      await db.execute(createExpensesTable);
    },
    version: 1,
  );

  // Optionally, get data from the database here
  // getBudgetsFromDB();
}

Future<void> updateExpense(Expense expense) async {
  // Get a reference to the database.
  final db = await database;

  // Update the given Dog.
  await db.update(
    'expenses',
    expense.toMap(),
    // Ensure that the Dog has a matching id.
    where: 'id = ?',
    // Pass the Dog's id as a whereArg to prevent SQL injection.
    whereArgs: [expense.id],
  );
}

Future<void> updateBudget(Budget budget) async {
  // Get a reference to the database.
  final db = await database;

  // Update the given Dog.
  await db.update(
    'budgets',
    budget.toMap(),
    // Ensure that the Dog has a matching id.
    where: 'id = ?',
    // Pass the Dog's id as a whereArg to prevent SQL injection.
    whereArgs: [budget.id],
  );
}

Future<List<Budget>> getBudgets() async {
  // Get a reference to the database.
  final db = await database;

  // Query the table for all the dogs.
  final List<Map<String, Object?>> budgetsMap = await db.query('budgets');

  // Convert the list of each dog's fields into a list of `Dog` objects.
  return [
    for (final {
          'id': id as String,
          'name': name as String,
          'maxAmount': maxAmount as double,
          'isMonthly': isMonthly as int,
          'iconIndex': iconIndex as int,
          'colorIndex': colorIndex as int,
        } in budgetsMap)
      Budget(
          id: id,
          name: name,
          maxAmount: maxAmount,
          isMonthly: isMonthly,
          iconIndex: iconIndex,
          colorIndex: colorIndex),
  ];
}

Future<Budget> getBudgetUsingId(String budgetId) async {
  final db = await database;
  final List<Map<String, Object?>> budgetsMap = await db.query(
    'budgets',
    where: 'id = ?',
    whereArgs: [budgetId],
  );
  var list = [
    for (final {
          'id': id as String,
          'name': name as String,
          'maxAmount': maxAmount as double,
          'isMonthly': isMonthly as int,
          'iconIndex': iconIndex as int,
          'colorIndex': colorIndex as int,
        } in budgetsMap)
      Budget(
          id: id,
          name: name,
          maxAmount: maxAmount,
          isMonthly: isMonthly,
          iconIndex: iconIndex,
          colorIndex: colorIndex),
  ];
  return list[0];
}

Future<List<Expense>> getAllExpenses() async {
  // Get a reference to the database.
  final db = await database;

  // Query the table for all the dogs.
  final List<Map<String, Object?>> expenseMap = await db.query('expenses');

  // Convert the list of each dog's fields into a list of `Dog` objects.
  return [
    for (final {
          'id': id as String,
          'name': name as String,
          'amount': amount as double,
          'budgetId': budgetId as String,
          'month': month as int,
          'year': year as int,
          'day': day as int,
          'week': week as int,
        } in expenseMap)
      Expense(
          id: id,
          name: name,
          week: week,
          amount: amount,
          month: month,
          budgetId: budgetId,
          year: year,
          day: day),
  ];
}

Future<int> getBudgetsCount() async {
  // Get a reference to the database.
  final db = await database;

  // Query the table for all the dogs.
  final List<Map<String, Object?>> budgetsMap = await db.query('budgets');

  // Convert the list of each dog's fields into a list of `Dog` objects.
  List<Budget> list = [
    for (final {
          'id': id as String,
          'name': name as String,
          'maxAmount': maxAmount as double,
          'isMonthly': isMonthly as int,
          'iconIndex': iconIndex as int,
          'colorIndex': colorIndex as int,
        } in budgetsMap)
      Budget(
          id: id,
          name: name,
          maxAmount: maxAmount,
          isMonthly: isMonthly,
          iconIndex: iconIndex,
          colorIndex: colorIndex),
  ];
  int x = 0;
  list.forEach((element) {
    x++;
  });
  return x;
}

Future<List<Expense>> getExpensesBudget(String idOfBudget) async {
  // Get a reference to the database.
  final db = await database;

  // Query the table for expenses that match the given budgetId.
  final List<Map<String, Object?>> expensesMap = await db.query(
    'expenses',
    where: 'budgetId = ?',
    whereArgs: [idOfBudget],
  );

  // Convert the list of each expense's fields into a list of `Expense` objects.
  return [
    for (final {
          'id': id as String,
          'name': name as String,
          'amount': amount as double,
          'budgetId': budgetId as String,
          'month': month as int,
          'year': year as int,
          'day': day as int,
          'week': week as int,
        } in expensesMap)
      Expense(
          id: id,
          name: name,
          week: week,
          amount: amount,
          month: month,
          budgetId: budgetId,
          year: year,
          day: day),
  ];
}

String getCurrentDay() {
  // Get the current date and time
  DateTime now = DateTime.now();

  // Define a list of the days of the week
  List<String> daysOfWeek = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];

  // Get the current day of the week as an integer (0 for Sunday, 6 for Saturday)
  int currentDayIndex =
      now.weekday; // 1 for Monday, 2 for Tuesday, ..., 7 for Sunday

  // Convert to a 0-based index by subtracting 1
  int zeroBasedIndex = (currentDayIndex % 7);

  // Return the corresponding day name
  return daysOfWeek[zeroBasedIndex];
}

Future<int> getExpensesCount() async {
  // Get a reference to the database.
  final db = await database;

  // Query the table for expenses that match the given budgetId.
  final List<Map<String, Object?>> expensesMap = await db.query(
    'expenses',
  );

  // Convert the list of each expense's fields into a list of `Expense` objects.
  List<Expense> list = [
    for (final {
          'id': id as String,
          'name': name as String,
          'amount': amount as double,
          'budgetId': budgetId as String,
          'month': month as int,
          'year': year as int,
          'day': day as int,
          'week': week as int,
        } in expensesMap)
      Expense(
          id: id,
          name: name,
          amount: amount,
          week: week,
          month: month,
          budgetId: budgetId,
          year: year,
          day: day),
  ];
  int x = 0;
  list.forEach((element) {
    x++;
  });
  return x;
}

Future<double> getExpensesTotal() async {
  // Get a reference to the database.
  final db = await database;

  // Query the table for expenses that match the given budgetId.
  final List<Map<String, Object?>> expensesMap = await db.query(
    'expenses',
  );

  // Convert the list of each expense's fields into a list of `Expense` objects.
  List<Expense> list = [
    for (final {
          'id': id as String,
          'name': name as String,
          'amount': amount as double,
          'budgetId': budgetId as String,
          'month': month as int,
          'year': year as int,
          'day': day as int,
          'week': week as int,
        } in expensesMap)
      Expense(
          id: id,
          name: name,
          amount: amount,
          week: week,
          month: month,
          budgetId: budgetId,
          year: year,
          day: day),
  ];
  double x = 0;
  list.forEach((element) {
    x += element.amount;
  });
  return x;
}

Future<double> getExpensesSumWeek(int week) async {
  // Get a reference to the database.
  final db = await database;

  // Query the table for expenses that match the given budgetId.
  final List<Map<String, Object?>> expensesMap = await db.query(
    'expenses',
    where: 'week = ? AND month = ? AND year = ? ',
    whereArgs: [week, DateTime.now().month, DateTime.now().year],
  );

  // Convert the list of each expense's fields into a list of `Expense` objects.
  List<Expense> list = [
    for (final {
          'id': id as String,
          'name': name as String,
          'amount': amount as double,
          'budgetId': budgetId as String,
          'month': month as int,
          'year': year as int,
          'day': day as int,
          'week': week as int,
        } in expensesMap)
      Expense(
          id: id,
          name: name,
          amount: amount,
          week: week,
          month: month,
          budgetId: budgetId,
          year: year,
          day: day),
  ];
  double x = 0;
  list.forEach((element) {
    x += element.amount;
  });
  return x;
}

Future<double> getExpensesSumMonth(int month) async {
  // Get a reference to the database.
  final db = await database;

  // Query the table for expenses that match the given budgetId.
  final List<Map<String, Object?>> expensesMap = await db.query(
    'expenses',
    where: 'month = ? AND year = ?',
    whereArgs: [month, DateTime.now().year],
  );

  List<Expense> list = [
    for (final {
          'id': id as String,
          'name': name as String,
          'amount': amount as double,
          'budgetId': budgetId as String,
          'month': month as int,
          'year': year as int,
          'day': day as int,
          'week': week as int,
        } in expensesMap)
      Expense(
          id: id,
          name: name,
          amount: amount,
          week: week,
          month: month,
          budgetId: budgetId,
          year: year,
          day: day),
  ];
  double x = 0;
  list.forEach((element) {
    x += element.amount;
  });
  return x;
}

Future<double> getExpensesSumYear(int year) async {
  // Get a reference to the database.
  final db = await database;

  final List<Map<String, Object?>> expensesMap = await db.query(
    'expenses',
    where: 'year = ?',
    whereArgs: [year],
  );

  List<Expense> list = [
    for (final {
          'id': id as String,
          'name': name as String,
          'amount': amount as double,
          'budgetId': budgetId as String,
          'month': month as int,
          'year': year as int,
          'day': day as int,
          'week': week as int,
        } in expensesMap)
      Expense(
          id: id,
          name: name,
          amount: amount,
          week: week,
          month: month,
          budgetId: budgetId,
          year: year,
          day: day),
  ];
  double x = 0;
  list.forEach((element) {
    x += element.amount;
  });
  return x;
}

Future<double> getExpenseOfDay(int dayIndex) async {
  // Get a reference to the database.
  final db = await database;

  // Query the table for expenses that match the given budgetId.
  final List<Map<String, Object?>> expensesMap = await db.query(
    'expenses',
    where: 'week = ? AND day = ? AND month = ? AND year = ?',
    whereArgs: [
      getCurrentWeekNumber(),
      dayIndex,
      DateTime.now().month,
      DateTime.now().year
    ],
  );

  // Convert the list of each expense's fields into a list of `Expense` objects.
  List<Expense> list = [
    for (final {
          'id': id as String,
          'name': name as String,
          'amount': amount as double,
          'budgetId': budgetId as String,
          'month': month as int,
          'year': year as int,
          'day': day as int,
          'week': week as int,
        } in expensesMap)
      Expense(
          id: id,
          name: name,
          amount: amount,
          week: week,
          month: month,
          budgetId: budgetId,
          year: year,
          day: day),
  ];
  double x = 0;
  for (var element in list) {
    x += element.amount;
  }
  return x;
}

Future<double> sumOfExpenses(String id) async {
  double x = 0;
  List<Expense> list = [];
  list = await getExpensesBudget(id);

  list.forEach((element) {
    x += element.amount;
  });
  return x;
}

Future<void> deleteBudget(String id) async {
  // Get a reference to the database.
  final db = await database;

  await db.delete(
    'budgets',
    where: 'id = ?',
    whereArgs: [id],
  );

  await db.delete(
    'expenses',
    where: 'budgetId = ?',
    whereArgs: [id],
  );
}

Future<void> saveAndReset(Expense expense) async {
  final db = await database;

  await db.update(
    'expenses',
    {'budgetId': const Uuid().v4(), 'id': const Uuid().v4()},
    where: 'id = ?',
    whereArgs: [expense.id],
  );
}

Future<void> resetDB() async {
  // Get a reference to the database.
  final db = await database;

  await db.delete(
    'budgets',
  );

  await db.delete(
    'expenses',
  );
}

Future<void> deleteExpense(String id) async {
  // Get a reference to the database.
  final db = await database;

  await db.delete(
    'expenses',
    where: 'id = ?',
    whereArgs: [id],
  );
}

Future<void> insertExpense(Expense expense) async {
  final db = await database;

  await db.insert(
    'expenses',
    expense.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<void> insertBudget(Budget budget) async {
  final db = await database;

  await db.insert(
    'budgets',
    budget.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

int getCurrentWeekNumber() {
  DateTime now = DateTime.now();
  // Get the first day of the year
  DateTime startOfYear = DateTime(now.year);
  // Calculate the number of days since the start of the year
  int daysPassed = now.difference(startOfYear).inDays;
  // Get the week number (adding +1 because weeks start from 0)
  int weekNumber = (daysPassed / 7).floor() + 1;
  return weekNumber;
}
