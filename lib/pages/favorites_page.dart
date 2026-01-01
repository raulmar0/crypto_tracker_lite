import 'package:crypto_tracker_lite/logic/favorites_cubit.dart';
import 'package:crypto_tracker_lite/models/crypto_model.dart';
import 'package:crypto_tracker_lite/widgets/crypto_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// MOCK DATA IMPORT (Duplicated temporarily until we have a repository)
// Ideally this should come from a central repository or provider
final List<CryptoModel> _allCryptos = [
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

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritos'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocBuilder<FavoritesCubit, List<String>>(
        builder: (context, favoriteIds) {
          if (favoriteIds.isEmpty) {
            return const Center(
              child: Text(
                'No tienes favoritos aún',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            );
          }

          // Filter cryptos based on favorite IDs (symbols)
          final favoriteCryptos = _allCryptos
              .where((crypto) => favoriteIds.contains(crypto.symbol))
              .toList();

          return ListView.separated(
            itemCount: favoriteCryptos.length,
            separatorBuilder: (context, index) =>
                const Divider(color: Colors.white10, height: 1),
            itemBuilder: (context, index) {
              return CryptoListTile(crypto: favoriteCryptos[index]);
            },
          );
        },
      ),
    );
  }
}
