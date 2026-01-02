import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_ko.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('ko'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In es, this message translates to:
  /// **'CryptoTracker Lite'**
  String get appTitle;

  /// No description provided for @home.
  ///
  /// In es, this message translates to:
  /// **'Inicio'**
  String get home;

  /// No description provided for @favorites.
  ///
  /// In es, this message translates to:
  /// **'Favoritos'**
  String get favorites;

  /// No description provided for @profile.
  ///
  /// In es, this message translates to:
  /// **'Perfil'**
  String get profile;

  /// No description provided for @settings.
  ///
  /// In es, this message translates to:
  /// **'Configuración'**
  String get settings;

  /// No description provided for @myProfile.
  ///
  /// In es, this message translates to:
  /// **'Mi perfil'**
  String get myProfile;

  /// No description provided for @name.
  ///
  /// In es, this message translates to:
  /// **'Nombre'**
  String get name;

  /// No description provided for @email.
  ///
  /// In es, this message translates to:
  /// **'Correo'**
  String get email;

  /// No description provided for @detail.
  ///
  /// In es, this message translates to:
  /// **'Detalle'**
  String get detail;

  /// No description provided for @currentPrice.
  ///
  /// In es, this message translates to:
  /// **'Precio actual'**
  String get currentPrice;

  /// No description provided for @high24h.
  ///
  /// In es, this message translates to:
  /// **'Máximo 24h'**
  String get high24h;

  /// No description provided for @low24h.
  ///
  /// In es, this message translates to:
  /// **'Mínimo 24h'**
  String get low24h;

  /// No description provided for @marketCap.
  ///
  /// In es, this message translates to:
  /// **'Capitalización'**
  String get marketCap;

  /// No description provided for @volume24h.
  ///
  /// In es, this message translates to:
  /// **'Volumen 24h'**
  String get volume24h;

  /// No description provided for @priceHistory7d.
  ///
  /// In es, this message translates to:
  /// **'Precio histórico (7 días)'**
  String get priceHistory7d;

  /// No description provided for @about.
  ///
  /// In es, this message translates to:
  /// **'Acerca de'**
  String get about;

  /// No description provided for @noDescriptionAvailable.
  ///
  /// In es, this message translates to:
  /// **'No hay descripción disponible.'**
  String get noDescriptionAvailable;

  /// No description provided for @chartStart.
  ///
  /// In es, this message translates to:
  /// **'Inicio'**
  String get chartStart;

  /// No description provided for @chartToday.
  ///
  /// In es, this message translates to:
  /// **'Hoy'**
  String get chartToday;

  /// No description provided for @errorLoadingChart.
  ///
  /// In es, this message translates to:
  /// **'Error cargando gráfico'**
  String get errorLoadingChart;

  /// No description provided for @errorLoadingDescription.
  ///
  /// In es, this message translates to:
  /// **'Error cargando descripción'**
  String get errorLoadingDescription;

  /// No description provided for @noDataAvailable.
  ///
  /// In es, this message translates to:
  /// **'Sin datos disponibles'**
  String get noDataAvailable;

  /// No description provided for @rateLimitTitle.
  ///
  /// In es, this message translates to:
  /// **'Límite de solicitudes excedido.'**
  String get rateLimitTitle;

  /// No description provided for @rateLimitSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Reintentando...'**
  String get rateLimitSubtitle;

  /// No description provided for @rateLimitDataUnavailable.
  ///
  /// In es, this message translates to:
  /// **'Algunos datos pueden no estar disponibles.'**
  String get rateLimitDataUnavailable;

  /// No description provided for @errorTitle.
  ///
  /// In es, this message translates to:
  /// **'Hubo un problema 😢'**
  String get errorTitle;

  /// No description provided for @errorMessage.
  ///
  /// In es, this message translates to:
  /// **'La API de CoinGecko tiene límites de velocidad. Por favor, espera unos momentos y presiona \"Reintentar\".'**
  String get errorMessage;

  /// No description provided for @retry.
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get retry;

  /// No description provided for @loadDataFirst.
  ///
  /// In es, this message translates to:
  /// **'Carga los datos primero'**
  String get loadDataFirst;

  /// No description provided for @noFavoritesYet.
  ///
  /// In es, this message translates to:
  /// **'No tienes favoritos aún'**
  String get noFavoritesYet;

  /// No description provided for @language.
  ///
  /// In es, this message translates to:
  /// **'Idioma'**
  String get language;

  /// No description provided for @spanish.
  ///
  /// In es, this message translates to:
  /// **'Español'**
  String get spanish;

  /// No description provided for @english.
  ///
  /// In es, this message translates to:
  /// **'Inglés'**
  String get english;

  /// No description provided for @french.
  ///
  /// In es, this message translates to:
  /// **'Francés'**
  String get french;

  /// No description provided for @korean.
  ///
  /// In es, this message translates to:
  /// **'Coreano'**
  String get korean;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'fr', 'ko'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'ko':
      return AppLocalizationsKo();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
