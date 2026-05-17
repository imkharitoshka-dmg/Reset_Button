import 'package:flutter/material.dart';

import 'formatters.dart';
import 'reset_scenario.dart';
import 'reset_session.dart';
import 'reset_storage_service.dart';

class ScenarioProgressPage extends StatefulWidget {
  const ScenarioProgressPage({
    super.key,
    required this.scenario,
    ResetStorageService? storageService,
  }) : storageService = storageService ?? const ResetStorageService();

  final ResetScenario scenario;
  final ResetStorageService storageService;

  @override
  State<ScenarioProgressPage> createState() => _ScenarioProgressPageState();
}

class _ScenarioProgressPageState extends State<ScenarioProgressPage> {
  late final List<bool> _completedSteps;
  final _noteController = TextEditingController();
  String _result = 'Да, помогло';

  @override
  void initState() {
    super.initState();
    _completedSteps = List.filled(widget.scenario.steps.length, false);
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _finishScenario() async {
    final note = _noteController.text.trim();
    final completedAt = DateTime.now();

    await widget.storageService.saveResetSession(
      ResetSession(
        id: '${widget.scenario.id}-${completedAt.microsecondsSinceEpoch}',
        completedAt: completedAt,
        stateTitle: widget.scenario.stateTitle,
        scenarioTitle: widget.scenario.title,
        durationMinutes: widget.scenario.durationMinutes,
        result: _storageResult,
        note: note.isEmpty ? null : note,
      ),
    );

    if (!mounted) {
      return;
    }

    Navigator.of(context).popUntil((route) => route.isFirst);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('Сессия сохранена')));
  }

  void _setResult(String value) {
    setState(() {
      _result = value;
    });
  }

  String get _storageResult {
    return switch (_result) {
      'Да, помогло' => 'помогло',
      'Частично' => 'частично',
      'Нет' => 'не помогло',
      _ => _result,
    };
  }

  @override
  Widget build(BuildContext context) {
    final scenario = widget.scenario;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text(scenario.title)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              scenario.title,
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(scenario.stateTitle, style: textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              formatDurationMinutes(scenario.durationMinutes),
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              scenario.description,
              style: textTheme.bodyMedium?.copyWith(height: 1.35),
            ),
            const SizedBox(height: 24),
            for (var index = 0; index < scenario.steps.length; index++)
              CheckboxListTile(
                value: _completedSteps[index],
                onChanged: (value) {
                  setState(() {
                    _completedSteps[index] = value ?? false;
                  });
                },
                title: Text(scenario.steps[index]),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                visualDensity: VisualDensity.standard,
              ),
            const SizedBox(height: 24),
            Text(
              'Стало немного легче?',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final result in ['Да, помогло', 'Частично', 'Нет'])
                  ChoiceChip(
                    label: Text(result),
                    selected: _result == result,
                    onSelected: (_) => _setResult(result),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _noteController,
              minLines: 2,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Заметка после reset',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _finishScenario,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Завершить'),
            ),
          ],
        ),
      ),
    );
  }
}
