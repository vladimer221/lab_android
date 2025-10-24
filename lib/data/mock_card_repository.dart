import '../model/card_data.dart';
import 'dart:math';

class MockCardRepository {
  Future<List<CardData>> fetchCards() async {
    await Future.delayed(const Duration(milliseconds: 400));

    // 30 персонажей с разными данными
    return List.generate(30, (index) {
      final names = [
        'Гарри Поттер', 'Рон Уизли', 'Гермиона Грейнджер', 'Альбус Дамблдор', 'Северус Снейп',
        'Драко Малфой', 'Ремус Люпин', 'Минерва Макгонагалл', 'Фред Уизли', 'Джордж Уизли',
        'Невилл Лонгботтом', 'Луна Лавгуд', 'Сириус Блэк', 'Питер Петтигрю', 'Беллатрикс Лестрейндж',
        'Гилдерой Локкарт', 'Артур Уизли', 'Молли Уизли', 'Лили Поттер', 'Джеймс Поттер',
        'Том Реддл', 'Волдеморт', 'Люциус Малфой', 'Нарцисса Малфой', 'Петуния Дерсли',
        'Вернон Дерсли', 'Хагрид', 'Чжоу Чанг', 'Грета Муджури', 'Мэтт Уильямс', 'Тедд Тонкс'
      ];

      final houses = ['Гриффиндор', 'Слизерин', 'Пуффендуй', 'Равенкло'];

      return CardData(
        id: 'card-$index',
        name: names[Random().nextInt(names.length)],
        house: houses[Random().nextInt(houses.length)],
        gender: Random().nextBool() ? 'male' : 'female',
        description: 'Описание персонажа ${index + 1} — это просто пример.',
      );
    });
  }
}
