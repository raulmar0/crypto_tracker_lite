import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crypto_tracker_lite/services/local_storage_service.dart';

class FavoritesCubit extends Cubit<List<String>> {
  final LocalStorageService _storageService;

  FavoritesCubit(this._storageService) : super([]) {
    _loadFavorites();
  }

  void _loadFavorites() {
    final favorites = _storageService.getFavorites();
    emit(favorites);
  }

  void toggleFavorite(String coinId) {
    final currentFavorites = List<String>.from(state);
    if (currentFavorites.contains(coinId)) {
      currentFavorites.remove(coinId);
    } else {
      currentFavorites.add(coinId);
    }

    // Update local storage
    _storageService.saveFavorites(currentFavorites);

    // Emit new state
    emit(currentFavorites);
  }

  bool isFavorite(String coinId) {
    return state.contains(coinId);
  }
}
