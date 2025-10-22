import 'package:flutter/material.dart';
import '../model/card_data.dart';
import 'card_item.dart';

class CardListScreen extends StatefulWidget {
  const CardListScreen({super.key});

  @override
  State<CardListScreen> createState() => _CardListScreenState();
}

class _CardListScreenState extends State<CardListScreen> {
  final List<CardData> cards = List.generate(
    20,
        (index) => CardData(
      title: 'Карточка №${index + 1}',
      subtitle: 'Описание карточки номер ${index + 1}',
      imageUrl: 'assets/images/img${(index % 6) + 1}.jpg',
    ),
  );

  void _handleLikePressed() {
    debugPrint("Нажата кнопка лайка!");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ЛР3 — Шабров И.А. ЦПИБу-31'),
        backgroundColor: Colors.blueAccent,
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
