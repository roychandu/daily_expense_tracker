import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../models/expense.dart';

class ExpenseController extends ChangeNotifier {
  List<Expense> _expenses = [];
  bool _isLoading = false;

  List<Expense> get expenses => _expenses;
  bool get isLoading => _isLoading;

  ExpenseController() {
    refreshExpenses();
  }

  Future<void> refreshExpenses() async {
    _isLoading = true;
    notifyListeners();

    _expenses = await DatabaseService.instance.readAllExpenses();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addExpense(Expense expense) async {
    await DatabaseService.instance.create(expense);
    await refreshExpenses();
  }

  Future<void> updateExpense(Expense expense) async {
    await DatabaseService.instance.update(expense);
    await refreshExpenses();
  }

  Future<void> deleteExpense(int id) async {
    await DatabaseService.instance.delete(id);
    await refreshExpenses();
  }
}
