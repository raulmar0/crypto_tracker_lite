import 'package:crypto_tracker_lite/data/mock_data.dart';
import 'package:crypto_tracker_lite/logic/favorites_cubit.dart';
import 'package:crypto_tracker_lite/widgets/crypto_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
          final favoriteCryptos = MockData.cryptos
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
