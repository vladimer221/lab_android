import 'dart:math';
import 'package:http/http.dart' as http;
import '../model/card_data.dart';
import 'mock_card_repository.dart';

class CardRepository {
  static const String baseUrl = 'https://api.potterdb.com/v1/characters';

  Future<List<CardData>> fetchCards({int page = 1}) async {
    final List<CardData> all = [];

    try {
      final uri = Uri.parse('$baseUrl?page[number]=$page');
      final resp = await http.get(uri).timeout(const Duration(seconds: 8));

      if (resp.statusCode == 200) {
        final parsed = CardData.listFromResponseBody(resp.body);
        all.addAll(parsed);
      } else {
        print('CardRepository: HTTP ${resp.statusCode} на странице $page');
      }

      if (all.isEmpty) {
        print('CardRepository: нет данных с API — используется мок');
        return MockCardRepository().fetchCards();
      }

      all.shuffle(Random());
      return all;
    } catch (e) {
      print('CardRepository: ошибка $e — используется мок');
      return MockCardRepository().fetchCards();
    }
  }
}
