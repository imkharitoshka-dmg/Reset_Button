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
        state: 'Тревога',
        scenarioTitle: 'Дыхание',
        duration: '5 минут',
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
}
