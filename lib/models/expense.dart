class Expense {
  final int? id;
  final double amount;
  final String category;
  final String note;
  final DateTime date;
  final String type; // 'income' or 'expense'

  Expense({
    this.id,
    required this.amount,
    required this.category,
    this.note = '',
    required this.date,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'category': category,
      'note': note,
      'date': date.toIso8601String(),
      'type': type,
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      amount: map['amount'],
      category: map['category'],
      note: map['note'],
      date: DateTime.parse(map['date']),
      type: map['type'] ?? (map['isExpense'] == 1 ? 'expense' : 'income'),
    );
  }
}
