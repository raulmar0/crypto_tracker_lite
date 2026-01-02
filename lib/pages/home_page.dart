import 'package:crypto_tracker_lite/logic/crypto_list_cubit.dart';
import 'package:crypto_tracker_lite/pages/error_page.dart';
import 'package:crypto_tracker_lite/widgets/crypto_list_tile.dart';
import 'package:crypto_tracker_lite/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Load cryptos on startup
    context.read<CryptoListCubit>().loadCryptos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        backgroundColor: const Color(0xFF222222),
        elevation: 0,
        centerTitle: true,
        title: const Text('CryptoTracker Lite'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<CryptoListCubit>().retry();
            },
          ),
        ],
      ),
      body: BlocBuilder<CryptoListCubit, CryptoListState>(
        builder: (context, state) {
          if (state is CryptoListLoading || state is CryptoListInitial) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.yellow),
            );
          }

          if (state is CryptoListError) {
            return ErrorPage(
              onRetry: () {
                context.read<CryptoListCubit>().retry();
              },
            );
          }

          if (state is CryptoListLoaded) {
            return RefreshIndicator(
              onRefresh: () => context.read<CryptoListCubit>().retry(),
              color: Colors.yellow,
              child: ListView.separated(
                itemCount: state.cryptos.length,
                separatorBuilder: (context, index) =>
                    const Divider(color: Colors.white10, height: 1),
                itemBuilder: (context, index) {
                  final crypto = state.cryptos[index];
                  return CryptoListTile(crypto: crypto);
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
