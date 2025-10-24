import 'package:flutter/material.dart';
import 'view/list_screen.dart';

void main() {
  runApp(const LabApp());
}

class LabApp extends StatelessWidget {
  const LabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 4 - PotterDB',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const ListScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
