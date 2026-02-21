import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'controllers/settings_controller.dart';
import 'controllers/expense_controller.dart';
import 'l10n/app_localizations.dart';
import 'common_widgets/app_theme.dart';
import 'screens/home_screen/home_screen.dart';

import 'package:provider/provider.dart';

import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb && (Platform.isWindows || Platform.isLinux)) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  // Initialize Notifications
  await NotificationService().init();

  final prefs = await SharedPreferences.getInstance();
  final settingsController = SettingsController(prefs);
  final expenseController = ExpenseController();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: settingsController),
        ChangeNotifierProvider.value(value: expenseController),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsController>(
      builder: (context, settingsController, child) {
        return MaterialApp(
          title: 'Daily Expense Tracker',
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: settingsController.themeMode,
          locale: settingsController.locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          debugShowCheckedModeBanner: false,
          home: const HomeScreen(),
        );
      },
    );
  }
}
