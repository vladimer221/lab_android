import 'package:flutter/material.dart';
import '../model/card_data.dart';

class DetailScreen extends StatelessWidget {
  final CardData data;

  const DetailScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(data.title),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius:
              const BorderRadius.vertical(bottom: Radius.circular(20)),
              child: Image.asset(
                data.imageUrl,
                fit: BoxFit.cover,
                height: 300,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                data.title,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                data.subtitle,
                style: const TextStyle(fontSize: 18, color: Colors.black54),
              ),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Подробное описание:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: const Text(
                'Это экран с информацией о выбранной карточке. '
                    'Здесь можно разместить текст '
                ,style: TextStyle(fontSize: 16),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
