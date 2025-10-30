import 'package:flutter/material.dart';
import 'search_screen.dart';
import '../data/card_repository.dart';
import '../model/card_data.dart';
import 'card_item.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  late CardRepository _cardRepository;
  List<CardData> cards = [];
  bool isLoading = false;
  int currentPage = 1;
  bool hasMore = true;  // Флаг для проверки, есть ли еще данные для загрузки

  @override
  void initState() {
    super.initState();
    _cardRepository = CardRepository();
    _loadCards();  // Загрузка данных при старте
  }

  Future<void> _loadCards() async {
    if (isLoading || !hasMore) return;  // Если уже идет загрузка или больше нет данных

    setState(() {
      isLoading = true;
    });

    try {
      final newCards = await _cardRepository.fetchCards(page: currentPage);
      setState(() {
        isLoading = false;
        if (newCards.isNotEmpty) {
          cards.addAll(newCards);  // Добавляем новые карточки к уже загруженным
          currentPage++;  // Увеличиваем номер страницы
        } else {
          hasMore = false;  // Если нет новых данных, устанавливаем флаг
        }
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Ошибка при загрузке данных: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Персонажи (PotterDB)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),  // Иконка лупы для поиска
            onPressed: () {
              // Открытие экрана поиска при нажатии на лупу
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchScreen()),  // Переход на экран поиска
              );
            },
          ),
        ],
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollInfo) {
          // Проверка, если мы прокрутили в конец списка
          if (!isLoading && hasMore && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            _loadCards();
            return true; // Возвращаем true, чтобы предотвратить дальнейшую обработку прокрутки
          }
          return false;
        },
        child: ListView.builder(
          itemCount: cards.length + (isLoading ? 1 : 0),  // Индикатор загрузки, если идет загрузка
          itemBuilder: (context, index) {
            if (index == cards.length) {
              // Индикатор загрузки
              return const Center(child: CircularProgressIndicator());
            }

            final card = cards[index];
            return CardItem(
              card: card,
              isLiked: card.isLiked,
              onLikePressed: () {
                setState(() {
                  card.isLiked = !card.isLiked;
                });
              },
            );
          },
        ),
      ),
    );
  }
}
