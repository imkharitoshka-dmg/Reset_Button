import 'package:flutter/material.dart';

import 'reset_scenario.dart';
import 'reset_scenarios_data.dart';
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
  const ResetHomePage({super.key, ResetStorageService? storageService})
    : storageService = storageService ?? const ResetStorageService();

  final ResetStorageService storageService;

  @override
  State<ResetHomePage> createState() => _ResetHomePageState();
}

class _ResetHomePageState extends State<ResetHomePage> {
  void _openScenarioSelection({
    required String title,
    required List<ResetScenario> scenarios,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) =>
            ScenarioSelectionPage(title: title, scenarios: scenarios),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

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
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text(
              'Reset Button',
              style: textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Короткие сценарии, чтобы вернуться в спокойствие и фокус',
              style: textTheme.bodyLarge,
            ),
            const SizedBox(height: 32),
            Text(
              'Что сейчас происходит?',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            for (final stateTitle in resetStateTitles) ...[
              _StateSelectionCard(
                title: stateTitle,
                onTap: () => _openScenarioSelection(
                  title: stateTitle,
                  scenarios: scenariosForState(stateTitle),
                ),
              ),
              const SizedBox(height: 12),
            ],
            const SizedBox(height: 8),
            FilledButton(
              onPressed: () => _openScenarioSelection(
                title: quickResetScenario.stateTitle,
                scenarios: const [quickResetScenario],
              ),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text('Быстрый reset на 3 минуты'),
            ),
          ],
        ),
      ),
    );
  }
}

class _StateSelectionCard extends StatelessWidget {
  const _StateSelectionCard({required this.title, required this.onTap});

  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}

class ScenarioSelectionPage extends StatelessWidget {
  const ScenarioSelectionPage({
    super.key,
    required this.title,
    required this.scenarios,
  });

  final String title;
  final List<ResetScenario> scenarios;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: scenarios.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            return ScenarioSelectionCard(scenario: scenarios[index]);
          },
        ),
      ),
    );
  }
}

class ScenarioSelectionCard extends StatelessWidget {
  const ScenarioSelectionCard({super.key, required this.scenario});

  final ResetScenario scenario;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              scenario.title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(formatDurationMinutes(scenario.durationMinutes)),
            const SizedBox(height: 8),
            Text(scenario.description),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    const SnackBar(content: Text('Сценарий выбран')),
                  );
              },
              child: const Text('Начать'),
            ),
          ],
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

String formatDurationMinutes(int minutes) {
  if (minutes == 1) {
    return '1 минута';
  }

  if (minutes >= 2 && minutes <= 4) {
    return '$minutes минуты';
  }

  return '$minutes минут';
}
