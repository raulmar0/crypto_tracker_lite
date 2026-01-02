// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'CryptoTracker Lite';

  @override
  String get home => 'Inicio';

  @override
  String get favorites => 'Favoritos';

  @override
  String get profile => 'Perfil';

  @override
  String get settings => 'Configuración';

  @override
  String get myProfile => 'Mi perfil';

  @override
  String get name => 'Nombre';

  @override
  String get email => 'Correo';

  @override
  String get detail => 'Detalle';

  @override
  String get currentPrice => 'Precio actual';

  @override
  String get high24h => 'Máximo 24h';

  @override
  String get low24h => 'Mínimo 24h';

  @override
  String get marketCap => 'Capitalización';

  @override
  String get volume24h => 'Volumen 24h';

  @override
  String get priceHistory7d => 'Precio histórico (7 días)';

  @override
  String get about => 'Acerca de';

  @override
  String get noDescriptionAvailable => 'No hay descripción disponible.';

  @override
  String get chartStart => 'Inicio';

  @override
  String get chartToday => 'Hoy';

  @override
  String get errorLoadingChart => 'Error cargando gráfico';

  @override
  String get errorLoadingDescription => 'Error cargando descripción';

  @override
  String get noDataAvailable => 'Sin datos disponibles';

  @override
  String get rateLimitTitle => 'Límite de solicitudes excedido.';

  @override
  String get rateLimitSubtitle => 'Reintentando...';

  @override
  String get rateLimitDataUnavailable =>
      'Algunos datos pueden no estar disponibles.';

  @override
  String get errorTitle => 'Hubo un problema 😢';

  @override
  String get errorMessage =>
      'La API de CoinGecko tiene límites de velocidad. Por favor, espera unos momentos y presiona \"Reintentar\".';

  @override
  String get retry => 'Reintentar';

  @override
  String get loadDataFirst => 'Carga los datos primero';

  @override
  String get noFavoritesYet => 'No tienes favoritos aún';

  @override
  String get language => 'Idioma';

  @override
  String get spanish => 'Español';

  @override
  String get english => 'Inglés';

  @override
  String get french => 'Francés';

  @override
  String get korean => 'Coreano';
}
