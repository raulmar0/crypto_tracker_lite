import 'package:crypto_tracker_lite/models/crypto_model.dart';
import 'package:crypto_tracker_lite/services/coingecko_api_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  const CryptoListLoaded(this.cryptos);

  @override
  List<Object?> get props => [cryptos];
}

class CryptoListError extends CryptoListState {
  final String message;
  final bool isRateLimited;

  const CryptoListError(this.message, {this.isRateLimited = false});

  @override
  List<Object?> get props => [message, isRateLimited];
}

// Cubit
class CryptoListCubit extends Cubit<CryptoListState> {
  final CoinGeckoApiService apiService;

  CryptoListCubit(this.apiService) : super(CryptoListInitial());

  Future<void> loadCryptos() async {
    emit(CryptoListLoading());

    try {
      final jsonList = await apiService.getMarkets();
      final cryptos = jsonList
          .map((json) => CryptoModel.fromJson(json))
          .toList();
      emit(CryptoListLoaded(cryptos));
    } on RateLimitException catch (e) {
      emit(CryptoListError(e.message, isRateLimited: true));
    } on ApiException catch (e) {
      emit(CryptoListError(e.message));
    } catch (e) {
      emit(CryptoListError('Error loading data: $e'));
    }
  }

  Future<void> retry() async {
    apiService.clearCache();
    await loadCryptos();
  }
}
