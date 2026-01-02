import 'dart:convert';
import 'package:http/http.dart' as http;

class RateLimitException implements Exception {
  final String message;
  RateLimitException([this.message = 'API rate limit exceeded. Please wait.']);

  @override
  String toString() => message;
}

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  ApiException(this.message, [this.statusCode]);

  @override
  String toString() => 'ApiException: $message (status: $statusCode)';
}

class CoinGeckoApiService {
  static const String _baseUrl = 'https://api.coingecko.com/api/v3';
  static const Duration _cacheDuration = Duration(seconds: 15);

  // In-memory cache
  final Map<String, _CacheEntry> _cache = {};

  /// Fetch list of cryptocurrencies
  Future<List<Map<String, dynamic>>> getMarkets() async {
    const cacheKey = 'markets';

    // Check cache
    if (_isCacheValid(cacheKey)) {
      return List<Map<String, dynamic>>.from(_cache[cacheKey]!.data as List);
    }

    final uri = Uri.parse('$_baseUrl/coins/markets?vs_currency=usd');
    final response = await http.get(uri);

    _handleErrors(response);

    final List<dynamic> data = json.decode(response.body);
    final result = data.cast<Map<String, dynamic>>();

    // Store in cache
    _cache[cacheKey] = _CacheEntry(result, DateTime.now());

    return result;
  }

  /// Fetch 7-day price chart for a specific coin
  Future<List<double>> getMarketChart(String coinId) async {
    final cacheKey = 'chart_$coinId';

    // Check cache
    if (_isCacheValid(cacheKey)) {
      return List<double>.from(_cache[cacheKey]!.data as List);
    }

    final uri = Uri.parse(
      '$_baseUrl/coins/$coinId/market_chart?vs_currency=usd&days=7',
    );
    final response = await http.get(uri);

    _handleErrors(response);

    final Map<String, dynamic> data = json.decode(response.body);
    final List<dynamic> prices = data['prices'] as List<dynamic>? ?? [];

    // Extract just the price values (second element of each [timestamp, price])
    final List<double> priceHistory = prices
        .map((item) => (item[1] as num).toDouble())
        .toList();

    // Store in cache
    _cache[cacheKey] = _CacheEntry(priceHistory, DateTime.now());

    return priceHistory;
  }

  /// Fetch coin details including description
  Future<String> getCoinDescription(String coinId) async {
    final cacheKey = 'description_$coinId';

    // Check cache
    if (_isCacheValid(cacheKey)) {
      return _cache[cacheKey]!.data as String;
    }

    final uri = Uri.parse('$_baseUrl/coins/$coinId');
    final response = await http.get(uri);

    _handleErrors(response);

    final Map<String, dynamic> data = json.decode(response.body);
    final description =
        data['description']?['en'] as String? ?? 'No description available.';

    // Store in cache
    _cache[cacheKey] = _CacheEntry(description, DateTime.now());

    return description;
  }

  bool _isCacheValid(String key) {
    final entry = _cache[key];
    if (entry == null) return false;
    return DateTime.now().difference(entry.timestamp) < _cacheDuration;
  }

  void _handleErrors(http.Response response) {
    if (response.statusCode == 429) {
      throw RateLimitException();
    }
    if (response.statusCode != 200) {
      throw ApiException('Failed to fetch data from API', response.statusCode);
    }
  }

  /// Clear cache (useful for retry after rate limit)
  void clearCache() {
    _cache.clear();
  }
}

class _CacheEntry {
  final dynamic data;
  final DateTime timestamp;

  _CacheEntry(this.data, this.timestamp);
}
