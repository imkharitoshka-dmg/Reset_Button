class ResetScenarioVariant {
  const ResetScenarioVariant({
    required this.id,
    required this.title,
    required this.shortDescription,
    required this.stateTitle,
    required this.durationMinutes,
    required this.checklistItems,
  });

  final String id;
  final String title;
  final String shortDescription;
  final String stateTitle;
  final int durationMinutes;
  final List<String> checklistItems;

  ResetScenarioVariant withStateTitle(String nextStateTitle) {
    return ResetScenarioVariant(
      id: id,
      title: title,
      shortDescription: shortDescription,
      stateTitle: nextStateTitle,
      durationMinutes: durationMinutes,
      checklistItems: checklistItems,
    );
  }
}

class ResetScenario {
  const ResetScenario({
    required this.id,
    required this.stateTitle,
    required String title,
    required this.durationMinutes,
    required String description,
    required List<String> steps,
  }) : _title = title,
       _description = description,
       _steps = steps,
       _variants = const [],
       _defaultVariantId = null;

  const ResetScenario.withVariants({
    required this.id,
    required this.stateTitle,
    required this.durationMinutes,
    required List<ResetScenarioVariant> variants,
    required String defaultVariantId,
  }) : _title = null,
       _description = null,
       _steps = null,
       _variants = variants,
       _defaultVariantId = defaultVariantId;

  final String id;
  final String stateTitle;
  final int durationMinutes;
  final String? _title;
  final String? _description;
  final List<String>? _steps;
  final List<ResetScenarioVariant> _variants;
  final String? _defaultVariantId;

  List<ResetScenarioVariant> get variants {
    if (_variants.isNotEmpty) {
      return _variants;
    }

    return [
      ResetScenarioVariant(
        id: '$id-default',
        title: _title!,
        shortDescription: _description!,
        stateTitle: stateTitle,
        durationMinutes: durationMinutes,
        checklistItems: _steps!,
      ),
    ];
  }

  ResetScenarioVariant get defaultVariant {
    final defaultVariantId = _defaultVariantId;

    if (defaultVariantId == null) {
      return variants.first;
    }

    return variants.firstWhere(
      (variant) => variant.id == defaultVariantId,
      orElse: () => variants.first,
    );
  }

  String get title => defaultVariant.title;

  String get description => defaultVariant.shortDescription;

  List<String> get steps => defaultVariant.checklistItems;

  ResetScenario withStateTitle(String nextStateTitle) {
    return ResetScenario.withVariants(
      id: id,
      stateTitle: nextStateTitle,
      durationMinutes: durationMinutes,
      variants: variants
          .map((variant) => variant.withStateTitle(nextStateTitle))
          .toList(),
      defaultVariantId: defaultVariant.id,
    );
  }

  ResetScenario withSelectedVariant(ResetScenarioVariant variant) {
    return ResetScenario.withVariants(
      id: id,
      stateTitle: stateTitle,
      durationMinutes: durationMinutes,
      variants: [variant],
      defaultVariantId: variant.id,
    );
  }
}
