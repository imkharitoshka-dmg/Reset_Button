import 'package:flutter/material.dart';

import 'reset_storage_service.dart';

void main() {
  runApp(const ResetButtonApp());
}

class ResetButtonApp extends StatelessWidget {
  const ResetButtonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reset Button',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2F6F62)),
        useMaterial3: true,
      ),
      home: const ResetHomePage(),
    );
  }
}

class ResetHomePage extends StatefulWidget {
  const ResetHomePage({
    super.key,
    this.today,
    ResetStorageService? storageService,
  }) : storageService = storageService ?? const ResetStorageService();

  final DateTime? today;
  final ResetStorageService storageService;

  @override
  State<ResetHomePage> createState() => _ResetHomePageState();
}

class _ResetHomePageState extends State<ResetHomePage> {
  Set<String> _resetSessionDates = {};

  @override
  void initState() {
    super.initState();
    _loadResetSessionDates();
  }

  Future<void> _loadResetSessionDates() async {
    final resetSessionDates = await widget.storageService
        .loadResetSessionDates();

    if (!mounted) {
      return;
    }

    setState(() {
      _resetSessionDates = resetSessionDates;
    });
  }

  DateTime get _today => widget.today ?? DateTime.now();

  String get _todayKey {
    final today = _today;
    final month = today.month.toString().padLeft(2, '0');
    final day = today.day.toString().padLeft(2, '0');

    return '${today.year}-$month-$day';
  }

  bool get _isResetDone => _resetSessionDates.contains(_todayKey);

  Future<void> _completeReset() async {
    final todayKey = _todayKey;

    setState(() {
      _resetSessionDates = {..._resetSessionDates, todayKey};
    });

    await widget.storageService.saveCompletedResetSession(todayKey);
  }

  Future<void> _undoReset() async {
    final todayKey = _todayKey;

    setState(() {
      _resetSessionDates = {..._resetSessionDates}..remove(todayKey);
    });

    await widget.storageService.removeResetSession(todayKey);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final statusText = _isResetDone
        ? 'Сброс выполнен. Можно продолжать спокойно.'
        : 'Один простой экран, чтобы начать день заново.';
    final dateText = formatRussianDate(_today);

    return Scaffold(
      appBar: AppBar(title: const Text('Reset Button')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Text(
                'Кнопка сброса',
                textAlign: TextAlign.center,
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                dateText,
                textAlign: TextAlign.center,
                style: textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              Text(
                statusText,
                textAlign: TextAlign.center,
                style: textTheme.bodyLarge,
              ),
              const SizedBox(height: 32),
              FilledButton(
                onPressed: _isResetDone ? null : _completeReset,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                ),
                child: const Text('Сбросить'),
              ),
              if (_isResetDone) ...[
                const SizedBox(height: 12),
                TextButton(
                  onPressed: _undoReset,
                  child: const Text('Отменить'),
                ),
              ],
              const Spacer(),
              Text(
                'Работает локально на телефоне.',
                textAlign: TextAlign.center,
                style: textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String formatRussianDate(DateTime date) {
  const monthNames = [
    'января',
    'февраля',
    'марта',
    'апреля',
    'мая',
    'июня',
    'июля',
    'августа',
    'сентября',
    'октября',
    'ноября',
    'декабря',
  ];

  return '${date.day} ${monthNames[date.month - 1]} ${date.year}';
}
