import 'package:budget_flow/theme/app_theme.dart';
import 'package:flutter/material.dart';

class TitleCard extends StatelessWidget {
  final String title;

  const TitleCard({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 66,
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(0xFFDCE1EB), // textPrimary
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
