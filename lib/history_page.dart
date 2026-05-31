import 'package:flutter/material.dart';

import 'formatters.dart';
import 'reset_scenarios_data.dart';
import 'reset_session.dart';
import 'reset_storage_service.dart';

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
                    'История пока пустая. Выбери состояние и пройди первый сброс.',
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.all(20),
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
    final scenarioVariant = scenarioVariantById(session.scenarioVariantId);
    final scenarioTitle = scenarioVariant?.title ?? session.scenarioTitle;
    final scenarioDescription = scenarioVariant?.shortDescription;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              formatRussianDateTime(session.completedAt),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            _HistoryValue(label: 'Состояние', value: session.state),
            _HistoryValue(label: 'Сценарий', value: scenarioTitle),
            if (scenarioDescription != null && scenarioDescription.isNotEmpty)
              _HistoryValue(label: 'Описание', value: scenarioDescription),
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
