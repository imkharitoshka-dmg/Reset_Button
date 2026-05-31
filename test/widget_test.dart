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

  testWidgets('Opens state selection after tapping a cluster', (tester) async {
    await tester.pumpWidget(const ResetButtonApp());
    await tester.pump();

    await tester.tap(find.text('Успокоиться'));
    await tester.pumpAndSettle();

    expect(find.text('Успокоиться'), findsWidgets);
    expect(
      find.text('Выбери, что ближе всего к текущему состоянию.'),
      findsOneWidget,
    );
    expect(find.text('Меня накрыл стресс'), findsOneWidget);
    expect(find.text('Я тревожусь'), findsOneWidget);
    expect(find.text('Я переживаю из-за будущего'), findsOneWidget);
  });

  testWidgets('Shows gender-neutral state titles in clusters', (tester) async {
    await tester.pumpWidget(const ResetButtonApp());
    await tester.pump();

    await tester.tap(find.text('Восстановиться'));
    await tester.pumpAndSettle();

    expect(find.text('Усталость'), findsOneWidget);
    expect(find.text('Эмоциональное истощение'), findsOneWidget);
    expect(find.text('Я устала'), findsNothing);
    expect(find.text('Я эмоционально вымотана'), findsNothing);

    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Разгрузить голову'));
    await tester.pumpAndSettle();

    expect(find.text('Слишком много задач'), findsOneWidget);
    expect(find.text('Я перегружена задачами'), findsNothing);

    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Переключиться после общения'));
    await tester.pumpAndSettle();

    expect(find.text('Усталость от общения'), findsOneWidget);
    expect(find.text('Я устала от общения'), findsNothing);
  });

  testWidgets('Opens scenario selection after tapping a state', (tester) async {
    await tester.pumpWidget(const ResetButtonApp());
    await tester.pump();

    await tester.tap(find.text('Успокоиться'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Я тревожусь'));
    await tester.pumpAndSettle();

    expect(find.text('Я тревожусь'), findsOneWidget);
    expect(find.text('3 минуты: заземлиться'), findsOneWidget);
    expect(find.text('5 минут: заземлиться'), findsOneWidget);
    expect(find.text('10 минут: заземлиться'), findsOneWidget);
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
    expect(find.text('Что чаще помогало'), findsNothing);
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

  testWidgets('Does not show history insights before five sessions', (
    tester,
  ) async {
    const storageService = ResetStorageService();

    await _saveHistorySessions(storageService, 4);

    await tester.pumpWidget(
      const MaterialApp(home: HistoryPage(storageService: storageService)),
    );
    await tester.pump();

    expect(find.text('Что чаще помогало'), findsNothing);
  });

  testWidgets('Shows history insights after five sessions', (tester) async {
    const storageService = ResetStorageService();

    await _saveHistorySessions(storageService, 5);

    await tester.pumpWidget(
      const MaterialApp(home: HistoryPage(storageService: storageService)),
    );
    await tester.pump();

    expect(find.text('Что чаще помогало'), findsOneWidget);
    expect(find.text('Подробнее'), findsOneWidget);
    expect(find.text('Посмотреть статистику'), findsNothing);
    expect(find.textContaining('Для «'), findsNothing);
    expect(find.textContaining('3 минуты паузы'), findsNothing);
    expect(find.textContaining('помогло: 3'), findsNothing);
    expect(find.textContaining('anxious-3-pause'), findsNothing);
  });

  testWidgets('Opens detailed history insights by tapping compact block', (
    tester,
  ) async {
    const storageService = ResetStorageService();

    await _saveHistorySessions(storageService, 5);

    await tester.pumpWidget(
      const MaterialApp(home: HistoryPage(storageService: storageService)),
    );
    await tester.pump();

    await tester.tap(find.text('Что чаще помогало'));
    await tester.pumpAndSettle();

    expect(find.text('Что помогало чаще'), findsOneWidget);
    expect(find.text('Чаще всего reset использовался для:'), findsOneWidget);
    expect(find.text('Я тревожусь — 3 раза'), findsOneWidget);
    expect(find.text('Усталость — 2 раза'), findsOneWidget);
    expect(find.textContaining('3 минуты паузы'), findsNothing);
    expect(find.textContaining('помогло:'), findsNothing);
    expect(find.textContaining('anxious-3-pause'), findsNothing);
  });

  testWidgets('Opens scenario details after tapping history insight state', (
    tester,
  ) async {
    const storageService = ResetStorageService();

    await _saveHistorySessions(storageService, 5);

    await tester.pumpWidget(
      const MaterialApp(home: HistoryPage(storageService: storageService)),
    );
    await tester.pump();

    await tester.tap(find.text('Что чаще помогало'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Я тревожусь — 3 раза'));
    await tester.pumpAndSettle();

    expect(find.text('Сценарии, которые чаще помогали'), findsOneWidget);
    expect(find.text('3 минуты паузы'), findsOneWidget);
    expect(
      find.text('помогло: 2 · частично: 0 · не помогло: 0'),
      findsOneWidget,
    );
    expect(find.textContaining('anxious-3-pause'), findsNothing);
  });

  testWidgets('Shows partial-only scenario in state detail', (tester) async {
    const storageService = ResetStorageService();

    await storageService.saveResetSession(
      ResetSession(
        id: 'partial-1',
        completedAt: DateTime(2026, 5, 17, 14),
        stateTitle: 'Я тревожусь',
        scenarioTitle: 'Сценарий',
        durationMinutes: 3,
        result: 'частично',
        scenarioVariantId: 'anxious-3-pause',
      ),
    );
    await _saveHistorySessions(storageService, 4);

    await tester.pumpWidget(
      const MaterialApp(home: HistoryPage(storageService: storageService)),
    );
    await tester.pump();

    await tester.tap(find.text('Что чаще помогало'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Я тревожусь — 4 раза'));
    await tester.pumpAndSettle();

    expect(find.text('3 минуты паузы'), findsOneWidget);
    expect(
      find.text('помогло: 2 · частично: 1 · не помогло: 0'),
      findsOneWidget,
    );
  });

  testWidgets('Shows fallback when state has no scenario details', (
    tester,
  ) async {
    const storageService = ResetStorageService();

    await _saveHistorySessionsWithoutVariants(storageService, 5);

    await tester.pumpWidget(
      const MaterialApp(home: HistoryPage(storageService: storageService)),
    );
    await tester.pump();

    await tester.tap(find.text('Что чаще помогало'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Я тревожусь — 3 раза'));
    await tester.pumpAndSettle();

    expect(
      find.text(
        'Пока нет данных по конкретным сценариям. Новые reset-сессии будут сохраняться с детализацией.',
      ),
      findsOneWidget,
    );
    expect(find.textContaining('anxious-3-pause'), findsNothing);
  });

  testWidgets('History insights normalize old state titles', (tester) async {
    const storageService = ResetStorageService();

    await storageService.saveResetSession(
      ResetSession(
        id: 'old-tired-1',
        completedAt: DateTime(2026, 5, 17, 14),
        stateTitle: 'Я устала',
        scenarioTitle: 'Старый сценарий',
        durationMinutes: 3,
        result: 'помогло',
      ),
    );
    await storageService.saveResetSession(
      ResetSession(
        id: 'old-tired-2',
        completedAt: DateTime(2026, 5, 17, 15),
        stateTitle: 'Я устала',
        scenarioTitle: 'Старый сценарий',
        durationMinutes: 3,
        result: 'частично',
      ),
    );
    await _saveHistorySessions(storageService, 3);

    await tester.pumpWidget(
      const MaterialApp(home: HistoryPage(storageService: storageService)),
    );
    await tester.pump();

    await tester.tap(find.text('Что чаще помогало'));
    await tester.pumpAndSettle();

    expect(find.text('Усталость — 2 раза'), findsOneWidget);
  });

  testWidgets('Shows history scenario variant title when variant id exists', (
    tester,
  ) async {
    const storageService = ResetStorageService();

    await storageService.saveResetSession(
      ResetSession(
        id: 'variant-session',
        completedAt: DateTime(2026, 5, 17, 14, 30),
        stateTitle: 'Я тревожусь',
        scenarioTitle: 'Старое название',
        durationMinutes: 3,
        result: 'помогло',
        scenarioVariantId: 'anxious-3-pause',
      ),
    );

    await tester.pumpWidget(
      const MaterialApp(home: HistoryPage(storageService: storageService)),
    );
    await tester.pump();

    expect(find.text('Сценарий: 3 минуты паузы'), findsOneWidget);
    expect(
      find.text(
        'Описание: Быстрый вариант через тело, пространство и один выбор.',
      ),
      findsOneWidget,
    );
    expect(find.text('Старое название'), findsNothing);
    expect(find.textContaining('anxious-3-pause'), findsNothing);
  });

  testWidgets('Shows old history session without scenario variant id', (
    tester,
  ) async {
    const storageService = ResetStorageService();

    await storageService.saveResetSession(
      ResetSession(
        id: 'old-session',
        completedAt: DateTime(2026, 5, 17, 14, 30),
        stateTitle: 'Тревога',
        scenarioTitle: 'Сценарий из ранней версии',
        durationMinutes: 3,
        result: 'помогло',
      ),
    );

    await tester.pumpWidget(
      const MaterialApp(home: HistoryPage(storageService: storageService)),
    );
    await tester.pump();

    expect(find.text('Сценарий: Сценарий из ранней версии'), findsOneWidget);
    expect(find.text('Результат: помогло'), findsOneWidget);
  });

  testWidgets('Unknown scenario variant id does not break history', (
    tester,
  ) async {
    const storageService = ResetStorageService();

    await storageService.saveResetSession(
      ResetSession(
        id: 'unknown-variant-session',
        completedAt: DateTime(2026, 5, 17, 14, 30),
        stateTitle: 'Я тревожусь',
        scenarioTitle: 'Сохранённый сценарий',
        durationMinutes: 3,
        result: 'не помогло',
        scenarioVariantId: 'missing-variant-id',
        note: 'Заметка осталась.',
      ),
    );

    await tester.pumpWidget(
      const MaterialApp(home: HistoryPage(storageService: storageService)),
    );
    await tester.pump();

    expect(find.text('Сценарий: Сохранённый сценарий'), findsOneWidget);
    expect(find.text('Результат: не помогло'), findsOneWidget);
    expect(find.text('Заметка: Заметка осталась.'), findsOneWidget);
    expect(find.textContaining('missing-variant-id'), findsNothing);
  });

  testWidgets('Opens scenario progress screen and shows controls', (
    tester,
  ) async {
    await tester.pumpWidget(const ResetButtonApp());
    await tester.pump();

    await tester.tap(find.text('Успокоиться'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Я тревожусь'));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(FilledButton, 'Начать').first);
    await tester.pumpAndSettle();

    expect(find.text('3 минуты: заземлиться'), findsWidgets);
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
    await tester.tap(find.text('Я тревожусь'));
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
    expect(sessions.single.stateTitle, 'Я тревожусь');
    expect(sessions.single.scenarioTitle, '3 минуты: заземлиться');
    expect(sessions.single.durationMinutes, 3);
    expect(sessions.single.result, 'частично');
    expect(sessions.single.scenarioVariantId, 'anxious-3-default');
    expect(sessions.single.note, 'Стало чуть спокойнее.');

    await tester.tap(find.byTooltip('История'));
    await tester.pumpAndSettle();

    expect(find.text('Состояние: Я тревожусь'), findsOneWidget);
    expect(find.text('Сценарий: 3 минуты: заземлиться'), findsOneWidget);
    expect(find.text('Длительность: 3 минуты'), findsOneWidget);
    expect(find.text('Результат: частично'), findsOneWidget);
    expect(find.text('Заметка: Стало чуть спокойнее.'), findsOneWidget);
  });

  testWidgets('Quick reset flow rotates and saves scenario variant id', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(800, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    const storageService = ResetStorageService();

    await storageService.saveResetSession(
      ResetSession(
        id: 'previous-quick',
        completedAt: DateTime(2026, 5, 17, 14),
        stateTitle: 'Быстрый reset',
        scenarioTitle: 'Быстрый reset',
        durationMinutes: 3,
        result: 'помогло',
        scenarioVariantId: 'quick-reset-3-default',
      ),
    );

    await tester.pumpWidget(
      const MaterialApp(home: ResetHomePage(storageService: storageService)),
    );
    await tester.pump();

    await tester.scrollUntilVisible(
      find.text('Быстрый reset на 3 минуты'),
      100,
      scrollable: find.byType(Scrollable),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.widgetWithText(FilledButton, 'Быстрый reset на 3 минуты'),
    );
    await tester.pumpAndSettle();

    expect(find.text('Быстрый reset'), findsWidgets);

    await tester.tap(find.widgetWithText(FilledButton, 'Начать').first);
    await tester.pumpAndSettle();

    expect(
      find.textContaining(
        'Поставь стопы на пол и почувствуй опору',
        skipOffstage: false,
      ),
      findsOneWidget,
    );
    expect(find.textContaining('quick-reset-3-default'), findsNothing);

    await tester.tap(find.text('Завершить'));
    await tester.pumpAndSettle();

    final sessions = await storageService.loadResetSessions();
    final savedSession = sessions.first;
    expect(savedSession.stateTitle, 'Быстрый reset');
    expect(savedSession.scenarioTitle, 'Быстрый reset через тело');
    expect(savedSession.scenarioVariantId, 'quick-reset-3-body');

    await tester.tap(find.byTooltip('История'));
    await tester.pumpAndSettle();

    expect(
      find.text('Сценарий: ${savedSession.scenarioTitle}'),
      findsOneWidget,
    );
    expect(find.textContaining(savedSession.scenarioVariantId!), findsNothing);
  });

  testWidgets('Variant routing is reflected in saved session and insights', (
    tester,
  ) async {
    const storageService = ResetStorageService();

    await storageService.saveResetSession(
      ResetSession(
        id: 'previous-anxious-default',
        completedAt: DateTime(2026, 5, 17, 14),
        stateTitle: 'Я тревожусь',
        scenarioTitle: '3 минуты: заземлиться',
        durationMinutes: 3,
        result: 'помогло',
        scenarioVariantId: 'anxious-3-default',
      ),
    );
    await storageService.saveResetSession(
      ResetSession(
        id: 'previous-tired',
        completedAt: DateTime(2026, 5, 17, 15),
        stateTitle: 'Усталость',
        scenarioTitle: '3 минуты восстановления',
        durationMinutes: 3,
        result: 'частично',
        scenarioVariantId: 'tired-3-default',
      ),
    );
    await storageService.saveResetSession(
      ResetSession(
        id: 'previous-focus',
        completedAt: DateTime(2026, 5, 17, 16),
        stateTitle: 'Я не могу сфокусироваться',
        scenarioTitle: '3 минуты: выбрать одну точку внимания',
        durationMinutes: 3,
        result: 'не помогло',
        scenarioVariantId: 'unfocused-3-default',
      ),
    );
    await storageService.saveResetSession(
      ResetSession(
        id: 'previous-chaos',
        completedAt: DateTime(2026, 5, 17, 17),
        stateTitle: 'У меня хаос в голове',
        scenarioTitle: '3 минуты: навести ясность',
        durationMinutes: 3,
        result: 'помогло',
        scenarioVariantId: 'mental-chaos-3-default',
      ),
    );

    await tester.pumpWidget(
      const MaterialApp(home: ResetHomePage(storageService: storageService)),
    );
    await tester.pump();

    await tester.tap(find.text('Успокоиться'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Я тревожусь'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Начать').first);
    await tester.pumpAndSettle();

    expect(find.text('3 минуты паузы'), findsWidgets);
    expect(find.textContaining('anxious-3-pause'), findsNothing);

    await tester.scrollUntilVisible(
      find.text('Завершить'),
      100,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.tap(find.text('Завершить'));
    await tester.pumpAndSettle();

    final sessions = await storageService.loadResetSessions();
    final savedSession = sessions.first;
    expect(savedSession.stateTitle, 'Я тревожусь');
    expect(savedSession.scenarioTitle, '3 минуты паузы');
    expect(savedSession.scenarioVariantId, 'anxious-3-pause');

    await tester.tap(find.byTooltip('История'));
    await tester.pumpAndSettle();

    expect(find.text('Сценарий: 3 минуты паузы'), findsOneWidget);
    expect(find.text('Что чаще помогало'), findsOneWidget);
    expect(find.textContaining('anxious-3-pause'), findsNothing);

    await tester.tap(find.text('Что чаще помогало'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Я тревожусь — 2 раза'));
    await tester.pumpAndSettle();

    expect(find.text('Сценарии, которые чаще помогали'), findsOneWidget);
    expect(find.text('3 минуты паузы'), findsOneWidget);
    expect(find.text('помогло: 1 · частично: 0 · не помогло: 0'), findsWidgets);
    expect(find.textContaining('anxious-3-pause'), findsNothing);
  });
}

Future<void> _saveHistorySessions(
  ResetStorageService storageService,
  int count,
) async {
  for (var index = 0; index < count; index++) {
    await storageService.saveResetSession(
      ResetSession(
        id: 'history-$index',
        completedAt: DateTime(2026, 5, 17, 14, index),
        stateTitle: index < 3 ? 'Я тревожусь' : 'Усталость',
        scenarioTitle: 'Сценарий',
        durationMinutes: 3,
        result: index < 4 ? 'помогло' : 'частично',
        scenarioVariantId: index < 2 ? 'anxious-3-pause' : null,
      ),
    );
  }
}

Future<void> _saveHistorySessionsWithoutVariants(
  ResetStorageService storageService,
  int count,
) async {
  for (var index = 0; index < count; index++) {
    await storageService.saveResetSession(
      ResetSession(
        id: 'legacy-history-$index',
        completedAt: DateTime(2026, 5, 17, 15, index),
        stateTitle: index < 3 ? 'Я тревожусь' : 'Усталость',
        scenarioTitle: 'Сценарий из ранней версии',
        durationMinutes: 3,
        result: index < 2 ? 'помогло' : 'частично',
      ),
    );
  }
}
