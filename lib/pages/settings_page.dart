import 'package:crypto_tracker_lite/logic/settings_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crypto_tracker_lite/l10n/app_localizations.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        title: Text(l10n.settings),
        backgroundColor: const Color(0xFF222222),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _buildSectionHeader(l10n.language),
              const SizedBox(height: 10),
              _buildLanguageSelector(context, state, l10n),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.grey,
        fontSize: 14,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildLanguageSelector(
    BuildContext context,
    SettingsState state,
    AppLocalizations l10n,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          _buildRadioItem(
            context: context,
            title: l10n.spanish,
            value: 'es',
            groupValue: state.locale.languageCode,
            onChanged: (val) {
              context.read<SettingsBloc>().add(
                const ChangeLocale(Locale('es')),
              );
            },
            isFirst: true,
          ),
          _buildDivider(),
          _buildRadioItem(
            context: context,
            title: l10n.english,
            value: 'en',
            groupValue: state.locale.languageCode,
            onChanged: (val) {
              context.read<SettingsBloc>().add(
                const ChangeLocale(Locale('en')),
              );
            },
          ),
          _buildDivider(),
          _buildRadioItem(
            context: context,
            title: l10n.french,
            value: 'fr',
            groupValue: state.locale.languageCode,
            onChanged: (val) {
              context.read<SettingsBloc>().add(
                const ChangeLocale(Locale('fr')),
              );
            },
          ),
          _buildDivider(),
          _buildRadioItem(
            context: context,
            title: l10n.korean,
            value: 'ko',
            groupValue: state.locale.languageCode,
            onChanged: (val) {
              context.read<SettingsBloc>().add(
                const ChangeLocale(Locale('ko')),
              );
            },
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildRadioItem({
    required BuildContext context,
    required String title,
    required String value,
    required String groupValue,
    required Function(String?) onChanged,
    bool isFirst = false,
    bool isLast = false,
  }) {
    final isSelected = value == groupValue;
    return InkWell(
      onTap: () => onChanged(value),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(isFirst ? 15 : 0),
        topRight: Radius.circular(isFirst ? 15 : 0),
        bottomLeft: Radius.circular(isLast ? 15 : 0),
        bottomRight: Radius.circular(isLast ? 15 : 0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (isSelected)
              const Icon(Icons.check, color: Colors.yellow, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(color: Colors.white.withOpacity(0.1), height: 1);
  }
}
