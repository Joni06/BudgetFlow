import 'package:budget_flow/theme/app_theme.dart';
import 'package:budget_flow/views/settings/settings_view.dart';
import 'package:budget_flow/views/year_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../logic/budget_provider.dart';
import '../logic/settings_provider.dart';
import '../widgets/dialogs/add_transaction_dialog.dart';
import '../widgets/year_card.dart';

class HomeView extends StatefulWidget {
  final String title;

  const HomeView({super.key, required this.title});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final budgetProv = context.watch<BudgetProvider>();
    final settingsProv = context.watch<SettingsProvider>();

    if (budgetProv.isLoading || settingsProv.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final List<Widget> pages = [
      _buildHomeContent(budgetProv),
      const Center(child: Text('Latest')),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        title: Text(widget.title),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsView(title: 'Settings'),
                ),
              );
            },
          ),
        ],
      ),
      body: pages[_selectedIndex],

      bottomNavigationBar: NavigationBar(
        height: 66,
        backgroundColor: AppTheme.surface,
        indicatorColor: AppTheme.primary.withValues(alpha: 0.2),
        selectedIndex: _selectedIndex,

        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },

        destinations: [
          NavigationDestination(
            icon: Icon(Icons.home, color: AppTheme.textSecondary),
            selectedIcon: Icon(Icons.home, color: AppTheme.primary),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart, color: AppTheme.textSecondary),
            selectedIcon: Icon(Icons.bar_chart, color: AppTheme.primary),
            label: 'Latest',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddTransactionDialog(context),
        backgroundColor: AppTheme.primary,
        child: const Icon(Icons.add, color: AppTheme.textPrimary),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildHomeContent(BudgetProvider budgetProv) {
    final years = budgetProv.years;
    if (years.isEmpty) return const Center(child: Text('No data available'));

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 10),
      itemCount: years.length,
      itemBuilder: (context, index) {
        final yearObj = years[index];
        final totalYearlySpent = yearObj.months.values.fold(
          0.0,
          (sum, m) => sum + m.spent,
        );
        return YearCard(
          year: yearObj.year,
          spent: totalYearlySpent,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => YearView(yearNumber: yearObj.year),
            ),
          ),
        );
      },
    );
  }
}
