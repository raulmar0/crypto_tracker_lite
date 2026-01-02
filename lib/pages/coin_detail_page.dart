import 'package:crypto_tracker_lite/l10n/app_localizations.dart';
import 'package:crypto_tracker_lite/logic/favorites_bloc.dart';
import 'package:crypto_tracker_lite/models/crypto_model.dart';
import 'package:crypto_tracker_lite/api/coingecko_api_service.dart';
import 'package:crypto_tracker_lite/widgets/error_banner.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class CoinDetailPage extends StatefulWidget {
  final CryptoModel crypto;

  const CoinDetailPage({super.key, required this.crypto});

  @override
  State<CoinDetailPage> createState() => _CoinDetailPageState();
}

class _CoinDetailPageState extends State<CoinDetailPage> {
  List<double> _priceHistory = [];
  bool _isLoadingChart = true;
  String? _chartError;
  bool _isRateLimited = false;

  Map<String, dynamic> _descriptionMap = {};
  bool _isLoadingDescription = true;

  @override
  void initState() {
    super.initState();
    _loadChartData();
    _loadDescription();
  }

  Future<void> _loadChartData() async {
    try {
      final apiService = context.read<CoinGeckoApiService>();
      final history = await apiService.getMarketChart(widget.crypto.id);
      if (mounted) {
        setState(() {
          _priceHistory = history;
          _isLoadingChart = false;
        });
      }
    } on RateLimitException {
      if (mounted) {
        setState(() {
          _chartError = 'rateLimitTitle';
          _isLoadingChart = false;
          _isRateLimited = true;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _chartError = 'errorLoadingChart';
          _isLoadingChart = false;
        });
      }
    }
  }

  Future<void> _loadDescription() async {
    try {
      final apiService = context.read<CoinGeckoApiService>();
      final descriptionMap = await apiService.getCoinDescription(
        widget.crypto.id,
      );
      if (mounted) {
        setState(() {
          _descriptionMap = descriptionMap;
          _isLoadingDescription = false;
        });
      }
    } on RateLimitException {
      if (mounted) {
        setState(() {
          _isLoadingDescription = false;
          _isRateLimited = true;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingDescription = false;
        });
      }
    }
  }

  void _dismissRateLimitBanner() {
    setState(() {
      _isRateLimited = false;
    });
  }

