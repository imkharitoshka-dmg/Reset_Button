import 'package:flutter/material.dart';

import 'history_page.dart';
import 'reset_scenario.dart';
import 'reset_scenarios_data.dart';
import 'reset_storage_service.dart';
import 'scenario_selection_page.dart';

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
        builder: (context) => ScenarioSelectionPage(
          title: title,
          scenarios: scenarios,
          storageService: widget.storageService,
        ),
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
              style: textTheme.bodyLarge?.copyWith(height: 1.35),
            ),
            const SizedBox(height: 32),
            Text(
              'Что сейчас происходит?',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            for (final cluster in resetClusters) ...[
              _StateSelectionCard(
                title: cluster.title,
                onTap: () => _openScenarioSelection(
                  title: cluster.title,
                  scenarios: scenariosForCluster(cluster),
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
            const SizedBox(height: 12),
            TextButton(
              onPressed: _showClusterHelp,
              child: const Text('Не знаю, что выбрать'),
            ),
          ],
        ),
      ),
    );
  }

  void _showClusterHelp() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: FractionallySizedBox(
            heightFactor: 0.75,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              children: [
                Text(
                  'Как выбрать reset?',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 16),
                const _ClusterHelpRow(
                  hint: 'Накрыл стресс или тревожно',
                  clusterTitle: 'Успокоиться',
                ),
                const _ClusterHelpRow(
                  hint: 'Нет сил или чувствуешь усталость',
                  clusterTitle: 'Восстановиться',
                ),
                const _ClusterHelpRow(
                  hint: 'Слишком много задач или мыслей',
                  clusterTitle: 'Разгрузить голову',
                ),
                const _ClusterHelpRow(
                  hint: 'Сложно начать или удержать внимание',
                  clusterTitle: 'Сфокусироваться',
                ),
                const _ClusterHelpRow(
                  hint:
                      'Был тяжёлый разговор или нужно собраться перед встречей',
                  clusterTitle: 'Переключиться после общения',
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Понятно'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ClusterHelpRow extends StatelessWidget {
  const _ClusterHelpRow({required this.hint, required this.clusterTitle});

  final String hint;
  final String clusterTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text('$hint → $clusterTitle'),
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
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
