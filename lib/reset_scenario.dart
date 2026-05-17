class ResetScenario {
  const ResetScenario({
    required this.id,
    required this.stateTitle,
    required this.title,
    required this.durationMinutes,
    required this.description,
    required this.steps,
  });

  final String id;
  final String stateTitle;
  final String title;
  final int durationMinutes;
  final String description;
  final List<String> steps;
}
