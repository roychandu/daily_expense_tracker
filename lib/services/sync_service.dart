import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'database_service.dart';
import '../models/expense.dart';

class SyncService {
  static final SyncService instance = SyncService._();
  SyncService._() {
    _connectivity.onConnectivityChanged.listen(_handleConnectivityChange);
  }

  final _db = FirebaseDatabase.instance.ref();
  final _auth = FirebaseAuth.instance;
  final _connectivity = Connectivity();

  Timer? _syncTimer;
  bool _isSyncing = false;

  final ValueNotifier<DateTime?> lastSyncTime = ValueNotifier<DateTime?>(null);
  final ValueNotifier<String> storageUsed = ValueNotifier<String>('0 KB');

  void _handleConnectivityChange(List<ConnectivityResult> results) {
    if (results.any((r) => r != ConnectivityResult.none)) {
      print('Connectivity restored. Next periodic sync will handle updates.');
      // Removed immediate syncLocalToCloud() call
    }
  }

  void initPeriodicSync({required bool isEnabled, required bool isPremium}) {
    _syncTimer?.cancel();
    if (isEnabled && isPremium) {
      // Set to 10 minutes for testing as requested
      _syncTimer = Timer.periodic(const Duration(hours: 4), (timer) {
        syncLocalToCloud();
      });
      // Removed immediate syncLocalToCloud() call
    }
  }

  void stopPeriodicSync() {
    _syncTimer?.cancel();
    _syncTimer = null;
  }

  Future<bool> hasInternet() async {
    final results = await _connectivity.checkConnectivity();
    return results.any((r) => r != ConnectivityResult.none);
  }

  Future<void> syncExpense(Expense expense) async {
    // Individual sync disabled to enforce strict 10-minute interval
    print('Individual sync ignored. Periodic sync will handle this.');
  }

  Future<void> deleteExpense(int id) async {
    // Individual delete disabled to enforce strict 10-minute interval
    print('Individual delete ignored. Periodic sync will handle this.');
  }

  Future<void> syncLocalToCloud() async {
    if (_isSyncing) return;
    if (!await hasInternet()) {
      print('Cloud Sync Skipped: No internet connection.');
      return;
    }

    final user = _auth.currentUser;
    if (user == null) return;

    _isSyncing = true;
    final uid = user.uid;

    try {
      print('Starting full cloud sync for user: $uid');
      // Sync Expenses
      final expensesList = await DatabaseService.instance.readAllExpenses();
      final Map<String, dynamic> expenseData = {};
      for (var e in expensesList) {
        if (e.id != null) {
          expenseData[e.id.toString()] = e.toMap();
        }
      }

      if (expenseData.isNotEmpty) {
        await _db.child('users').child(uid).child('expenses').set(expenseData);
      }

      // Sync Categories
      final categoriesList = await DatabaseService.instance.readAllCategories();
      final Map<String, dynamic> categoryData = {};
      for (var c in categoriesList) {
        final id = c['id'];
        if (id != null) {
          categoryData[id.toString()] = c;
        }
      }

      if (categoryData.isNotEmpty) {
        await _db
            .child('users')
            .child(uid)
            .child('categories')
            .set(categoryData);
      }

      print(
        'Sync complete. Synced ${expenseData.length} expenses and ${categoryData.length} categories.',
      );

      // Update metadata
      lastSyncTime.value = DateTime.now();

      // Estimate storage size (simplified JSON size check)
      final totalData = jsonEncode({
        'expenses': expenseData,
        'categories': categoryData,
      });
      final bytes = utf8.encode(totalData).length;
      if (bytes < 1024) {
        storageUsed.value = '$bytes Bytes';
      } else if (bytes < 1024 * 1024) {
        storageUsed.value = '${(bytes / 1024).toStringAsFixed(2)} KB';
      } else {
        storageUsed.value = '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
      }
    } catch (e) {
      print('Error during sync to Firebase: $e');
    } finally {
      _isSyncing = false;
    }
  }
}
