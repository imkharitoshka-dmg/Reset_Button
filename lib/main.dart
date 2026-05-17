import 'package:flutter/material.dart';

import 'reset_session.dart';
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

    await widget.storageService.saveCompletedResetSession(
      dateKey: todayKey,
      completedAt: _today,
    );
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
      appBar: AppBar(
        title: const Text('Reset Button'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (context) =>
                      HistoryPage(storageService: widget.storageService),
                ),
              );
            },
            tooltip: 'История',
            icon: const Icon(Icons.history),
          ),
        ],
      ),
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

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key, ResetStorageService? storageService})
    : storageService = storageService ?? const ResetStorageService();

  final ResetStorageService storageService;

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<ResetSession> _resetSessions = [];

  @override
  void initState() {
    super.initState();
    _loadResetSessions();
  }

  Future<void> _loadResetSessions() async {
    final resetSessions = await widget.storageService.loadResetSessions();

    if (!mounted) {
      return;
    }

    setState(() {
      _resetSessions = resetSessions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('История')),
      body: SafeArea(
        child: _resetSessions.isEmpty
            ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text(
                    'История пока пустая. Выбери состояние и пройди первый reset.',
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: _resetSessions.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return HistorySessionCard(session: _resetSessions[index]);
                },
              ),
      ),
    );
  }
}

class HistorySessionCard extends StatelessWidget {
  const HistorySessionCard({super.key, required this.session});

  final ResetSession session;

  @override
  Widget build(BuildContext context) {
    final note = session.note;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              formatRussianDateTime(session.completedAt),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            _HistoryValue(label: 'Состояние', value: session.state),
            _HistoryValue(label: 'Сценарий', value: session.scenarioTitle),
            _HistoryValue(label: 'Длительность', value: session.duration),
            _HistoryValue(label: 'Результат', value: session.result),
            if (note != null && note.isNotEmpty)
              _HistoryValue(label: 'Заметка', value: note),
          ],
        ),
      ),
    );
  }
}

class _HistoryValue extends StatelessWidget {
  const _HistoryValue({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text('$label: $value'),
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

String formatRussianDateTime(DateTime date) {
  final hour = date.hour.toString().padLeft(2, '0');
  final minute = date.minute.toString().padLeft(2, '0');

  return '${formatRussianDate(date)}, $hour:$minute';
}
