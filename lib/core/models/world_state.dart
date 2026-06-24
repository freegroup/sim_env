/// The health of the world expressed as a 0.0–1.0 score.
/// 0.0 = fully industrial wasteland, 1.0 = pristine nature.
enum WorldZone { north, east, south, west, center }

class WorldState {
  final double environmentHealth; // 0.0–1.0
  final double industryLevel;     // 0.0–1.0
  final int population;
  final int animalCount;
  final double happinessIndex;    // 0.0–1.0
  final Map<WorldZone, double> zoneHealth;
  final WorldZone playerPosition;
  final int day;
  final double budget;

  const WorldState({
    required this.environmentHealth,
    required this.industryLevel,
    required this.population,
    required this.animalCount,
    required this.happinessIndex,
    required this.zoneHealth,
    required this.playerPosition,
    required this.day,
    required this.budget,
  });

  factory WorldState.initial() => WorldState(
        environmentHealth: 0.5,
        industryLevel: 0.3,
        population: 100,
        animalCount: 50,
        happinessIndex: 0.5,
        zoneHealth: {for (final z in WorldZone.values) z: 0.5},
        playerPosition: WorldZone.center,
        day: 1,
        budget: 1000.0,
      );

  WorldState copyWith({
    double? environmentHealth,
    double? industryLevel,
    int? population,
    int? animalCount,
    double? happinessIndex,
    Map<WorldZone, double>? zoneHealth,
    WorldZone? playerPosition,
    int? day,
    double? budget,
  }) =>
      WorldState(
        environmentHealth:
            (environmentHealth ?? this.environmentHealth).clamp(0.0, 1.0),
        industryLevel:
            (industryLevel ?? this.industryLevel).clamp(0.0, 1.0),
        population: (population ?? this.population).clamp(0, 9999),
        animalCount: (animalCount ?? this.animalCount).clamp(0, 9999),
        happinessIndex:
            (happinessIndex ?? this.happinessIndex).clamp(0.0, 1.0),
        zoneHealth: zoneHealth ?? Map.from(this.zoneHealth),
        playerPosition: playerPosition ?? this.playerPosition,
        day: day ?? this.day,
        budget: (budget ?? this.budget).clamp(0.0, double.infinity),
      );

  /// Composite score used to select the soundscape layer.
  double get soundscapeScore =>
      environmentHealth * 0.6 + happinessIndex * 0.3 + (1.0 - industryLevel) * 0.1;

  @override
  String toString() =>
      'WorldState(day=$day, env=${environmentHealth.toStringAsFixed(2)}, '
      'industry=${industryLevel.toStringAsFixed(2)}, pop=$population, '
      'animals=$animalCount, happiness=${happinessIndex.toStringAsFixed(2)}, '
      'budget=${budget.toStringAsFixed(0)})';
}
