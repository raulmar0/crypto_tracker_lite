import 'package:crypto_tracker_lite/logic/favorites_cubit.dart';
import 'package:crypto_tracker_lite/models/crypto_model.dart';
import 'package:crypto_tracker_lite/services/coingecko_api_service.dart';
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

  @override
  void initState() {
    super.initState();
    _loadChartData();
  }

  Future<void> _loadChartData() async {
    try {
      final apiService = context.read<CoinGeckoApiService>();
      final history = await apiService.getMarketChart(widget.crypto.id);
      setState(() {
        _priceHistory = history;
        _isLoadingChart = false;
      });
    } catch (e) {
      setState(() {
        _chartError = 'Error loading chart';
        _isLoadingChart = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final crypto = widget.crypto;
    final currencyFormatter = NumberFormat.simpleCurrency(decimalDigits: 2);
    final isPositive = crypto.priceChangePercentage24h >= 0;
    final color = isPositive ? Colors.greenAccent : Colors.redAccent;

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        title: const Text('Detalle'),
        centerTitle: true,
        backgroundColor: const Color(0xFF222222),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          BlocBuilder<FavoritesCubit, List<String>>(
            builder: (context, favorites) {
              final isFav = favorites.contains(crypto.symbol);
              return IconButton(
                onPressed: () {
                  context.read<FavoritesCubit>().toggleFavorite(crypto.symbol);
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
      body: SingleChildScrollView(
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
              const Text(
                'Precio actual',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    currencyFormatter.format(crypto.currentPrice),
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
                      border: Border.all(color: color.withValues(alpha: 0.5)),
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
                    title: 'Máximo 24h',
                    value: currencyFormatter.format(crypto.high24h),
                    icon: Icons.trending_up,
                    iconColor: Colors.greenAccent,
                  ),
                  _buildStatCard(
                    title: 'Mínimo 24h',
                    value: currencyFormatter.format(crypto.low24h),
                    icon: Icons.trending_down,
                    iconColor: Colors.redAccent,
                  ),
                  _buildStatCard(
                    title: 'Capitalización',
                    value:
                        '\$${(crypto.marketCap / 1000000000).toStringAsFixed(2)}B',
                    icon: Icons.account_balance_wallet,
                    iconColor: Colors.blueAccent,
                  ),
                  _buildStatCard(
                    title: 'Volumen 24h',
                    value:
                        '\$${(crypto.totalVolume / 1000000).toStringAsFixed(2)}M',
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
                        const Text(
                          'Precio histórico (7 días)',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
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
                            currencyFormatter.format(crypto.currentPrice),
                            style: TextStyle(
                              color: color,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(height: 200, child: _buildChart(color)),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChart(Color color) {
    if (_isLoadingChart) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.yellow),
      );
    }

    if (_chartError != null || _priceHistory.isEmpty) {
      return Center(
        child: Text(
          _chartError ?? 'No data available',
          style: const TextStyle(color: Colors.grey),
        ),
      );
    }

    final minY = _priceHistory.reduce((a, b) => a < b ? a : b) * 0.98;
    final maxY = _priceHistory.reduce((a, b) => a > b ? a : b) * 1.02;

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: (maxY - minY) / 4,
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
                  return const Text(
                    'Inicio',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  );
                }
                if (value.toInt() == _priceHistory.length - 1) {
                  return const Text(
                    'Hoy',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 50,
              interval: (maxY - minY) / 3,
              getTitlesWidget: (value, meta) {
                if (value >= 1000) {
                  return Text(
                    '\$${(value / 1000).toStringAsFixed(1)}K',
                    style: const TextStyle(color: Colors.grey, fontSize: 10),
                  );
                }
                return Text(
                  '\$${value.toStringAsFixed(2)}',
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
              Text(
                title,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
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
