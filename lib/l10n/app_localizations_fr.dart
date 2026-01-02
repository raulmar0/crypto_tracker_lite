// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'CryptoTracker Lite';

  @override
  String get home => 'Accueil';

  @override
  String get favorites => 'Favoris';

  @override
  String get profile => 'Profil';

  @override
  String get settings => 'Paramètres';

  @override
  String get myProfile => 'Mon Profil';

  @override
  String get name => 'Nom';

  @override
  String get email => 'E-mail';

  @override
  String get detail => 'Détail';

  @override
  String get currentPrice => 'Prix actuel';

  @override
  String get high24h => 'Max 24h';

  @override
  String get low24h => 'Min 24h';

  @override
  String get marketCap => 'Capitalisation';

  @override
  String get volume24h => 'Volume 24h';

  @override
  String get priceHistory7d => 'Historique des prix (7 jours)';

  @override
  String get about => 'À propos';

  @override
  String get noDescriptionAvailable => 'Aucune description disponible.';

  @override
  String get chartStart => 'Début';

  @override
  String get chartToday => 'Aujourd\'hui';

  @override
  String get errorLoadingChart => 'Erreur de chargement du graphique';

  @override
  String get errorLoadingDescription =>
      'Erreur de chargement de la description';

  @override
  String get noDataAvailable => 'Aucune donnée disponible';

  @override
  String get rateLimitTitle => 'Limite de requêtes atteinte.';

  @override
  String get rateLimitSubtitle => 'Nouvelle tentative...';

  @override
  String get rateLimitDataUnavailable =>
      'Certaines données peuvent ne pas être disponibles.';

  @override
  String get errorTitle => 'Un problème est survenu 😢';

  @override
  String get errorMessage =>
      'L\'API CoinGecko a des limites de débit. Veuillez patienter un moment et appuyer sur \"Réessayer\".';

  @override
  String get retry => 'Réessayer';

  @override
  String get loadDataFirst => 'Chargez d\'abord les données';

  @override
  String get noFavoritesYet => 'Vous n\'avez pas encore de favoris';

  @override
  String get language => 'Langue';

  @override
  String get spanish => 'Espagnol';

  @override
  String get english => 'Anglais';

  @override
  String get french => 'Français';

  @override
  String get korean => 'Coréen';
}
