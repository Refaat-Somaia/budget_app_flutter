class Expense {
  final String id;
  final String budgetId;
  final String name;
  final double amount;
  final int day;
  final int month;
  final int year;
  final int week;

  const Expense(
      {required this.id,
      required this.budgetId,
      required this.name,
      required this.week,
      required this.amount,
      required this.day,
      required this.month,
      required this.year});

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'budgetId': budgetId,
      'day': day,
      'week': week,
      'month': month,
      'year': year
    };
  }

  @override
  String toString() {
    return 'Expense{id: $id, name: $name, amount: $amount, budgetId: $budgetId,day:$day,month:$month,year:$year,week:$week}';
  }
}
