import 'package:crypto_tracker_lite/services/local_storage_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Events
abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

class LoadSettings extends SettingsEvent {}

class ChangeLocale extends SettingsEvent {
  final Locale locale;
  const ChangeLocale(this.locale);

  @override
  List<Object?> get props => [locale];
}

// State
class SettingsState extends Equatable {
  final Locale locale;
  final String currency;

  const SettingsState({
    this.locale = const Locale('en'),
    this.currency = 'usd',
  });

  SettingsState copyWith({Locale? locale, String? currency}) {
    return SettingsState(
      locale: locale ?? this.locale,
      currency: currency ?? this.currency,
    );
  }

  @override
  List<Object?> get props => [locale, currency];
}

// Bloc
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final LocalStorageService localStorage;

  SettingsBloc(this.localStorage) : super(const SettingsState()) {
    on<LoadSettings>(_onLoadSettings);
    on<ChangeLocale>(_onChangeLocale);
  }

  void _onLoadSettings(LoadSettings event, Emitter<SettingsState> emit) {
    final savedLocaleCode = localStorage.getLocale();

    Locale locale;
    if (savedLocaleCode != null) {
      locale = Locale(savedLocaleCode);
    } else {
      // Default to English if not set
      locale = const Locale('en');
    }

    emit(state.copyWith(locale: locale, currency: 'usd'));
  }

  Future<void> _onChangeLocale(
    ChangeLocale event,
    Emitter<SettingsState> emit,
  ) async {
    await localStorage.saveLocale(event.locale.languageCode);
    emit(state.copyWith(locale: event.locale));
  }
}
