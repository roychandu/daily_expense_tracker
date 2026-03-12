import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'database_service.dart';

class SyncService {
  static final SyncService instance = SyncService._();
  SyncService._();

  final _db = FirebaseDatabase.instance.ref();
  final _auth = FirebaseAuth.instance;

  Future<void> syncLocalToCloud() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final uid = user.uid;
    
    try {
      // Sync Expenses
      final expensesList = await DatabaseService.instance.readAllExpenses();
      final Map<String, dynamic> expenseData = {};
      for (var e in expensesList) {
        // Use ID as key to prevent duplicates and allow updates
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
        await _db.child('users').child(uid).child('categories').set(categoryData);
      }
      
      print('Sync complete for user: $uid. Synced ${expenseData.length} expenses and ${categoryData.length} categories.');
    } catch (e) {
      print('Error during sync to Firebase: $e');
    }
  }
}
