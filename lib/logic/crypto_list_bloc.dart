import 'package:crypto_tracker_lite/api/coingecko_api_service.dart';
import 'package:crypto_tracker_lite/models/crypto_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Events
abstract class CryptoListEvent extends Equatable {
  const CryptoListEvent();

  @override
  List<Object?> get props => [];
}

class LoadCryptos extends CryptoListEvent {}

class RetryCryptos extends CryptoListEvent {}

class DismissError extends CryptoListEvent {}

// States
abstract class CryptoListState extends Equatable {
  const CryptoListState();

  @override
  List<Object?> get props => [];
}

class CryptoListInitial extends CryptoListState {}

class CryptoListLoading extends CryptoListState {}

class CryptoListLoaded extends CryptoListState {
  final List<CryptoModel> cryptos;
  final bool hasError;
  final String? errorMessage;

  const CryptoListLoaded(
    this.cryptos, {
    this.hasError = false,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [cryptos, hasError, errorMessage];
}

class CryptoListError extends CryptoListState {
  final String message;
  final bool isRateLimited;

  const CryptoListError(this.message, {this.isRateLimited = false});

  @override
  List<Object?> get props => [message, isRateLimited];
}

// Bloc
class CryptoListBloc extends Bloc<CryptoListEvent, CryptoListState> {
  final CoinGeckoApiService apiService;
  List<CryptoModel> _cachedCryptos = [];

  CryptoListBloc(this.apiService) : super(CryptoListInitial()) {
    on<LoadCryptos>(_onLoadCryptos);
    on<RetryCryptos>(_onRetryCryptos);
    on<DismissError>(_onDismissError);
  }

  Future<void> _onLoadCryptos(
    LoadCryptos event,
    Emitter<CryptoListState> emit,
  ) async {
    print('[BLOC] _onLoadCryptos called');
    // Only show loading if we have no cached data
    if (_cachedCryptos.isEmpty) {
      print('[BLOC] No cached data, emitting CryptoListLoading');
      emit(CryptoListLoading());
    }

    try {
      print('[BLOC] Calling apiService.getMarkets()');
      final jsonList = await apiService.getMarkets();
      print('[BLOC] Got ${jsonList.length} items from API');
      final cryptos = jsonList
          .map((json) => CryptoModel.fromJson(json))
          .toList();
      _cachedCryptos = cryptos;
      print('[BLOC] Emitting CryptoListLoaded with ${cryptos.length} items');
      emit(CryptoListLoaded(cryptos));
    } on RateLimitException catch (e) {
      print('[BLOC] RateLimitException: ${e.message}');
      _emitErrorState(emit, e.message, isRateLimited: true);
    } on ApiException catch (e) {
      print('[BLOC] ApiException: ${e.message}');
      _emitErrorState(emit, e.message);
    } catch (e) {
      _emitErrorState(emit, 'Error loading data: $e');
    }
  }

  void _emitErrorState(
    Emitter<CryptoListState> emit,
    String message, {
    bool isRateLimited = false,
  }) {
    if (_cachedCryptos.isNotEmpty) {
      // Show cached data with banner
      emit(
        CryptoListLoaded(_cachedCryptos, hasError: true, errorMessage: message),
      );
    } else {
      // Show full error page
      emit(CryptoListError(message, isRateLimited: isRateLimited));
    }
  }

  void _onDismissError(DismissError event, Emitter<CryptoListState> emit) {
    if (_cachedCryptos.isNotEmpty) {
      emit(CryptoListLoaded(_cachedCryptos));
    }
  }

  Future<void> _onRetryCryptos(
    RetryCryptos event,
    Emitter<CryptoListState> emit,
  ) async {
    print('[BLOC] _onRetryCryptos called - clearing cache');
    apiService.clearCache();
    await _onLoadCryptos(LoadCryptos(), emit);
  }
}
