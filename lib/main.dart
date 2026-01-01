import 'package:flutter/material.dart';
import 'package:crypto_tracker_lite/logic/favorites_cubit.dart';
import 'package:crypto_tracker_lite/pages/home_page.dart';
import 'package:crypto_tracker_lite/services/local_storage_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

// d3s4r00ll4d0 41
// d3s4r00ll4d0 41
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
    // Aquí inyectaremos las dependencias globales (Api, Cache, etc.)
    return MultiProvider(
      providers: [
        // Inyección de Servicios (Singletons)
        Provider<LocalStorageService>.value(value: localStorage),
        // Inyección de BLoCs
        BlocProvider<FavoritesCubit>(
          create: (context) => FavoritesCubit(localStorage),
        ),
      ],
      child: const MyApp(),
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
