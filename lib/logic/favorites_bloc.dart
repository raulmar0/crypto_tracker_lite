import 'package:crypto_tracker_lite/services/local_storage_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Events
abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object?> get props => [];
}

class LoadFavorites extends FavoritesEvent {}

class ToggleFavorite extends FavoritesEvent {
  final String symbol;

  const ToggleFavorite(this.symbol);

  @override
  List<Object?> get props => [symbol];
}

// State
class FavoritesState extends Equatable {
  final List<String> favorites;

  const FavoritesState(this.favorites);

  @override
  List<Object?> get props => [favorites];
}

// Bloc
class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final LocalStorageService _storageService;

  FavoritesBloc(this._storageService) : super(const FavoritesState([])) {
    on<LoadFavorites>(_onLoadFavorites);
    on<ToggleFavorite>(_onToggleFavorite);

    // Load favorites on initialization
    add(LoadFavorites());
  }

  void _onLoadFavorites(LoadFavorites event, Emitter<FavoritesState> emit) {
    final favorites = _storageService.getFavorites();
    emit(FavoritesState(favorites));
  }

  void _onToggleFavorite(ToggleFavorite event, Emitter<FavoritesState> emit) {
    final currentFavorites = List<String>.from(state.favorites);

    if (currentFavorites.contains(event.symbol)) {
      currentFavorites.remove(event.symbol);
    } else {
      currentFavorites.add(event.symbol);
    }

    // Update local storage
    _storageService.saveFavorites(currentFavorites);

    // Emit new state
    emit(FavoritesState(currentFavorites));
  }

  bool isFavorite(String symbol) {
    return state.favorites.contains(symbol);
  }
}
