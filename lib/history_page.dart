import 'package:flutter/material.dart';

import 'formatters.dart';
import 'history_insights.dart';
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
    final insightsResult = const HistoryInsights().build(_resetSessions);

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
                itemCount:
                    _resetSessions.length + (insightsResult.isEmpty ? 0 : 1),
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  if (!insightsResult.isEmpty && index == 0) {
                    return HistoryInsightsCard(result: insightsResult);
                  }

                  final sessionIndex = insightsResult.isEmpty
                      ? index
                      : index - 1;
                  return HistorySessionCard(
                    session: _resetSessions[sessionIndex],
                  );
                },
              ),
      ),
    );
  }
}

class HistoryInsightsCard extends StatelessWidget {
  const HistoryInsightsCard({super.key, required this.result});

  final HistoryInsightsResult result;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _showHistoryInsightsSheet(context, result),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Что чаще помогало',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const Text('Подробнее'),
                  const SizedBox(width: 4),
                  const Icon(Icons.chevron_right, size: 20),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void _showHistoryInsightsSheet(
  BuildContext context,
  HistoryInsightsResult result,
) {
  showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (context) {
      return SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          shrinkWrap: true,
          itemCount: result.topStates.length + 2,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            if (index == 0) {
              return Text(
                'Что помогало чаще',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              );
            }
            if (index == 1) {
              return const Text('Чаще всего reset использовался для:');
            }

            final insight = result.topStates[index - 2];
            return HistoryStateInsightTile(insight: insight);
          },
        ),
      );
    },
  );
}

class HistoryStateInsightTile extends StatelessWidget {
  const HistoryStateInsightTile({super.key, required this.insight});

  final HistoryStateInsight insight;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text('${insight.stateTitle} — ${_formatTimes(insight.total)}'),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => _showStateInsightSheet(context, insight),
    );
  }
}

String _formatTimes(int value) {
  if (value % 10 == 1 && value % 100 != 11) {
    return '$value раз';
  }

  if (value % 10 >= 2 &&
      value % 10 <= 4 &&
      (value % 100 < 12 || value % 100 > 14)) {
    return '$value раза';
  }

  return '$value раз';
}

void _showStateInsightSheet(BuildContext context, HistoryStateInsight insight) {
  final hasScenarioDetails = insight.scenarioDetails.isNotEmpty;

  showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (context) {
      return SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          shrinkWrap: true,
          itemCount: hasScenarioDetails
              ? insight.scenarioDetails.length + 2
              : 3,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            if (index == 0) {
              return Text(
                insight.stateTitle,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              );
            }
            if (index == 1) {
              return const Text('Сценарии, которые чаще помогали');
            }
            if (!hasScenarioDetails) {
              return const Text(
                'Пока нет данных по конкретным сценариям. Новые reset-сессии будут сохраняться с детализацией.',
              );
            }

            return HistoryScenarioInsightTile(
              insight: insight.scenarioDetails[index - 2],
            );
          },
        ),
      );
    },
  );
}

class HistoryScenarioInsightTile extends StatelessWidget {
  const HistoryScenarioInsightTile({super.key, required this.insight});

  final HistoryScenarioInsight insight;

  @override
  Widget build(BuildContext context) {
    final shortDescription = insight.shortDescription;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          insight.title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        if (shortDescription != null && shortDescription.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(shortDescription),
        ],
        const SizedBox(height: 4),
        Text(
          'помогло: ${insight.helped} · частично: ${insight.partially} · не помогло: ${insight.notHelped}',
        ),
      ],
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
