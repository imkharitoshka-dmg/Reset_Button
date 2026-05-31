import 'package:flutter_test/flutter_test.dart';
import 'package:reset_button/history_insights.dart';
import 'package:reset_button/reset_session.dart';

void main() {
  const insights = HistoryInsights();

  test('Returns no insights for empty history', () {
    expect(insights.build(const []).isEmpty, isTrue);
  });

  test('Returns no insights before five sessions', () {
    final result = insights.build([
      _session('1', 'Я тревожусь', 'помогло'),
      _session('2', 'Я тревожусь', 'частично'),
      _session('3', 'Усталость', 'помогло'),
      _session('4', 'Усталость', 'не помогло'),
    ]);

    expect(result.isEmpty, isTrue);
  });

  test('Top states are sorted by usage count, not helped count', () {
    final result = insights.build([
      _session('1', 'Усталость', 'не помогло'),
      _session('2', 'Усталость', 'не помогло'),
      _session('3', 'Усталость', 'частично'),
      _session('4', 'Я тревожусь', 'помогло'),
      _session('5', 'Я тревожусь', 'помогло'),
    ]);

    expect(result.topStates.first.stateTitle, 'Усталость');
    expect(result.topStates.first.total, 3);
  });

  test('Old state titles are normalized for analytics', () {
    final result = insights.build([
      _session('1', 'Я устала', 'помогло'),
      _session('2', 'Я устала', 'частично'),
      _session('3', 'Я эмоционально вымотана', 'помогло'),
      _session('4', 'Я перегружена задачами', 'не помогло'),
      _session('5', 'Я устала от общения', 'помогло'),
    ]);

    expect(result.topStates.first.stateTitle, 'Усталость');
    expect(result.topStates.first.total, 2);
    expect(
      result.topStates.map((state) => state.stateTitle),
      containsAll(['Эмоциональное истощение', 'Усталость от общения']),
    );
  });

  test('Scenario details use variant title and counters', () {
    final result = insights.build([
      _session(
        '1',
        'Я тревожусь',
        'помогло',
        scenarioVariantId: 'anxious-3-pause',
      ),
      _session(
        '2',
        'Я тревожусь',
        'частично',
        scenarioVariantId: 'anxious-3-pause',
      ),
      _session(
        '3',
        'Я тревожусь',
        'не помогло',
        scenarioVariantId: 'anxious-3-next-step',
      ),
      _session('4', 'Усталость', 'помогло'),
      _session('5', 'Усталость', 'не помогло'),
    ]);
    final anxious = result.topStates.first;

    expect(anxious.stateTitle, 'Я тревожусь');
    expect(anxious.scenarioDetails.first.title, '3 минуты паузы');
    expect(anxious.scenarioDetails.first.helped, 1);
    expect(anxious.scenarioDetails.first.partially, 1);
    expect(anxious.scenarioDetails.first.notHelped, 0);
  });

  test(
    'Scenario details include partial-only variants and sort by results',
    () {
      final result = insights.build([
        _session(
          '1',
          'Я тревожусь',
          'частично',
          scenarioVariantId: 'anxious-3-pause',
        ),
        _session(
          '2',
          'Я тревожусь',
          'не помогло',
          scenarioVariantId: 'anxious-3-next-step',
        ),
        _session(
          '3',
          'Я тревожусь',
          'частично',
          scenarioVariantId: 'anxious-3-next-step',
        ),
        _session('4', 'Усталость', 'помогло'),
        _session('5', 'Усталость', 'не помогло'),
      ]);
      final anxious = result.topStates.first;

      expect(anxious.scenarioDetails.first.title, '3 минуты паузы');
      expect(anxious.scenarioDetails.first.helped, 0);
      expect(anxious.scenarioDetails.first.partially, 1);
      expect(anxious.scenarioDetails.first.notHelped, 0);
      expect(anxious.scenarioDetails.last.title, '3 минуты ясности');
    },
  );

  test('State insight keeps empty details when no variant ids are found', () {
    final result = insights.build([
      _session('1', 'Я тревожусь', 'помогло'),
      _session('2', 'Я тревожусь', 'частично'),
      _session('3', 'Я тревожусь', 'не помогло'),
      _session('4', 'Усталость', 'помогло'),
      _session('5', 'Усталость', 'частично'),
    ]);

    expect(result.topStates.first.stateTitle, 'Я тревожусь');
    expect(result.topStates.first.scenarioDetails, isEmpty);
  });

  test(
    'Unknown or missing scenarioVariantId is ignored in scenario details',
    () {
      final result = insights.build([
        _session(
          '1',
          'Я тревожусь',
          'помогло',
          scenarioVariantId: 'unknown-id',
        ),
        _session('2', 'Я тревожусь', 'помогло'),
        _session(
          '3',
          'Я тревожусь',
          'частично',
          scenarioVariantId: 'anxious-3-pause',
        ),
        _session('4', 'Усталость', 'не помогло'),
        _session('5', 'Усталость', 'частично'),
      ]);
      final anxious = result.topStates.first;

      expect(anxious.total, 3);
      expect(anxious.scenarioDetails, hasLength(1));
      expect(anxious.scenarioDetails.single.title, '3 минуты паузы');
    },
  );
}

ResetSession _session(
  String id,
  String stateTitle,
  String result, {
  String? scenarioVariantId,
}) {
  return ResetSession(
    id: id,
    completedAt: DateTime(2026, 5, 17, 12, int.parse(id)),
    stateTitle: stateTitle,
    scenarioTitle: 'Сценарий',
    durationMinutes: 3,
    result: result,
    scenarioVariantId: scenarioVariantId,
  );
}
