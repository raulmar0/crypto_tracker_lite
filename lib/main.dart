import 'package:crypto_tracker_lite/logic/crypto_list_bloc.dart';
import 'package:crypto_tracker_lite/logic/favorites_bloc.dart';
import 'package:crypto_tracker_lite/pages/home_page.dart';
import 'package:crypto_tracker_lite/services/coingecko_api_service.dart';
import 'package:crypto_tracker_lite/services/local_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final localStorage = LocalStorageService();
  await localStorage.init();
  runApp(AppState(localStorage: localStorage));
}

class AppState extends StatelessWidget {
  final LocalStorageService localStorage;

  const AppState({super.key, required this.localStorage});

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
        child: const MyApp(),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CryptoTracker Lite',
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF1A1A1A),
      ),
      home: const HomePage(),
    );
  }
}
