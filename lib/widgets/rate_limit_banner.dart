import 'dart:async';
import 'package:flutter/material.dart';

class RateLimitBanner extends StatefulWidget {
  final VoidCallback onRetry;
  final int waitSeconds;

  const RateLimitBanner({
    super.key,
    required this.onRetry,
    this.waitSeconds = 7,
  });

  @override
  State<RateLimitBanner> createState() => _RateLimitBannerState();
}

class _RateLimitBannerState extends State<RateLimitBanner> {
  late int _remainingSeconds;
  Timer? _timer;
  bool _canRetry = false;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.waitSeconds;
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _canRetry = true;
          timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.orange.shade800.withValues(alpha: 0.9),
            Colors.orange.shade600.withValues(alpha: 0.9),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Límite de API alcanzado',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _canRetry
                          ? '¡Listo para reintentar!'
                          : 'Espera $_remainingSeconds segundos...',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: _canRetry
                  ? 1.0
                  : 1 - (_remainingSeconds / widget.waitSeconds),
              backgroundColor: Colors.white.withValues(alpha: 0.3),
              valueColor: AlwaysStoppedAnimation<Color>(
                _canRetry ? Colors.greenAccent : Colors.white,
              ),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 16),
          // Retry button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _canRetry ? widget.onRetry : null,
              icon: Icon(
                Icons.refresh,
                color: _canRetry ? Colors.orange.shade800 : Colors.grey,
              ),
              label: Text(
                _canRetry ? 'Reintentar ahora' : 'Esperando...',
                style: TextStyle(
                  color: _canRetry ? Colors.orange.shade800 : Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _canRetry
                    ? Colors.white
                    : Colors.white.withValues(alpha: 0.5),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
