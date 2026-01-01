import 'package:crypto_tracker_lite/logic/favorites_cubit.dart';
import 'package:crypto_tracker_lite/models/crypto_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class CryptoListTile extends StatelessWidget {
  final CryptoModel crypto;

  const CryptoListTile({super.key, required this.crypto});

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.simpleCurrency(decimalDigits: 2);

    final isPositive = crypto.changePercentage >= 0;
    final color = isPositive ? Colors.greenAccent : Colors.redAccent;

    return BlocBuilder<FavoritesCubit, List<String>>(
      builder: (context, favorites) {
        final isFavorite = favorites.contains(crypto.symbol);
        final textColor = isFavorite ? Colors.yellow : Colors.white;
        final subTextColor = isFavorite ? Colors.yellow : Colors.grey;
        final iconBorderColor = isFavorite ? Colors.yellow : Colors.transparent;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Row(
            children: [
              // Icono
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white10, // Placeholder background
                  border: Border.all(
                    color: iconBorderColor,
                    width: isFavorite ? 2.0 : 0.0,
                  ),
                ),
                // Usamos un Icon por ahora si no hay URL real funcional,
                // o podríamos usar Image.network con errorBuilder
                child: const Icon(
                  Icons.currency_bitcoin,
                  color: Colors.orange,
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),
              // Nombre y Símbolo
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      crypto.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    Text(
                      crypto.symbol,
                      style: TextStyle(fontSize: 14, color: subTextColor),
                    ),
                  ],
                ),
              ),
              // Precio y Porcentaje
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    currencyFormatter.format(crypto.price),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  Text(
                    '${isPositive ? '+' : ''}${crypto.changePercentage.toStringAsFixed(2)}%',
                    style: TextStyle(fontSize: 14, color: color),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              // Estrella Favorito
              GestureDetector(
                onTap: () {
                  context.read<FavoritesCubit>().toggleFavorite(crypto.symbol);
                },
                child: Icon(
                  isFavorite ? Icons.star : Icons.star_border,
                  color: isFavorite ? Colors.yellow : Colors.grey,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
