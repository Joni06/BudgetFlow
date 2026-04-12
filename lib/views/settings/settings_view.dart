import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widgets/title_card.dart';

class SettingsView extends StatelessWidget{
  final String title;
  const SettingsView({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(title),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          TitleCard(title: "Settings"),
        ],
      ),
    );
  }
}