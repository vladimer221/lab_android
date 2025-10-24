import 'package:flutter/material.dart';
import '../data/card_repository.dart';
import '../model/card_data.dart';
import 'card_item.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final CardRepository repository = CardRepository();
  late Future<List<CardData>> futureCards;
  List<CardData> cards = [];
  bool isLoading = false;
  int currentPage = 1;

  @override
  void initState() {
    super.initState();
    futureCards = repository.fetchCards(page: currentPage);
    loadCards();
  }

  void loadCards() async {
    setState(() {
      isLoading = true;
    });
    try {
      final newCards = await repository.fetchCards(page: currentPage);
      setState(() {
        cards.addAll(newCards);
        isLoading = false;
        currentPage++;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Ошибка при загрузке данных: $e');
    }
  }

  void _toggleLike(CardData card) {
    setState(() {
      card.isLiked = !card.isLiked;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(card.isLiked
            ? 'Вы поставили лайк ${card.name}'
            : 'Вы убрали лайк у ${card.name}'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Персонажи (PotterDB)'),
      ),
      body: ListView.builder(
        itemCount: cards.length + 1, // +1 для индикатора загрузки
        itemBuilder: (context, index) {
          if (index == cards.length) {
            if (isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else {
              loadCards(); // загружаем следующую страницу
              return const Center(child: Text('Загрузка...'));
            }
          }
          final card = cards[index];
          return CardItem(
            card: card,
            isLiked: card.isLiked,
            onLikePressed: () => _toggleLike(card),
          );
        },
      ),
    );
  }
}
