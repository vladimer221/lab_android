import 'package:flutter/material.dart';
import 'package:lab1/generated/l10n.dart'; // Для использования локализованных строк
import 'package:shared_preferences/shared_preferences.dart';  // Импортируем SharedPreferences
import '../main.dart';
import 'search_screen.dart'; // Импорт экрана поиска
import '../data/card_repository.dart';
import '../model/card_data.dart';
import 'card_item.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  late CardRepository _cardRepository;
  List<CardData> cards = [];
  bool isLoading = false;
  int currentPage = 1;  // Стартовая страница
  bool hasMore = true;  // Флаг для проверки, есть ли еще данные для загрузки
  Locale _currentLocale = const Locale('en', 'US'); // По умолчанию — английский

  @override
  void initState() {
    super.initState();
    _cardRepository = CardRepository();
    _loadCards();  // Загрузка данных при старте
    _loadLikedStates();
    _checkNetworkConnection();
  }

  Future<void> _checkNetworkConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      // Если нет подключения, показываем ошибку
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Нет подключения к сети')),
      );
    }
  }


  // Загрузка состояния лайков из SharedPreferences
  Future<void> _loadLikedStates() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Пройдем по всем карточкам и загрузим их состояния
    for (var card in cards) {
      bool isLiked = prefs.getBool('liked_${card.id}') ?? false;
      setState(() {
        card.isLiked = isLiked;
      });
    }
  }

  // Сохранение состояния лайка в SharedPreferences
  Future<void> _saveLikedState(CardData card) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('liked_${card.id}', card.isLiked);
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
      _loadLikedStates();  // Загружаем состояние лайков для всех персонажей
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка: $e')),
      );
    }
  }

  // Метод для смены языка
  void _changeLanguage() {
    setState(() {
      if (_currentLocale.languageCode == 'en') {
        _currentLocale = const Locale('ru', 'RU'); // Меняем на русский
      } else {
        _currentLocale = const Locale('en', 'US'); // Меняем на английский
      }
    });
    // Меняем локаль на уровне приложения
    MyApp.setLocale(context, _currentLocale);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).appTitle), // Используем локализованный текст
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
          IconButton(
            icon: const Icon(Icons.language), // Кнопка для смены языка
            onPressed: _changeLanguage,  // Смена языка
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: cards.length + 1,  // +1 для индикатора загрузки
        itemBuilder: (context, index) {
          if (index == cards.length) {
            // Индикатор загрузки
            if (isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else {
              // Загружаем следующую страницу, если не идет загрузка
              _loadCards();
              return const Center(child: Text('Загрузка...'));
            }
          }

          final card = cards[index];
          return CardItem(
            card: card,
            isLiked: card.isLiked,
            onLikePressed: () async {
              setState(() {
                card.isLiked = !card.isLiked;
              });
              // Сохраняем новое состояние лайка
              await _saveLikedState(card);
            },
          );
        },
      ),
    );
  }
}
