class CryptoModel {
  final String id;
  final String symbol;
  final String name;
  final String image;
  final double currentPrice;
  final double marketCap;
  final double high24h;
  final double low24h;
  final double priceChangePercentage24h;
  final double totalVolume;
  final List<double> priceHistory; // For chart data

  CryptoModel({
    required this.id,
    required this.symbol,
    required this.name,
    required this.image,
    required this.currentPrice,
    required this.marketCap,
    required this.high24h,
    required this.low24h,
    required this.priceChangePercentage24h,
    required this.totalVolume,
    this.priceHistory = const [],
  });

  factory CryptoModel.fromJson(Map<String, dynamic> json) {
    return CryptoModel(
      id: json['id'] as String? ?? '',
      symbol: (json['symbol'] as String? ?? '').toUpperCase(),
      name: json['name'] as String? ?? '',
      image: json['image'] as String? ?? '',
      currentPrice: (json['current_price'] as num?)?.toDouble() ?? 0.0,
      marketCap: (json['market_cap'] as num?)?.toDouble() ?? 0.0,
      high24h: (json['high_24h'] as num?)?.toDouble() ?? 0.0,
      low24h: (json['low_24h'] as num?)?.toDouble() ?? 0.0,
      priceChangePercentage24h:
          (json['price_change_percentage_24h'] as num?)?.toDouble() ?? 0.0,
      totalVolume: (json['total_volume'] as num?)?.toDouble() ?? 0.0,
    );
  }

  CryptoModel copyWith({List<double>? priceHistory}) {
    return CryptoModel(
      id: id,
      symbol: symbol,
      name: name,
      image: image,
      currentPrice: currentPrice,
      marketCap: marketCap,
      high24h: high24h,
      low24h: low24h,
      priceChangePercentage24h: priceChangePercentage24h,
      totalVolume: totalVolume,
      priceHistory: priceHistory ?? this.priceHistory,
    );
  }
}
