import 'package:flutter/material.dart';

import 'formatters.dart';
import 'reset_scenario.dart';
import 'reset_storage_service.dart';
import 'scenario_progress_page.dart';

class ScenarioSelectionPage extends StatelessWidget {
  const ScenarioSelectionPage({
    super.key,
    required this.title,
    required this.scenarios,
    ResetStorageService? storageService,
  }) : storageService = storageService ?? const ResetStorageService();

  final String title;
  final List<ResetScenario> scenarios;
  final ResetStorageService storageService;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.all(20),
          itemCount: scenarios.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            return ScenarioSelectionCard(
              scenario: scenarios[index],
              storageService: storageService,
            );
          },
        ),
      ),
    );
  }
}

class ScenarioSelectionCard extends StatelessWidget {
  const ScenarioSelectionCard({
    super.key,
    required this.scenario,
    required this.storageService,
  });

  final ResetScenario scenario;
  final ResetStorageService storageService;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(18),
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
            Text(
              formatDurationMinutes(scenario.durationMinutes),
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              scenario.description,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(height: 1.35),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (context) => ScenarioProgressPage(
                      scenario: scenario,
                      storageService: storageService,
                    ),
                  ),
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