  String _getLocalizedDescription(AppLocalizations l10n) {
    if (_descriptionMap.isEmpty) {
      return _isLoadingDescription ? '' : l10n.noDescriptionAvailable;
    }

    final localeCode = Localizations.localeOf(context).languageCode;

    // 1. Try current locale
    if (_descriptionMap.containsKey(localeCode) &&
        _descriptionMap[localeCode].toString().trim().isNotEmpty) {
      return _descriptionMap[localeCode].toString();
    }

    // 2. Fallback to English
    if (_descriptionMap.containsKey('en') &&
        _descriptionMap['en'].toString().trim().isNotEmpty) {
      return _descriptionMap['en'].toString();
    }

    // 3. Last fallback
    return l10n.noDescriptionAvailable;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final crypto = widget.crypto;
    // Use more decimals for small prices
    final int decimals = crypto.currentPrice < 1 ? 6 : 2;
    final currencyFormatter = NumberFormat.currency(
      symbol: '',
      decimalDigits: decimals,
    );
    final isPositive = crypto.priceChangePercentage24h >= 0;
    final color = isPositive ? Colors.greenAccent : Colors.redAccent;

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        title: Text(l10n.detail),
        centerTitle: true,
        backgroundColor: const Color(0xFF222222),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          BlocBuilder<FavoritesBloc, FavoritesState>(
            builder: (context, state) {
              final isFav = state.favorites.contains(crypto.symbol);
              return IconButton(
                onPressed: () {
                  context.read<FavoritesBloc>().add(
                    ToggleFavorite(crypto.symbol),
                  );
                },
                icon: Icon(
                  isFav ? Icons.star : Icons.star_border,
                  color: isFav ? Colors.yellow : Colors.grey,
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Error banner for rate limit
          if (_isRateLimited)
            ErrorBanner(
              title: l10n.rateLimitTitle,
              subtitle: l10n.rateLimitDataUnavailable,
              onDismiss: _dismissRateLimitBanner,
            ),
          // Main scrollable content
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    // Header: Icon + Name
                    Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white10,
                          ),
                          child: ClipOval(
                            child: Image.network(
                              crypto.image,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(
                                    Icons.currency_bitcoin,
                                    color: Colors.orange,
                                    size: 40,
                                  ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              crypto.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              crypto.symbol,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    // Price Section
                    Text(
                      l10n.currentPrice,
                      style: const TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${currencyFormatter.format(crypto.currentPrice)} US\$',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: color.withValues(alpha: 0.5),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                isPositive
                                    ? Icons.arrow_drop_up
                                    : Icons.arrow_drop_down,
                                color: color,
                              ),
                              Text(
                                '${isPositive ? '+' : ''}${crypto.priceChangePercentage24h.toStringAsFixed(2)}%',
                                style: TextStyle(
                                  color: color,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    // Stats Grid
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      childAspectRatio: 1.6,
                      children: [
                        _buildStatCard(
                          title: l10n.high24h,
                          value:
                              '${currencyFormatter.format(crypto.high24h)} US\$',
                          icon: Icons.trending_up,
                          iconColor: Colors.greenAccent,
                        ),
                        _buildStatCard(
                          title: l10n.low24h,
                          value:
                              '${currencyFormatter.format(crypto.low24h)} US\$',
                          icon: Icons.trending_down,
                          iconColor: Colors.redAccent,
                        ),
                        _buildStatCard(
                          title: l10n.marketCap,
                          value:
                              '${(crypto.marketCap / 1000000000).toStringAsFixed(2)}B US\$',
                          icon: Icons.account_balance_wallet,
                          iconColor: Colors.blueAccent,
                        ),
                        _buildStatCard(
                          title: l10n.volume24h,
                          value:
                              '${(crypto.totalVolume / 1000000).toStringAsFixed(2)}M US\$',
                          icon: Icons.compare_arrows,
                          iconColor: Colors.orangeAccent,
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    // Chart Section
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2C2C2C),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                l10n.priceHistory7d,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: color.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    color: color.withValues(alpha: 0.5),
                                  ),
                                ),
                                child: Text(
                                  '${currencyFormatter.format(crypto.currentPrice)} US\$',
                                  style: TextStyle(
                                    color: color,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            height: 200,
                            child: _buildChart(color, l10n),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Acerca de Section
                    Text(
                      l10n.about,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2D2D2D),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.grey.shade800,
                          width: 1.0,
                        ),
                      ),
                      child: _isLoadingDescription
                          ? const Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.yellow,
                                  ),
                                ),
                              ),
                            )
                          : Text(
                              _getLocalizedDescription(l10n),
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 15,
                                height: 1.5,
                              ),
                            ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChart(Color color, AppLocalizations l10n) {
    if (_isLoadingChart) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.yellow),
      );
    }

    if (_chartError != null || _priceHistory.isEmpty) {
      String errorMessage = l10n.noDataAvailable;
      if (_chartError == 'rateLimitTitle') {
        errorMessage = l10n.rateLimitTitle;
      } else if (_chartError == 'errorLoadingChart') {
        errorMessage = l10n.errorLoadingChart;
      }

      return Center(
        child: Text(errorMessage, style: const TextStyle(color: Colors.grey)),
      );
    }

    final dataMin = _priceHistory.reduce((a, b) => a < b ? a : b);
    final dataMax = _priceHistory.reduce((a, b) => a > b ? a : b);
    final dataRange = dataMax - dataMin;

    // Use 2% padding to match CoinGecko's chart style
    final padding = dataRange * 0.02;
    final minY = dataMin - padding;
    final maxY = dataMax + padding;

    // Calculate appropriate interval for grid lines
    final interval = dataRange > 0 ? dataRange / 4 : dataMin * 0.001;

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: interval,
          getDrawingHorizontalLine: (value) {
            return const FlLine(
              color: Colors.white10,
              strokeWidth: 1,
              dashArray: [5, 5],
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: (_priceHistory.length / 6).ceilToDouble(),
              getTitlesWidget: (value, meta) {
                if (value.toInt() == 0) {
                  return Text(
                    l10n.chartStart,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  );
                }
                if (value.toInt() == _priceHistory.length - 1) {
                  return Text(
                    l10n.chartToday,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 60,
              interval: (maxY - minY) / 3,
              getTitlesWidget: (value, meta) {
                if (value >= 1000) {
                  return Text(
                    '${(value / 1000).toStringAsFixed(1)}K US\$',
                    style: const TextStyle(color: Colors.grey, fontSize: 10),
                  );
                }
                // For values under 1, show more decimals
                final int chartDecimals = value < 1 ? 6 : 2;
                return Text(
                  '${value.toStringAsFixed(chartDecimals)} US\$',
                  style: const TextStyle(color: Colors.grey, fontSize: 10),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: (_priceHistory.length - 1).toDouble(),
        minY: minY,
        maxY: maxY,
        lineBarsData: [
          LineChartBarData(
            spots: _priceHistory
                .asMap()
                .entries
                .map((e) => FlSpot(e.key.toDouble(), e.value))
                .toList(),
            isCurved: true,
            color: color,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  color.withValues(alpha: 0.3),
                  color.withValues(alpha: 0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
