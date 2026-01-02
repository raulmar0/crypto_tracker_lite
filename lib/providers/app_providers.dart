import 'package:crypto_tracker_lite/api/coingecko_api_service.dart';
import 'package:crypto_tracker_lite/logic/crypto_list_bloc.dart';
import 'package:crypto_tracker_lite/logic/favorites_bloc.dart';
import 'package:crypto_tracker_lite/services/local_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Provides all app-level dependencies using BLoC's RepositoryProvider
/// and BlocProvider for dependency injection.
class AppProviders extends StatelessWidget {
  final LocalStorageService localStorage;
  final Widget child;

  const AppProviders({
    super.key,
    required this.localStorage,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final apiService = CoinGeckoApiService();

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<LocalStorageService>.value(value: localStorage),
        RepositoryProvider<CoinGeckoApiService>.value(value: apiService),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<FavoritesBloc>(
            create: (context) => FavoritesBloc(localStorage),
          ),
          BlocProvider<CryptoListBloc>(
            create: (context) => CryptoListBloc(apiService),
          ),
        ],
        child: child,
      ),
    );
  }
}
