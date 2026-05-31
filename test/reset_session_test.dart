import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:reset_button/reset_session.dart';
import 'package:reset_button/reset_storage_service.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('ResetSession serializes to JSON and back', () {
    final session = ResetSession(
      id: 'session-1',
      completedAt: DateTime(2026, 5, 17, 14, 30),
      stateTitle: 'Я тревожусь',
      scenarioTitle: '3 минуты заземления',
      durationMinutes: 3,
      result: 'Частично',
      scenarioVariantId: 'anxious-3-default',
      note: 'Стало чуть спокойнее.',
    );

    final restoredSession = ResetSession.fromStorageString(
      session.toStorageString(),
    );

    expect(restoredSession.id, session.id);
    expect(restoredSession.completedAt, session.completedAt);
    expect(restoredSession.stateTitle, session.stateTitle);
    expect(restoredSession.scenarioTitle, session.scenarioTitle);
    expect(restoredSession.durationMinutes, session.durationMinutes);
    expect(restoredSession.result, session.result);
    expect(restoredSession.scenarioVariantId, session.scenarioVariantId);
    expect(restoredSession.note, session.note);
  });

  test('ResetSession reads old JSON without scenarioVariantId', () {
    final restoredSession = ResetSession.fromStorageString(
      '{"id":"old-session","completedAt":"2026-05-17T14:30:00.000","stateTitle":"Я тревожусь","scenarioTitle":"3 минуты","durationMinutes":3,"result":"помогло","note":null}',
    );

    expect(restoredSession.id, 'old-session');
    expect(restoredSession.scenarioVariantId, isNull);
  });

  test('ResetStorageService saves and loads scenarioVariantId', () async {
    const storageService = ResetStorageService();
    final session = ResetSession(
      id: 'stored-session',
      completedAt: DateTime(2026, 5, 17, 14, 30),
      stateTitle: 'Я тревожусь',
      scenarioTitle: '3 минуты паузы',
      durationMinutes: 3,
      result: 'помогло',
      scenarioVariantId: 'anxious-3-pause',
    );

    await storageService.saveResetSession(session);
    final sessions = await storageService.loadResetSessions();

    expect(sessions, hasLength(1));
    expect(sessions.single.scenarioVariantId, 'anxious-3-pause');
  });
}
