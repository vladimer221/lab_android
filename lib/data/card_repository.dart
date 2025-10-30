import 'dart:async';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';
import '../model/card_data.dart';
import 'mock_card_repository.dart';


class CardRepository {
  static const String baseUrl = 'https://api.potterdb.com/v1/characters';

  final _searchQuerySubject = BehaviorSubject<String>();  // Поток для поиска с debounce

  CardRepository() {
    // Обработка поиска с debounce
    _searchQuerySubject
        .debounceTime(Duration(milliseconds: 500))  // Задержка перед запросом
        .switchMap((searchQuery) {
      return Stream.fromFuture(fetchCards(searchQuery: searchQuery));  // Запрос на сервер
    }).listen((cards) {
      // Логика обработки данных, можно обновить состояние, если необходимо
    });
  }

  // Метод для получения списка персонажей
  Future<List<CardData>> fetchCards({int page = 1, String searchQuery = ''}) async {
    final List<CardData> all = [];

    try {
      final uri = Uri.parse('$baseUrl?page[number]=$page&filter[name]=$searchQuery');  // Обновляем запрос с фильтрацией
      print('Request URL: $uri');  // Добавим вывод URL для отладки

      final resp = await http.get(uri).timeout(const Duration(seconds: 8));

      if (resp.statusCode == 200) {
        final parsed = CardData.listFromResponseBody(resp.body);
        all.addAll(parsed);
      } else {
        print('CardRepository: HTTP ${resp.statusCode} на странице $page');
        throw Exception('Ошибка при загрузке данных с API');
      }

      if (all.isEmpty) {
        print('CardRepository: нет данных с API — используется мок');
        return MockCardRepository().fetchCards();
      }

      all.shuffle(Random());
      return all;
    } catch (e) {
      print('CardRepository: ошибка $e — используется мок');
      throw Exception('Ошибка при запросе данных');
    }
  }



  // Публичный метод для добавления запроса в поток поиска
  void searchCards(String query) {
    _searchQuerySubject.add(query);  // Добавляем запрос в поток
  }

  // Публичный геттер для потока поиска
  Stream<List<CardData>> get searchResultsStream {
    return _searchQuerySubject.stream
        .debounceTime(Duration(milliseconds: 500)) // Задержка перед отправкой запроса
        .switchMap((query) {
      return Stream.fromFuture(fetchCards(searchQuery: query));
    });
  }

  // Закрываем поток при уничтожении объекта
  void dispose() {
    _searchQuerySubject.close();
  }
}
