import 'package:flutter_test/flutter_test.dart';
import 'package:reset_button/reset_scenarios_data.dart';

void main() {
  test('Contains fifteen user-facing reset states', () {
    expect(resetStateTitles, hasLength(15));
    expect(resetStateTitles, contains('Усталость'));
    expect(resetStateTitles, contains('Слишком много задач'));
    expect(resetStateTitles, contains('Усталость от общения'));
    expect(resetStateTitles, isNot(contains('Я устала')));
    expect(resetStateTitles, isNot(contains('Я перегружена задачами')));
  });

  test('Contains five reset clusters', () {
    expect(resetClusters.map((cluster) => cluster.title), [
      'Успокоиться',
      'Восстановиться',
      'Разгрузить голову',
      'Сфокусироваться',
      'Переключиться после общения',
    ]);
  });

  test('Each cluster has exactly three states', () {
    for (final cluster in resetClusters) {
      expect(cluster.stateTitles, hasLength(3));
    }
    expect(resetClusters[1].stateTitles, [
      'Усталость',
      'Эмоциональное истощение',
      'Мне ничего не хочется',
    ]);
    expect(resetClusters[2].stateTitles, contains('Слишком много задач'));
    expect(resetClusters[4].stateTitles, contains('Усталость от общения'));
  });

  test('Each main state has 3, 5, and 10 minute scenarios', () {
    for (final stateTitle in resetStateTitles) {
      final durations = scenariosForUserState(
        stateTitle,
      ).map((scenario) => scenario.durationMinutes).toSet();

      expect(durations, {3, 5, 10});
    }
  });

  test('Each cluster has 3, 5, and 10 minute scenarios', () {
    for (final cluster in resetClusters) {
      for (final stateTitle in cluster.stateTitles) {
        final durations = scenariosForUserState(
          stateTitle,
        ).map((scenario) => scenario.durationMinutes).toSet();

        expect(durations, {3, 5, 10});
      }
    }
  });

  test('Each cluster default variant has checklist items', () {
    for (final cluster in resetClusters) {
      for (final stateTitle in cluster.stateTitles) {
        for (final durationMinutes in [3, 5, 10]) {
          final variant = defaultScenarioVariantForUserStateAndDuration(
            stateTitle: stateTitle,
            durationMinutes: durationMinutes,
          );

          expect(variant, isNotNull);
          expect(variant!.checklistItems, isNotEmpty);
        }
      }
    }
  });

  test('All clusters have complete scenario variants', () {
    const forbiddenWords = [
      'устала',
      'готова',
      'собралась',
      'вымотана',
      'заметила',
      'почувствовала',
      'лечит',
      'гарантированно',
      'точно поможет',
      'доказано',
    ];

    expect(resetClusters, hasLength(5));

    for (final cluster in resetClusters) {
      expect(cluster.stateTitles, hasLength(3));

      for (final stateTitle in cluster.stateTitles) {
        final scenarios = scenariosForUserState(stateTitle);
        final durations = scenarios
            .map((scenario) => scenario.durationMinutes)
            .toSet();

        expect(durations, {3, 5, 10});

        for (final durationMinutes in [3, 5, 10]) {
          final scenario = scenarios.singleWhere(
            (scenario) => scenario.durationMinutes == durationMinutes,
          );
          final variantIds = scenario.variants
              .map((variant) => variant.id)
              .toSet();

          expect(scenario.defaultVariant, isNotNull);
          expect(scenario.variants.length, greaterThanOrEqualTo(3));
          expect(variantIds, hasLength(scenario.variants.length));

          for (final variant in scenario.variants) {
            expect(variant.stateTitle, stateTitle);
            expect(variant.durationMinutes, durationMinutes);
            expect(variant.checklistItems, isNotEmpty);

            final text = [
              scenario.stateTitle,
              variant.title,
              variant.shortDescription,
              ...variant.checklistItems,
            ].join(' ').toLowerCase();

            for (final word in forbiddenWords) {
              expect(text, isNot(contains(word)));
            }
          }
        }
      }
    }
  });

  test('Recovery cluster has complete scenario variants', () {
    final recoveryCluster = resetClusters.singleWhere(
      (cluster) => cluster.title == 'Восстановиться',
    );
    const forbiddenWords = [
      'устала',
      'готова',
      'собралась',
      'вымотана',
      'заметила',
      'почувствовала',
    ];

    expect(recoveryCluster.stateTitles, [
      'Усталость',
      'Эмоциональное истощение',
      'Мне ничего не хочется',
    ]);

    for (final stateTitle in recoveryCluster.stateTitles) {
      final scenarios = scenariosForUserState(stateTitle);
      final durations = scenarios
          .map((scenario) => scenario.durationMinutes)
          .toSet();

      expect(durations, {3, 5, 10});

      for (final durationMinutes in [3, 5, 10]) {
        final scenario = scenarios.singleWhere(
          (scenario) => scenario.durationMinutes == durationMinutes,
        );
        final variantIds = scenario.variants
            .map((variant) => variant.id)
            .toSet();

        expect(scenario.defaultVariant, isNotNull);
        expect(scenario.variants.length, greaterThanOrEqualTo(3));
        expect(variantIds, hasLength(scenario.variants.length));

        for (final variant in scenario.variants) {
          expect(variant.stateTitle, stateTitle);
          expect(variant.durationMinutes, durationMinutes);
          expect(variant.checklistItems, isNotEmpty);

          final text = [
            scenario.stateTitle,
            variant.title,
            variant.shortDescription,
            ...variant.checklistItems,
          ].join(' ').toLowerCase();

          for (final word in forbiddenWords) {
            expect(text, isNot(contains(word)));
          }
        }
      }
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

  test('Tired scenarios have 3, 5, and 10 minute options', () {
    final durations = scenariosForUserState(
      'Усталость',
    ).map((scenario) => scenario.durationMinutes).toSet();

    expect(durations, {3, 5, 10});
  });

  test('Tired 3 minute scenario has three variants with the default', () {
    final scenario = resetScenarios.singleWhere(
      (scenario) =>
          scenario.stateTitle == 'Усталость' && scenario.durationMinutes == 3,
    );
    final variantIds = scenario.variants.map((variant) => variant.id).toSet();

    expect(scenario.variants, hasLength(3));
    expect(scenario.defaultVariant, isNotNull);
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
      expect(variant.stateTitle, 'Усталость');
      expect(variant.checklistItems, isNotEmpty);
    }
  });

  test('Tired 5 minute scenario has three variants with the default', () {
    final scenario = resetScenarios.singleWhere(
      (scenario) =>
          scenario.stateTitle == 'Усталость' && scenario.durationMinutes == 5,
    );
    final variantIds = scenario.variants.map((variant) => variant.id).toSet();

    expect(scenario.variants, hasLength(3));
    expect(scenario.defaultVariant, isNotNull);
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
      expect(variant.stateTitle, 'Усталость');
      expect(variant.checklistItems, isNotEmpty);
    }
  });

  test('Tired 10 minute scenario has three variants with the default', () {
    final scenario = resetScenarios.singleWhere(
      (scenario) =>
          scenario.stateTitle == 'Усталость' && scenario.durationMinutes == 10,
    );
    final variantIds = scenario.variants.map((variant) => variant.id).toSet();

    expect(scenario.variants, hasLength(3));
    expect(scenario.defaultVariant, isNotNull);
    expect(scenario.defaultVariant.id, 'tired-10-default');
    expect(scenario.defaultVariant.title, '10 минут восстановления');
    expect(
      scenario.defaultVariant.shortDescription,
      'Более длинная пауза перед возвращением к делам.',
    );
    expect(scenario.defaultVariant.checklistItems, [
      'Налей воды и отойди от рабочего места.',
      'Сделай спокойную растяжку шеи, плеч и спины.',
      'Запиши, что именно забирает больше всего сил.',
      'Оставь только одну обязательную задачу на ближайший час.',
    ]);
    expect(variantIds, hasLength(scenario.variants.length));
    for (final variant in scenario.variants) {
      expect(variant.stateTitle, 'Усталость');
      expect(variant.checklistItems, isNotEmpty);
    }
  });

  test('Tired scenario variants use neutral wording', () {
    final tiredScenarios = scenariosForUserState('Усталость');
    final variantIds = <String>{};
    final forbiddenWords = [
      'устала',
      'готова',
      'собралась',
      'вымотана',
      'заметила',
      'почувствовала',
    ];

    for (final scenario in tiredScenarios) {
      expect(scenario.variants.length, greaterThanOrEqualTo(3));
      for (final variant in scenario.variants) {
        expect(variantIds.add(variant.id), isTrue);
        final text = [
          scenario.stateTitle,
          variant.title,
          variant.shortDescription,
          ...variant.checklistItems,
        ].join(' ').toLowerCase();

        for (final word in forbiddenWords) {
          expect(text, isNot(contains(word)));
        }
      }
    }
  });

  test('Quick reset scenario exists', () {
    expect(quickResetScenario.stateTitle, 'Быстрый reset');
    expect(quickResetScenario.title, 'Быстрый reset');
    expect(quickResetScenario.durationMinutes, 3);
    expect(allResetScenarios, contains(quickResetScenario));
  });
}
