import 'package:flutter_test/flutter_test.dart';
import 'package:reset_button/reset_scenarios_data.dart';

void main() {
  test('Contains seven main reset states', () {
    expect(resetStateTitles, hasLength(7));
  });

  test('Each main state has 3, 5, and 10 minute scenarios', () {
    for (final stateTitle in resetStateTitles) {
      final durations = resetScenarios
          .where((scenario) => scenario.stateTitle == stateTitle)
          .map((scenario) => scenario.durationMinutes)
          .toSet();

      expect(durations, {3, 5, 10});
    }
  });

  test('Each scenario contains at least three steps', () {
    for (final scenario in allResetScenarios) {
      expect(scenario.steps.length, greaterThanOrEqualTo(3));
    }
  });

  test('Returns default variant for an existing state and duration', () {
    final variant = defaultScenarioVariantForStateAndDuration(
      stateTitle: 'Я тревожусь',
      durationMinutes: 3,
    );

    expect(variant, isNotNull);
    expect(variant!.stateTitle, 'Я тревожусь');
    expect(variant.durationMinutes, 3);
    expect(variant.checklistItems, isNotEmpty);
  });

  test('Unknown state and duration combination returns null', () {
    final variant = defaultScenarioVariantForStateAndDuration(
      stateTitle: 'Неизвестное состояние',
      durationMinutes: 99,
    );

    expect(variant, isNull);
  });

  test('Tired 3 minute scenario has three variants with the old default', () {
    final scenario = resetScenarios.singleWhere(
      (scenario) =>
          scenario.stateTitle == 'Я устала' && scenario.durationMinutes == 3,
    );
    final variantIds = scenario.variants.map((variant) => variant.id).toSet();

    expect(scenario.variants, hasLength(3));
    expect(scenario.defaultVariant.id, 'tired-3-default');
    expect(scenario.defaultVariant.title, '3 минуты восстановления');
    expect(
      scenario.defaultVariant.shortDescription,
      'Короткая пауза, чтобы дать телу немного отдыха.',
    );
    expect(scenario.defaultVariant.checklistItems, [
      'Отложи телефон и закрой лишние вкладки.',
      'Расслабь плечи, челюсть и кисти рук.',
      'Сделай несколько спокойных вдохов и выбери самое лёгкое следующее действие.',
    ]);
    expect(variantIds, hasLength(scenario.variants.length));
    for (final variant in scenario.variants) {
      expect(variant.checklistItems, isNotEmpty);
    }
  });

  test('Tired 5 minute scenario has three variants with the old default', () {
    final scenario = resetScenarios.singleWhere(
      (scenario) =>
          scenario.stateTitle == 'Я устала' && scenario.durationMinutes == 5,
    );
    final variantIds = scenario.variants.map((variant) => variant.id).toSet();

    expect(scenario.variants, hasLength(3));
    expect(scenario.defaultVariant.id, 'tired-5-default');
    expect(scenario.defaultVariant.title, '5 минут восстановления');
    expect(
      scenario.defaultVariant.shortDescription,
      'Мягкий reset для усталости без попытки сразу ускориться.',
    );
    expect(scenario.defaultVariant.checklistItems, [
      'Сядь удобно и убери визуальный шум вокруг себя.',
      'Медленно просканируй тело от головы до стоп.',
      'Запиши одну задачу, которую можно отложить.',
      'Выбери маленькое действие, которое не требует усилия.',
    ]);
    expect(variantIds, hasLength(scenario.variants.length));
    for (final variant in scenario.variants) {
      expect(variant.checklistItems, isNotEmpty);
    }
  });

  test('Quick reset scenario exists', () {
    expect(quickResetScenario.stateTitle, 'Быстрый reset');
    expect(quickResetScenario.title, 'Быстрый reset');
    expect(quickResetScenario.durationMinutes, 3);
    expect(allResetScenarios, contains(quickResetScenario));
  });
}
