import 'package:flutter/material.dart';
import '../data/card_repository.dart';
import '../model/card_data.dart';
import 'card_item.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late CardRepository _cardRepository;
  TextEditingController searchController = TextEditingController();
  List<CardData> searchResults = [];
  bool isLoading = false;
  List<CardData> allCards = [];  // Сохраняем все карточки

  @override
  void initState() {
    super.initState();
    _cardRepository = CardRepository();
    _loadAllCards();  // Загружаем все карточки
  }

  // Загружаем все карточки
  Future<void> _loadAllCards() async {
    setState(() {
      isLoading = true;
    });

    try {
      final allCardsData = await _cardRepository.fetchCards(page: 1); // Получаем все карточки
      setState(() {
        allCards = allCardsData;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Ошибка при загрузке данных: $e');
    }
  }

  // Функция для фильтрации карточек по имени
  void _filterCards(String query) {
    setState(() {
      if (query.isEmpty) {
        searchResults = [];  // Если запрос пустой, очищаем результаты
      } else {
        // Фильтруем все карточки по началу имени
        searchResults = allCards
            .where((card) => card.name.toLowerCase().startsWith(query.toLowerCase()))
            .toList();
      }
    });
  }


  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Поиск'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                hintText: 'Поиск...',
                border: OutlineInputBorder(),
              ),
              onChanged: _filterCards,  // Каждый ввод текста инициирует фильтрацию
            ),
          ),
          if (isLoading)
            const Center(child: CircularProgressIndicator()),  // Индикатор загрузки
          Expanded(
            child: ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                final card = searchResults[index];
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
        ],
      ),
    );
  }
}
