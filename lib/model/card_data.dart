class CardData {
  final String title;
  final String subtitle;
  final String imageUrl;

  CardData({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
  });
}

final List<CardData> cards = List.generate(
  30,
      (index) => CardData(
    title: 'Карточка №${index + 1}',
    subtitle: 'Описание карточки номер ${index + 1}',
    imageUrl: 'assets/images/img${(index % 5) + 1}.jpg',
  ),
);
