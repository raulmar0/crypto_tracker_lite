import 'package:crypto_tracker_lite/logic/crypto_list_bloc.dart';
import 'package:crypto_tracker_lite/widgets/crypto_list_tile.dart';
import 'package:crypto_tracker_lite/widgets/custom_drawer.dart';
import 'package:crypto_tracker_lite/widgets/rate_limit_banner.dart';
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
    context.read<CryptoListBloc>().add(LoadCryptos());
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
              context.read<CryptoListBloc>().add(RetryCryptos());
            },
          ),
        ],
      ),
      body: BlocBuilder<CryptoListBloc, CryptoListState>(
        builder: (context, state) {
          // Check if we should show the rate limit banner
          final bool showRateLimitBanner =
              state is CryptoListError && state.isRateLimited;

          return Column(
            children: [
              // Rate Limit Banner with animation
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: showRateLimitBanner
                    ? RateLimitBanner(
                        key: const ValueKey('rate_limit_banner'),
                        waitSeconds: 7,
                        onRetry: () {
                          context.read<CryptoListBloc>().add(RetryCryptos());
                        },
                      )
                    : const SizedBox.shrink(key: ValueKey('empty')),
              ),
              // Main content
              Expanded(child: _buildContent(state)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildContent(CryptoListState state) {
    if (state is CryptoListLoading || state is CryptoListInitial) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.yellow),
      );
    }

    if (state is CryptoListError && !state.isRateLimited) {
      // Generic error (not rate limit)
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.redAccent, size: 60),
            const SizedBox(height: 16),
            Text(
              state.message,
              style: const TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                context.read<CryptoListBloc>().add(RetryCryptos());
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (state is CryptoListError && state.isRateLimited) {
      // Rate limited - show empty state (banner is shown above)
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.hourglass_empty, color: Colors.orange, size: 60),
            SizedBox(height: 16),
            Text(
              'Esperando para reintentar...',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      );
    }

    if (state is CryptoListLoaded) {
      return RefreshIndicator(
        onRefresh: () async {
          context.read<CryptoListBloc>().add(RetryCryptos());
        },
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
  }
}
