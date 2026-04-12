import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TitleCard extends StatelessWidget {
  final String title;

  const TitleCard({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1F242D), // surfaceVariant
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Color(0xFFDCE1EB), // textPrimary
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
