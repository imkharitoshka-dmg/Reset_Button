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
}
