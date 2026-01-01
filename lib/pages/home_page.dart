import 'package:crypto_tracker_lite/models/crypto_model.dart';
import 'package:crypto_tracker_lite/widgets/crypto_list_tile.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<CryptoModel> _cryptos = [
    CryptoModel(
      name: 'Bitcoin',
      symbol: 'BTC',
      price: 87729.00,
      changePercentage: 0.15,
      iconUrl: '',
      isFavorite: true,
    ),
    CryptoModel(
      name: 'Ethereum',
      symbol: 'ETH',
      price: 2943.84,
      changePercentage: 0.95,
      iconUrl: '',
      isFavorite: true,
    ),
    CryptoModel(
      name: 'Tether',
      symbol: 'USDT',
      price: 0.999746,
      changePercentage: -0.02,
      iconUrl: '',
      isFavorite: true,
    ),
    CryptoModel(
      name: 'XRP',
      symbol: 'XRP',
      price: 2.20,
      changePercentage: -1.44,
      iconUrl: '',
      isFavorite: true,
    ),
    CryptoModel(
      name: 'BNB',
      symbol: 'BNB',
      price: 860.50,
      changePercentage: 0.08,
      iconUrl: '',
      isFavorite: true,
    ),
    CryptoModel(
      name: 'Solana',
      symbol: 'SOL',
      price: 139.62,
      changePercentage: 2.01,
      iconUrl: '',
      isFavorite: true,
    ),
    CryptoModel(
      name: 'USDC',
      symbol: 'USDC',
      price: 0.999772,
      changePercentage: 0.01,
      iconUrl: '',
      isFavorite: true,
    ),
    CryptoModel(
      name: 'TRON',
      symbol: 'TRX',
      price: 0.274685,
      changePercentage: 0.62,
      iconUrl: '',
      isFavorite: true,
    ),
    CryptoModel(
      name: 'Lido Staked Ether',
      symbol: 'STETH',
      price: 2941.56,
      changePercentage: 0.90,
      iconUrl: '',
      isFavorite: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('CryptoTracker Lite'),
        leading: IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
        actions: [
          IconButton(icon: const Icon(Icons.more_horiz), onPressed: () {}),
        ],
      ),
      body: ListView.separated(
        itemCount: _cryptos.length,
        separatorBuilder: (context, index) =>
            const Divider(color: Colors.white10, height: 1),
        itemBuilder: (context, index) {
          final crypto = _cryptos[index];
          return CryptoListTile(crypto: crypto);
        },
      ),
    );
  }
}
