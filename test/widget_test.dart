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

    for (final cluster in resetClusters) {
      await tester.scrollUntilVisible(
        find.text(cluster.title),
        100,
        scrollable: find.byType(Scrollable),
      );
      expect(find.text(cluster.title), findsOneWidget);
    }
    for (final stateTitle in resetStateTitles) {
      expect(find.text(stateTitle), findsNothing);
    }
    await tester.scrollUntilVisible(
      find.text('Быстрый reset на 3 минуты'),
      100,
      scrollable: find.byType(Scrollable),
    );
    expect(find.text('Быстрый reset на 3 минуты'), findsOneWidget);
    expect(find.text('Не знаю, что выбрать'), findsOneWidget);
  });

  testWidgets('Shows and closes cluster selection hint', (tester) async {
    await tester.pumpWidget(const ResetButtonApp());
    await tester.pump();

    await tester.scrollUntilVisible(
      find.text('Не знаю, что выбрать'),
      100,
      scrollable: find.byType(Scrollable),
    );
    await tester.tap(find.text('Не знаю, что выбрать'));
    await tester.pumpAndSettle();

    expect(find.text('Как выбрать reset?'), findsOneWidget);
    for (final cluster in resetClusters) {
      expect(find.textContaining(cluster.title), findsWidgets);
    }

    await tester.scrollUntilVisible(
      find.text('Понятно'),
      100,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.tap(find.text('Понятно'));
    await tester.pumpAndSettle();

    expect(find.text('Как выбрать reset?'), findsNothing);
  });

  testWidgets('Opens scenario selection after tapping a state', (tester) async {
    await tester.pumpWidget(const ResetButtonApp());
    await tester.pump();

    await tester.tap(find.text('Успокоиться'));
    await tester.pumpAndSettle();

    expect(find.text('Успокоиться'), findsOneWidget);
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
      find.text('История пока пустая. Выбери состояние и пройди первый сброс.'),
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
        id: 'test-session',
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
    expect(find.text('Заметка: Стало легче.'), findsOneWidget);
  });

  testWidgets('Opens scenario progress screen and shows controls', (
    tester,
  ) async {
    await tester.pumpWidget(const ResetButtonApp());
    await tester.pump();

    await tester.tap(find.text('Успокоиться'));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(FilledButton, 'Начать').first);
    await tester.pumpAndSettle();

    expect(find.text('3 минуты заземления'), findsWidgets);
    expect(find.text('Успокоиться'), findsOneWidget);
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

  testWidgets('Finishing scenario saves selected result and note', (
    tester,
  ) async {
    const storageService = ResetStorageService();

    await tester.pumpWidget(
      const MaterialApp(home: ResetHomePage(storageService: storageService)),
    );
    await tester.pump();

    await tester.tap(find.text('Успокоиться'));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(FilledButton, 'Начать').first);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Частично'));
    await tester.pump();
    await tester.scrollUntilVisible(
      find.text('Заметка после reset'),
      100,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.enterText(find.byType(TextField), 'Стало чуть спокойнее.');
    await tester.scrollUntilVisible(
      find.text('Завершить'),
      100,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.tap(find.text('Завершить'));
    await tester.pumpAndSettle();

    expect(find.text('Сессия сохранена'), findsOneWidget);

    final sessions = await storageService.loadResetSessions();
    expect(sessions, hasLength(1));
    expect(sessions.single.id, startsWith('anxious-3-'));
    expect(sessions.single.stateTitle, 'Успокоиться');
    expect(sessions.single.scenarioTitle, '3 минуты заземления');
    expect(sessions.single.durationMinutes, 3);
    expect(sessions.single.result, 'частично');
    expect(sessions.single.note, 'Стало чуть спокойнее.');

    await tester.tap(find.byTooltip('История'));
    await tester.pumpAndSettle();

    expect(find.text('Состояние: Успокоиться'), findsOneWidget);
    expect(find.text('Сценарий: 3 минуты заземления'), findsOneWidget);
    expect(find.text('Длительность: 3 минуты'), findsOneWidget);
    expect(find.text('Результат: частично'), findsOneWidget);
    expect(find.text('Заметка: Стало чуть спокойнее.'), findsOneWidget);
  });
}
