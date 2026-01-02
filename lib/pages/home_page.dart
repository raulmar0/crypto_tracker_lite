import 'package:crypto_tracker_lite/data/mock_data.dart';
import 'package:crypto_tracker_lite/models/crypto_model.dart';
import 'package:crypto_tracker_lite/widgets/crypto_list_tile.dart';
import 'package:crypto_tracker_lite/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<CryptoModel> _cryptos = MockData.cryptos;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('CryptoTracker Lite'),
        // leading is automatically handled by Scaffold when drawer is present
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
