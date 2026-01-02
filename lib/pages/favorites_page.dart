import 'package:crypto_tracker_lite/l10n/app_localizations.dart';
import 'package:crypto_tracker_lite/logic/crypto_list_bloc.dart';
import 'package:crypto_tracker_lite/logic/favorites_bloc.dart';
import 'package:crypto_tracker_lite/widgets/crypto_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.favorites),
        centerTitle: true,
        backgroundColor: const Color(0xFF222222),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocBuilder<FavoritesBloc, FavoritesState>(
        builder: (context, favoritesState) {
          return BlocBuilder<CryptoListBloc, CryptoListState>(
            builder: (context, cryptoState) {
              if (cryptoState is! CryptoListLoaded) {
                return Center(
                  child: Text(
                    l10n.loadDataFirst,
                    style: const TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                );
              }

              final favoriteCryptos = cryptoState.cryptos
                  .where(
                    (crypto) =>
                        favoritesState.favorites.contains(crypto.symbol),
                  )
                  .toList();

              if (favoriteCryptos.isEmpty) {
                return Center(
                  child: Text(
                    l10n.noFavoritesYet,
                    style: const TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                );
              }

              return ListView.separated(
                itemCount: favoriteCryptos.length,
                separatorBuilder: (context, index) =>
                    const Divider(color: Colors.white10, height: 1),
                itemBuilder: (context, index) {
                  return CryptoListTile(crypto: favoriteCryptos[index]);
                },
              );
            },
          );
        },
      ),
    );
  }
}
