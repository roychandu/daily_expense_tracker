import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../models/expense.dart';
import '../services/sync_service.dart';

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

  Future<void> addExpense(Expense expense, bool isCloudEnabled) async {
    final id = await DatabaseService.instance.create(expense);
    await refreshExpenses();
    
    if (isCloudEnabled) {
      final updatedExpense = Expense(
        id: id,
        amount: expense.amount,
        category: expense.category,
        note: expense.note,
        date: expense.date,
        type: expense.type,
      );
      SyncService.instance.syncExpense(updatedExpense);
    }
  }

  Future<void> updateExpense(Expense expense, bool isCloudEnabled) async {
    await DatabaseService.instance.update(expense);
    await refreshExpenses();
    
    if (isCloudEnabled) {
      SyncService.instance.syncExpense(expense);
    }
  }

  Future<void> deleteExpense(int id, bool isCloudEnabled) async {
    await DatabaseService.instance.delete(id);
    await refreshExpenses();
    
    if (isCloudEnabled) {
      SyncService.instance.deleteExpense(id);
    }
  }
}
