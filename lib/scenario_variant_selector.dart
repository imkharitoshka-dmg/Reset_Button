import 'reset_scenario.dart';
import 'reset_session.dart';

class ScenarioVariantSelector {
  const ScenarioVariantSelector();

  static const double defaultPriorityBonus = 0.2;
  static const double helpedBonus = 1.0;
  static const double partiallyBonus = 0.5;
  static const double recentSuccessfulBonus = 0.3;
  static const double unusedVariantBonus = 0.5;
  static const double rarelyUsedVariantBonus = 0.3;

  ResetScenarioVariant select({
    required ResetScenario scenario,
    required List<ResetSession> history,
    required String stateTitle,
    required int durationMinutes,
  }) {
    final variants = scenario.variants;

    if (variants.length <= 1) {
      return scenario.defaultVariant;
    }

    final relevantHistory =
        history
            .where(
              (session) =>
                  session.stateTitle == stateTitle &&
                  session.durationMinutes == durationMinutes,
            )
            .toList()
          ..sort((a, b) => b.completedAt.compareTo(a.completedAt));

    if (relevantHistory.isEmpty) {
      return scenario.defaultVariant;
    }

    String? latestVariantId;
    for (final session in relevantHistory) {
      final scenarioVariantId = session.scenarioVariantId;
      if (scenarioVariantId != null &&
          variants.any((variant) => variant.id == scenarioVariantId)) {
        latestVariantId = scenarioVariantId;
        break;
      }
    }

    final candidates = latestVariantId == null
        ? variants
        : variants.where((variant) => variant.id != latestVariantId).toList();
    final safeCandidates = candidates.isEmpty ? variants : candidates;
    final usageCounts = {
      for (final variant in variants)
        variant.id: relevantHistory
            .where((session) => session.scenarioVariantId == variant.id)
            .length,
    };
    final maxUsage = usageCounts.values.fold<int>(
      0,
      (currentMax, count) => count > currentMax ? count : currentMax,
    );

    ResetScenarioVariant? bestVariant;
    double? bestScore;
    int? bestUsageCount;
    int? bestIndex;

    for (final variant in safeCandidates) {
      final score = _scoreVariant(
        scenario: scenario,
        variant: variant,
        relevantHistory: relevantHistory,
        usageCount: usageCounts[variant.id] ?? 0,
        maxUsage: maxUsage,
      );
      final usageCount = usageCounts[variant.id] ?? 0;
      final index = variants.indexWhere((item) => item.id == variant.id);

      if (bestVariant == null ||
          score > bestScore! ||
          (score == bestScore && usageCount < bestUsageCount!) ||
          (score == bestScore &&
              usageCount == bestUsageCount &&
              index < bestIndex!)) {
        bestVariant = variant;
        bestScore = score;
        bestUsageCount = usageCount;
        bestIndex = index;
      }
    }

    return bestVariant ?? scenario.defaultVariant;
  }

  double _scoreVariant({
    required ResetScenario scenario,
    required ResetScenarioVariant variant,
    required List<ResetSession> relevantHistory,
    required int usageCount,
    required int maxUsage,
  }) {
    var score = 0.0;

    if (variant.id == scenario.defaultVariant.id) {
      score += defaultPriorityBonus;
    }

    for (final session in relevantHistory) {
      if (session.scenarioVariantId != variant.id) {
        continue;
      }

      score += switch (session.result.toLowerCase()) {
        'помогло' => helpedBonus,
        'частично' => partiallyBonus,
        _ => 0.0,
      };
    }

    ResetSession? latestVariantSession;
    for (final session in relevantHistory) {
      if (session.scenarioVariantId == variant.id) {
        latestVariantSession = session;
        break;
      }
    }
    final latestResult = latestVariantSession?.result.toLowerCase();
    if (latestResult == 'помогло' || latestResult == 'частично') {
      score += recentSuccessfulBonus;
    }

    if (usageCount == 0) {
      score += unusedVariantBonus;
    } else if (usageCount < maxUsage) {
      score += rarelyUsedVariantBonus;
    }

    return score;
  }
}
