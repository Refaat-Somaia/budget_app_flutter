class Budget {
  final String id;
  final String name;
  final double maxAmount;
  final int isMonthly;
  final iconIndex;
  final colorIndex;
  const Budget(
      {required this.id,
      required this.name,
      required this.maxAmount,
      required this.isMonthly,
      required this.iconIndex,
      required this.colorIndex});

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'maxAmount': maxAmount,
      'isMonthly': isMonthly,
      'iconIndex': iconIndex,
      'colorIndex': colorIndex,
    };
  }

  @override
  String toString() {
    return 'Budget{id: $id, name: $name, maxAmount: $maxAmount,isMonthly: $isMonthly,colorIndex:$colorIndex,iconIndex:$iconIndex}';
  }
}
