import 'package:flutter/material.dart';
import '../model/card_data.dart';

class DetailScreen extends StatelessWidget {
  final CardData card;
  const DetailScreen({super.key, required this.card});

  String _display(String? v) => (v != null && v.isNotEmpty) ? v : '—';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(card.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Изображение персонажа
            if (card.image != null)
              Image.network(card.image!),
            const SizedBox(height: 12),

            // Имя персонажа
            Text(card.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            // ID
            Row(
              children: [
                const Text('ID: ', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(_display(card.id)),
              ],
            ),
            const SizedBox(height: 8),

            // Дом
            Row(
              children: [
                const Text('Дом: ', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(_display(card.house)),
              ],
            ),
            const SizedBox(height: 8),

            // Пол
            Row(
              children: [
                const Text('Пол: ', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(_display(card.gender)),
              ],
            ),
            const SizedBox(height: 8),

            // Цвет волос
            Row(
              children: [
                const Text('Цвет волос: ', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(_display(card.hairColor)),
              ],
            ),
            const SizedBox(height: 8),

            // Рост
            Row(
              children: [
                const Text('Рост: ', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(_display(card.height)),
              ],
            ),
            const SizedBox(height: 12),

            // Родители
            if (card.parents.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Родители:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ...card.parents.map((parent) => Text(parent)).toList(),
                ],
              ),
            const SizedBox(height: 12),

            // Профессии
            if (card.jobs.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Профессии:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ...card.jobs.map((job) => Text(job)).toList(),
                ],
              ),
            const SizedBox(height: 12),

            // Описание
            const Text('Описание:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
              _display(card.description),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}
