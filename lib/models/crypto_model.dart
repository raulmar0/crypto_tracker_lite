class CryptoModel {
  final String name;
  final String symbol;
  final double price;
  final double changePercentage;
  final String iconUrl;
  final bool isFavorite;

  // Detail fields
  final double max24h;
  final double min24h;
  final double marketCap;
  final double volume24h;
  final List<double> history7d;
  final String description;

  CryptoModel({
    required this.name,
    required this.symbol,
    required this.price,
    required this.changePercentage,
    required this.iconUrl,
    this.isFavorite = false,
    required this.max24h,
    required this.min24h,
    required this.marketCap,
    required this.volume24h,
    required this.history7d,
    this.description = '',
  });
}
