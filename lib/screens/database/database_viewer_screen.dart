import 'package:flutter/material.dart';
import '../../services/database_service.dart';
import '../../common_widgets/app_colors.dart';
import '../../common_widgets/app_text_styles.dart';

class DatabaseViewerScreen extends StatefulWidget {
  const DatabaseViewerScreen({super.key});

  @override
  State<DatabaseViewerScreen> createState() => _DatabaseViewerScreenState();
}

class _DatabaseViewerScreenState extends State<DatabaseViewerScreen> {
  List<Map<String, dynamic>> _data = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRawData();
  }

  Future<void> _fetchRawData() async {
    setState(() => _isLoading = true);
    final db = await DatabaseService.instance.database;
    final result = await db.query('expenses');
    setState(() {
      _data = result;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Raw Database Viewer'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _fetchRawData),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _data.isEmpty
          ? const Center(child: Text('No data found in database'))
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: DataTable(
                  headingTextStyle: AppTextStyles.caption.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.accentTeal,
                  ),
                  dataTextStyle: AppTextStyles.body.copyWith(fontSize: 12),
                  columns: _data.first.keys.map((key) {
                    return DataColumn(label: Text(key.toUpperCase()));
                  }).toList(),
                  rows: _data.map((row) {
                    return DataRow(
                      cells: row.values.map((val) {
                        return DataCell(Text(val.toString()));
                      }).toList(),
                    );
                  }).toList(),
                ),
              ),
            ),
    );
  }
}
