import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:reset_button/main.dart';
import 'package:reset_button/reset_scenarios_data.dart';
import 'package:reset_button/reset_session.dart';
import 'package:reset_button/reset_storage_service.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Shows the state selection home screen', (tester) async {
    await tester.pumpWidget(const ResetButtonApp());
    await tester.pump();

    expect(find.text('Reset Button'), findsWidgets);
    expect(
      find.text('Короткие сценарии, чтобы вернуться в спокойствие и фокус'),
      findsOneWidget,
    );
    expect(find.text('Что сейчас происходит?'), findsOneWidget);

    for (final stateTitle in resetStateTitles) {
      await tester.scrollUntilVisible(
        find.text(stateTitle),
        100,
        scrollable: find.byType(Scrollable),
      );
      expect(find.text(stateTitle), findsOneWidget);
    }
    await tester.scrollUntilVisible(
      find.text('Быстрый reset на 3 минуты'),
      100,
      scrollable: find.byType(Scrollable),
    );
    expect(find.text('Быстрый reset на 3 минуты'), findsOneWidget);
  });

  testWidgets('Opens scenario selection after tapping a state', (tester) async {
    await tester.pumpWidget(const ResetButtonApp());
    await tester.pump();

    await tester.tap(find.text('Я тревожусь'));
    await tester.pumpAndSettle();

    expect(find.text('Я тревожусь'), findsOneWidget);
    expect(find.text('3 минуты заземления'), findsOneWidget);
    expect(find.text('5 минут спокойствия'), findsOneWidget);
    expect(find.text('10 минут стабилизации'), findsOneWidget);
    expect(find.text('3 минуты'), findsOneWidget);
    expect(find.text('5 минут'), findsOneWidget);
    expect(find.text('10 минут'), findsOneWidget);
    expect(find.text('Начать'), findsNWidgets(3));
  });

  testWidgets('Shows empty history state', (tester) async {
    await tester.pumpWidget(const ResetButtonApp());
    await tester.pump();

    await tester.tap(find.byTooltip('История'));
    await tester.pumpAndSettle();

    expect(find.text('История'), findsOneWidget);
    expect(
      find.text('История пока пустая. Выбери состояние и пройди первый reset.'),
      findsOneWidget,
    );
  });

  testWidgets('Renders history screen', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: HistoryPage()));
    await tester.pump();

    expect(find.text('История'), findsOneWidget);
  });

  testWidgets('Shows history card for a saved reset session', (tester) async {
    const storageService = ResetStorageService();

    await storageService.saveResetSession(
      ResetSession(
        completedAt: DateTime(2026, 5, 17, 14, 30),
        stateTitle: 'Тревога',
        scenarioTitle: 'Дыхание',
        durationMinutes: 5,
        result: 'частично',
        note: 'Стало легче.',
      ),
    );

    await tester.pumpWidget(
      const MaterialApp(home: HistoryPage(storageService: storageService)),
    );
    await tester.pump();

    expect(find.text('17 мая 2026, 14:30'), findsOneWidget);
    expect(find.text('Состояние: Тревога'), findsOneWidget);
    expect(find.text('Сценарий: Дыхание'), findsOneWidget);
    expect(find.text('Результат: частично'), findsOneWidget);
  });

  testWidgets('Opens scenario progress screen and shows controls', (
    tester,
  ) async {
    await tester.pumpWidget(const ResetButtonApp());
    await tester.pump();

    await tester.tap(find.text('Я тревожусь'));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(FilledButton, 'Начать').first);
    await tester.pumpAndSettle();

    expect(find.text('3 минуты заземления'), findsWidgets);
    expect(find.text('Я тревожусь'), findsOneWidget);
    expect(find.text('3 минуты'), findsOneWidget);
    expect(find.text('Почувствуй опору стоп и спины.'), findsOneWidget);
    expect(find.byType(CheckboxListTile), findsWidgets);

    await tester.tap(find.byType(CheckboxListTile).first);
    await tester.pump();

    final firstCheckbox = tester.widget<CheckboxListTile>(
      find.byType(CheckboxListTile).first,
    );
    expect(firstCheckbox.value, isTrue);

    expect(find.text('Стало немного легче?'), findsOneWidget);
    expect(find.text('Да, помогло'), findsOneWidget);
    expect(find.text('Частично'), findsOneWidget);
    expect(find.text('Нет'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Заметка после reset'),
      100,
      scrollable: find.byType(Scrollable).last,
    );
    expect(find.text('Заметка после reset'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Завершить'),
      100,
      scrollable: find.byType(Scrollable).last,
    );
    expect(find.text('Завершить'), findsOneWidget);
  });
}
