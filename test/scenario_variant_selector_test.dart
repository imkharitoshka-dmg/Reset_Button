import 'package:flutter_test/flutter_test.dart';
import 'package:reset_button/reset_scenario.dart';
import 'package:reset_button/reset_session.dart';
import 'package:reset_button/scenario_variant_selector.dart';

void main() {
  const selector = ScenarioVariantSelector();

  test('Cold start returns default variant', () {
    final selected = selector.select(
      scenario: _scenario(),
      history: const [],
      stateTitle: 'Состояние',
      durationMinutes: 3,
    );

    expect(selected.id, 'variant_1');
  });

  test('Does not return last used variant when alternatives exist', () {
    final selected = selector.select(
      scenario: _scenario(),
      history: [_session('variant_1', 3, 'помогло')],
      stateTitle: 'Состояние',
      durationMinutes: 3,
    );

    expect(selected.id, isNot('variant_1'));
  });

  test('Helped result ranks above a variant without successful results', () {
    final selected = selector.select(
      scenario: _scenario(),
      history: [
        _session('variant_2', 2, 'помогло'),
        _session('variant_3', 3, 'не помогло'),
      ],
      stateTitle: 'Состояние',
      durationMinutes: 3,
    );

    expect(selected.id, 'variant_2');
  });

  test(
    'Partially result ranks below helped and above no successful result',
    () {
      final partiallySelected = selector.select(
        scenario: _scenario(),
        history: [
          _session('variant_2', 2, 'частично'),
          _session('variant_3', 3, 'не помогло'),
        ],
        stateTitle: 'Состояние',
        durationMinutes: 3,
      );
      final helpedSelected = selector.select(
        scenario: _scenario(),
        history: [
          _session('variant_2', 2, 'частично'),
          _session('variant_1', 1, 'помогло'),
          _session('variant_3', 3, 'не помогло'),
        ],
        stateTitle: 'Состояние',
        durationMinutes: 3,
      );

      expect(partiallySelected.id, 'variant_2');
      expect(helpedSelected.id, 'variant_1');
    },
  );

  test('Not helped does not add positive help rate', () {
    final selected = selector.select(
      scenario: _scenario(),
      history: [
        _session('variant_2', 2, 'не помогло'),
        _session('variant_3', 3, 'не помогло'),
      ],
      stateTitle: 'Состояние',
      durationMinutes: 3,
    );

    expect(selected.id, 'variant_1');
  });

  test('Unused variant gets exploration bonus', () {
    final selected = selector.select(
      scenario: _scenario(),
      history: [_session('variant_1', 1, 'помогло')],
      stateTitle: 'Состояние',
      durationMinutes: 3,
    );

    expect(selected.id, 'variant_2');
  });

  test('Rarely used variant gets exploration bonus', () {
    final selected = selector.select(
      scenario: _scenario(),
      history: [
        _session('variant_1', 1, 'не помогло'),
        _session('variant_1', 2, 'не помогло'),
        _session('variant_2', 3, 'не помогло'),
        _session('variant_3', 4, 'не помогло'),
      ],
      stateTitle: 'Состояние',
      durationMinutes: 3,
    );

    expect(selected.id, 'variant_2');
  });

  test('Equal scores choose less used variant', () {
    final selected = selector.select(
      scenario: _scenario(),
      history: [
        _session('variant_1', 1, 'не помогло'),
        _session('variant_3', 2, 'не помогло'),
        _session('variant_3', 3, 'не помогло'),
      ],
      stateTitle: 'Состояние',
      durationMinutes: 3,
    );

    expect(selected.id, 'variant_2');
  });

  test('Equal scores and usage choose earlier variant', () {
    final selected = selector.select(
      scenario: _scenario(),
      history: [_session('variant_1', 1, 'не помогло')],
      stateTitle: 'Состояние',
      durationMinutes: 3,
    );

    expect(selected.id, 'variant_2');
  });

  test('Old sessions without scenarioVariantId are safe', () {
    final selected = selector.select(
      scenario: _scenario(),
      history: [
        ResetSession(
          id: 'old',
          completedAt: DateTime(2026, 5, 17, 12),
          stateTitle: 'Состояние',
          scenarioTitle: 'Старый сценарий',
          durationMinutes: 3,
          result: 'помогло',
        ),
      ],
      stateTitle: 'Состояние',
      durationMinutes: 3,
    );

    expect(selected.id, 'variant_1');
  });

  test('Single variant returns safely', () {
    final scenario = ResetScenario.withVariants(
      id: 'single',
      stateTitle: 'Состояние',
      durationMinutes: 3,
      defaultVariantId: 'single_variant',
      variants: const [
        ResetScenarioVariant(
          id: 'single_variant',
          title: 'Один вариант',
          shortDescription: 'Описание',
          stateTitle: 'Состояние',
          durationMinutes: 3,
          checklistItems: ['Выбери один следующий шаг.'],
        ),
      ],
    );
    final selected = selector.select(
      scenario: scenario,
      history: [_session('single_variant', 1, 'помогло')],
      stateTitle: 'Состояние',
      durationMinutes: 3,
    );

    expect(selected.id, 'single_variant');
  });
}

ResetScenario _scenario() {
  return ResetScenario.withVariants(
    id: 'scenario',
    stateTitle: 'Состояние',
    durationMinutes: 3,
    defaultVariantId: 'variant_1',
    variants: const [
      ResetScenarioVariant(
        id: 'variant_1',
        title: 'Вариант 1',
        shortDescription: 'Описание 1',
        stateTitle: 'Состояние',
        durationMinutes: 3,
        checklistItems: ['Шаг 1'],
      ),
      ResetScenarioVariant(
        id: 'variant_2',
        title: 'Вариант 2',
        shortDescription: 'Описание 2',
        stateTitle: 'Состояние',
        durationMinutes: 3,
        checklistItems: ['Шаг 2'],
      ),
      ResetScenarioVariant(
        id: 'variant_3',
        title: 'Вариант 3',
        shortDescription: 'Описание 3',
        stateTitle: 'Состояние',
        durationMinutes: 3,
        checklistItems: ['Шаг 3'],
      ),
    ],
  );
}

ResetSession _session(String scenarioVariantId, int minute, String result) {
  return ResetSession(
    id: 'session-$scenarioVariantId-$minute',
    completedAt: DateTime(2026, 5, 17, 12, minute),
    stateTitle: 'Состояние',
    scenarioTitle: 'Сценарий',
    durationMinutes: 3,
    result: result,
    scenarioVariantId: scenarioVariantId,
  );
}
