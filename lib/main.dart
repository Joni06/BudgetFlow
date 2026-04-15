import 'package:buget_flow/theme/app_theme.dart';
import 'package:buget_flow/views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'logic/budget_provider.dart';
import 'logic/settings_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProxyProvider<SettingsProvider, BudgetProvider>(
          create: (_) => BudgetProvider(),
          update: (context, settingsProv, budgetProv) =>
          budgetProv!..updateSettings(settingsProv),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const HomeView(title: 'Budget Flow'),
    );
  }
}