// lib/bloc/card_event.dart
abstract class CardEvent {}

class LoadCardsEvent extends CardEvent {
  final String searchQuery;
  final int page;

  LoadCardsEvent({required this.searchQuery, this.page = 1});
}

class SearchCardsEvent extends CardEvent {
  final String searchQuery;

  SearchCardsEvent({required this.searchQuery});
}
