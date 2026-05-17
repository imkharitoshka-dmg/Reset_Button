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

  test('Quick reset scenario exists', () {
    expect(quickResetScenario.stateTitle, 'Быстрый reset');
    expect(quickResetScenario.title, 'Быстрый reset');
    expect(quickResetScenario.durationMinutes, 3);
    expect(allResetScenarios, contains(quickResetScenario));
  });
}
