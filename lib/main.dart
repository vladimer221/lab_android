import 'package:flutter/material.dart';
import 'card_data.dart';
import 'card_item.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ЛР3 — Шабров И.А. ЦПИБу-31',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const CardListScreen(),
    );
  }
}

class CardListScreen extends StatelessWidget {
  const CardListScreen({super.key});

  void _handleLikePressed() {
    debugPrint(" Нажата кнопка лайка!");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ЛР3 — Шабров И.А. ЦПИБу-31'),
      ),
      body: ListView.builder(
        itemCount: cards.length,
        itemBuilder: (context, index) {
          return CardItemWidget(
            data: cards[index],
            onLikeToggle: _handleLikePressed,
          );
        },
      ),
    );
  }
}
