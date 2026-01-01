import 'package:crypto_tracker_lite/models/crypto_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CryptoListTile extends StatelessWidget {
  final CryptoModel crypto;

  const CryptoListTile({super.key, required this.crypto});

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.simpleCurrency(decimalDigits: 2);

    final isPositive = crypto.changePercentage >= 0;
    final color = isPositive ? Colors.greenAccent : Colors.redAccent;

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
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  crypto.symbol,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
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
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
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
          Icon(Icons.star_border, color: Colors.grey),
        ],
      ),
    );
  }
}
