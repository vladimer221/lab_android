import 'dart:convert';

/// Модель данных персонажа (DTO + модель)
class CardData {
  final String id;
  final String name;
  final String house;
  final String gender;
  final String description; // описание из API
  final String? hairColor; // цвет волос
  final String? height; // рост
  final List<String> parents; // родители
  final String? image; // изображение персонажа
  final List<String> jobs; // профессии
  bool isLiked;

  CardData({
    required this.id,
    required this.name,
    required this.house,
    required this.gender,
    required this.description,
    this.hairColor,
    this.height,
    this.parents = const [],
    this.image,
    this.jobs = const [],
    this.isLiked = false,
  });

  /// Создание из JSON (ответ PotterDB)
  factory CardData.fromJson(Map<String, dynamic> json) {
    final attrs = json['attributes'] ?? {};
    return CardData(
      id: json['id'] ?? '',
      name: attrs['name'] ?? 'Без имени',
      house: attrs['house'] ?? '',
      gender: attrs['gender'] ?? '',
      description: attrs['wiki'] ?? 'Описание отсутствует', // Заглушка
      hairColor: attrs['hair_color'],
      height: attrs['height']?.toString(),
      parents: List<String>.from(attrs['parents'] ?? []),
      image: attrs['image'],
      jobs: List<String>.from(attrs['jobs'] ?? []),
      isLiked: false,
    );
  }

  /// Преобразование в JSON (если понадобится)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'attributes': {
        'name': name,
        'house': house,
        'gender': gender,
        'wiki': description,
        'hair_color': hairColor,
        'height': height,
        'parents': parents,
        'image': image,
        'jobs': jobs,
      },
      'isLiked': isLiked,
    };
  }

  /// Утилита: парсит ответ API и возвращает список CardData
  static List<CardData> listFromResponseBody(String body) {
    final decoded = jsonDecode(body);
    final List<dynamic> data = decoded['data'] ?? [];
    return data.map((e) => CardData.fromJson(e)).toList();
  }
}
