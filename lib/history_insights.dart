import 'reset_scenarios_data.dart';
import 'reset_session.dart';

class HistoryInsightsResult {
  const HistoryInsightsResult({required this.topStates});

  final List<HistoryStateInsight> topStates;

  bool get isEmpty => topStates.isEmpty;
}

class HistoryStateInsight {
  const HistoryStateInsight({
    required this.stateTitle,
    required this.total,
    required this.helped,
    required this.partially,
    required this.notHelped,
    required this.scenarioDetails,
  });

  final String stateTitle;
  final int total;
  final int helped;
  final int partially;
  final int notHelped;
  final List<HistoryScenarioInsight> scenarioDetails;
}

class HistoryScenarioInsight {
  const HistoryScenarioInsight({
    required this.title,
    required this.helped,
    required this.partially,
    required this.notHelped,
    this.shortDescription,
  });

  final String title;
  final String? shortDescription;
  final int helped;
  final int partially;
  final int notHelped;
}

class HistoryInsights {
  const HistoryInsights();

  static const int minimumSessions = 5;

  HistoryInsightsResult build(List<ResetSession> sessions) {
    if (sessions.length < minimumSessions) {
      return const HistoryInsightsResult(topStates: []);
    }

    final stateStats = <String, _StateStats>{};

    for (final session in sessions) {
      final stateTitle = _normalizeStateTitle(session.stateTitle);
      final stateStat = stateStats.putIfAbsent(
        stateTitle,
        () => _StateStats(stateTitle),
      );
      stateStat.counts.add(session.result);

      final variantId = session.scenarioVariantId;
      final variant = scenarioVariantById(variantId);
      if (variant != null) {
        stateStat.variantCounts
            .putIfAbsent(variant.id, _ResultCounts.new)
            .add(session.result);
      }
    }

    final topStates = stateStats.values.toList()
      ..sort((a, b) {
        final totalCompare = b.counts.total.compareTo(a.counts.total);
        if (totalCompare != 0) {
          return totalCompare;
        }

        final helpedCompare = b.counts.helped.compareTo(a.counts.helped);
        if (helpedCompare != 0) {
          return helpedCompare;
        }

        return a.stateTitle.compareTo(b.stateTitle);
      });

    return HistoryInsightsResult(
      topStates: topStates.take(3).map(_stateInsight).toList(),
    );
  }

  HistoryStateInsight _stateInsight(_StateStats stateStat) {
    return HistoryStateInsight(
      stateTitle: stateStat.stateTitle,
      total: stateStat.counts.total,
      helped: stateStat.counts.helped,
      partially: stateStat.counts.partially,
      notHelped: stateStat.counts.notHelped,
      scenarioDetails: _scenarioDetails(stateStat.variantCounts),
    );
  }

  List<HistoryScenarioInsight> _scenarioDetails(
    Map<String, _ResultCounts> variantCounts,
  ) {
    final entries = variantCounts.entries.toList()
      ..sort((a, b) {
        final helpedCompare = b.value.helped.compareTo(a.value.helped);
        if (helpedCompare != 0) {
          return helpedCompare;
        }

        final partiallyCompare = b.value.partially.compareTo(a.value.partially);
        if (partiallyCompare != 0) {
          return partiallyCompare;
        }

        final notHelpedCompare = a.value.notHelped.compareTo(b.value.notHelped);
        if (notHelpedCompare != 0) {
          return notHelpedCompare;
        }

        final aTitle = scenarioVariantById(a.key)?.title ?? '';
        final bTitle = scenarioVariantById(b.key)?.title ?? '';
        return aTitle.compareTo(bTitle);
      });

    return entries.map((entry) {
      final variant = scenarioVariantById(entry.key)!;
      return HistoryScenarioInsight(
        title: variant.title,
        shortDescription: variant.shortDescription,
        helped: entry.value.helped,
        partially: entry.value.partially,
        notHelped: entry.value.notHelped,
      );
    }).toList();
  }

  String _normalizeStateTitle(String stateTitle) {
    return switch (stateTitle) {
      'Я устала' => 'Усталость',
      'Я перегружена задачами' => 'Слишком много задач',
      'Я эмоционально вымотана' => 'Эмоциональное истощение',
      'Я устала от общения' => 'Усталость от общения',
      _ => stateTitle,
    };
  }
}

class _StateStats {
  _StateStats(this.stateTitle);

  final String stateTitle;
  final counts = _ResultCounts();
  final variantCounts = <String, _ResultCounts>{};
}

class _ResultCounts {
  int helped = 0;
  int partially = 0;
  int notHelped = 0;

  int get total => helped + partially + notHelped;

  void add(String result) {
    switch (result.toLowerCase()) {
      case 'помогло':
        helped++;
      case 'частично':
        partially++;
      case 'не помогло':
        notHelped++;
    }
  }
}
