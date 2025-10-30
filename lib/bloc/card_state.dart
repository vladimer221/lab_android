import 'package:lab1/model/card_data.dart';

// lib/bloc/card_state.dart
abstract class CardState {}

class CardsLoadingState extends CardState {}

class CardsLoadedState extends CardState {
  final List<CardData> cards;
  CardsLoadedState(this.cards);
}

class CardsErrorState extends CardState {
  final String error;
  CardsErrorState(this.error);
}

class CardsEmptyState extends CardState {}

