import 'package:flutter/material.dart';
import 'package:crypto_tracker_lite/pages/home_page.dart';
import 'package:provider/provider.dart';

// d3s4r00ll4d0 41
void main() {
  runApp(const AppState());
}

class AppState extends StatelessWidget {
  const AppState({super.key});

  @override
  Widget build(BuildContext context) {
    // Aquí inyectaremos las dependencias globales (Api, Cache, etc.)
    return MultiProvider(
      providers: [
        // TODO: Aquí agregaremos el ApiService y los Repositorios más adelante
        Provider(create: (_) => 'Placeholder Dependency'),
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
      theme: ThemeData.dark().copyWith(
        // Configuración base para Modo Oscuro
        scaffoldBackgroundColor: const Color(0xFF1A1A1A), // Color típico oscuro
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
