class CryptoModel {
  final String name;
  final String symbol;
  final double price;
  final double changePercentage;
  final String iconUrl;
  final bool isFavorite;

  CryptoModel({
    required this.name,
    required this.symbol,
    required this.price,
    required this.changePercentage,
    required this.iconUrl,
    this.isFavorite = false,
  });
}
