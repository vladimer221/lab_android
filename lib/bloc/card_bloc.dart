// lib/bloc/card_bloc.dart
import 'dart:async';
import 'package:rxdart/rxdart.dart';  // Импортируем rxdart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'card_event.dart';
import 'card_state.dart';
import '../data/card_repository.dart';

class CardBloc extends Bloc<CardEvent, CardState> {
  final CardRepository cardRepository;
  final _searchQuerySubject = BehaviorSubject<String>();

  CardBloc(this.cardRepository) : super(CardsLoadingState()) {
    on<SearchCardsEvent>(_onSearchCards);
  }

  void _onSearchCards(SearchCardsEvent event, Emitter<CardState> emit) async {
    emit(CardsLoadingState());

    _searchQuerySubject.add(event.searchQuery);

    _searchQuerySubject
        .debounceTime(Duration(milliseconds: 500))

        .switchMap((searchQuery) {
      return Stream.fromFuture(cardRepository.fetchCards(searchQuery: searchQuery, page: 1));
    }).listen(
          (cards) {
        if (cards.isEmpty) {
          emit(CardsEmptyState());
        } else {
          emit(CardsLoadedState(cards));
        }
      },
      onError: (e) => emit(CardsErrorState('Ошибка при поиске: $e')),
    );
  }

  @override
  Future<void> close() {
    _searchQuerySubject.close();
    return super.close();
  }
}
