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
}
