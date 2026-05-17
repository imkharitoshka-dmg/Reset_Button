import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:reset_button/main.dart';

void main() {
  testWidgets('Shows the Reset Button home screen', (tester) async {
    await tester.pumpWidget(const ResetButtonApp());

    expect(find.text('Reset Button'), findsOneWidget);
    expect(find.text('Кнопка сброса'), findsOneWidget);
    expect(find.text('Сбросить'), findsOneWidget);
    expect(find.text('Работает локально на телефоне.'), findsOneWidget);
  });

  testWidgets('Shows reset state and allows undo in the current session', (
    tester,
  ) async {
    await tester.pumpWidget(const ResetButtonApp());

    expect(
      find.text('Один простой экран, чтобы начать день заново.'),
      findsOneWidget,
    );
    expect(
      find.text('Сброс выполнен. Можно продолжать спокойно.'),
      findsNothing,
    );
    expect(find.text('Отменить'), findsNothing);

    await tester.tap(find.text('Сбросить'));
    await tester.pump();

    expect(
      find.text('Сброс выполнен. Можно продолжать спокойно.'),
      findsOneWidget,
    );
    expect(find.text('Отменить'), findsOneWidget);

    await tester.tap(find.text('Отменить'));
    await tester.pump();

    expect(
      find.text('Один простой экран, чтобы начать день заново.'),
      findsOneWidget,
    );
    expect(find.text('Отменить'), findsNothing);
  });

  testWidgets('Shows the current date in Russian', (tester) async {
    await tester.pumpWidget(
      MaterialApp(home: ResetHomePage(today: DateTime(2026, 5, 17))),
    );

    expect(find.text('17 мая 2026'), findsOneWidget);
  });
}
