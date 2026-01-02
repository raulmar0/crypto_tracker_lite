import 'package:crypto_tracker_lite/l10n/app_localizations.dart';
import 'package:crypto_tracker_lite/logic/settings_bloc.dart';
import 'package:crypto_tracker_lite/pages/home_page.dart';
import 'package:crypto_tracker_lite/providers/app_providers.dart';
import 'package:crypto_tracker_lite/services/local_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final localStorage = LocalStorageService();
  await localStorage.init();
  runApp(AppProviders(localStorage: localStorage, child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'CryptoTracker Lite',
          locale: state.locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: ThemeData(
            brightness: Brightness.dark,
            useMaterial3: true,
            scaffoldBackgroundColor: const Color(0xFF1A1A1A),
          ),
          home: const HomePage(),
        );
      },
    );
  }
}
