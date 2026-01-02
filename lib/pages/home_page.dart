import 'package:crypto_tracker_lite/l10n/app_localizations.dart';
import 'package:crypto_tracker_lite/logic/crypto_list_bloc.dart';
import 'package:crypto_tracker_lite/logic/settings_bloc.dart';
import 'package:crypto_tracker_lite/pages/error_page.dart';
import 'package:crypto_tracker_lite/widgets/crypto_list_tile.dart';
import 'package:crypto_tracker_lite/widgets/custom_drawer.dart';
import 'package:crypto_tracker_lite/widgets/error_banner.dart';
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
    // Load cryptos on startup with current currency
    final currency = context.read<SettingsBloc>().state.currency;
    context.read<CryptoListBloc>().add(LoadCryptos(currency: currency));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        backgroundColor: const Color(0xFF222222),
        elevation: 0,
        centerTitle: true,
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<CryptoListBloc>().add(RetryCryptos());
            },
          ),
        ],
      ),
      body: BlocListener<SettingsBloc, SettingsState>(
        listenWhen: (previous, current) =>
            previous.currency != current.currency,
        listener: (context, state) {
          // Reload with new currency
          context.read<CryptoListBloc>().add(
            LoadCryptos(currency: state.currency),
          );
        },
        child: BlocBuilder<CryptoListBloc, CryptoListState>(
          builder: (context, state) {
            if (state is CryptoListLoading || state is CryptoListInitial) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.yellow),
              );
            }

            if (state is CryptoListError) {
              // No cached data - show full error page
              return ErrorPage(
                onRetry: () {
                  context.read<CryptoListBloc>().add(RetryCryptos());
                },
              );
            }

            if (state is CryptoListLoaded) {
              return Column(
                children: [
                  // Error banner (transient state)
                  if (state.hasError)
                    ErrorBanner(
                      onDismiss: () {
                        context.read<CryptoListBloc>().add(DismissError());
                      },
                    ),
                  // List of cryptos
                  Expanded(
                    child: RefreshIndicator(
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
                    ),
                  ),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
