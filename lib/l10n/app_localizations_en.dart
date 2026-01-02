// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'CryptoTracker Lite';

  @override
  String get home => 'Home';

  @override
  String get favorites => 'Favorites';

  @override
  String get profile => 'Profile';

  @override
  String get settings => 'Settings';

  @override
  String get myProfile => 'My Profile';

  @override
  String get name => 'Name';

  @override
  String get email => 'Email';

  @override
  String get detail => 'Detail';

  @override
  String get currentPrice => 'Current Price';

  @override
  String get high24h => '24h High';

  @override
  String get low24h => '24h Low';

  @override
  String get marketCap => 'Market Cap';

  @override
  String get volume24h => '24h Volume';

  @override
  String get priceHistory7d => 'Price History (7 days)';

  @override
  String get about => 'About';

  @override
  String get noDescriptionAvailable => 'No description available.';

  @override
  String get chartStart => 'Start';

  @override
  String get chartToday => 'Today';

  @override
  String get errorLoadingChart => 'Error loading chart';

  @override
  String get errorLoadingDescription => 'Error loading description';

  @override
  String get noDataAvailable => 'No data available';

  @override
  String get rateLimitTitle => 'Request limit exceeded.';

  @override
  String get rateLimitSubtitle => 'Retrying...';

  @override
  String get rateLimitDataUnavailable => 'Some data may not be available.';

  @override
  String get errorTitle => 'There was a problem 😢';

  @override
  String get errorMessage =>
      'The CoinGecko API has rate limits. Please wait a moment and press \"Retry\".';

  @override
  String get retry => 'Retry';

  @override
  String get loadDataFirst => 'Load data first';

  @override
  String get noFavoritesYet => 'You have no favorites yet';

  @override
  String get language => 'Language';

  @override
  String get spanish => 'Spanish';

  @override
  String get english => 'English';

  @override
  String get french => 'French';

  @override
  String get korean => 'Korean';
}
