import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/world_state.dart';
import '../models/investment.dart';

class WorldNotifier extends Notifier<WorldState> {
  @override
  WorldState build() => WorldState.initial();

  void movePlayer(WorldZone zone) {
    state = state.copyWith(playerPosition: zone);
  }

  /// Invest in the current zone and apply immediate + ongoing effects.
  bool invest(Investment investment) {
    if (state.budget < investment.cost) return false;

    final newZoneHealth = Map<WorldZone, double>.from(state.zoneHealth);
    newZoneHealth[state.playerPosition] = (newZoneHealth[state.playerPosition]! +
            investment.environmentDelta)
        .clamp(0.0, 1.0);

    state = state.copyWith(
      budget: state.budget - investment.cost,
      environmentHealth: state.environmentHealth + investment.environmentDelta,
      industryLevel: state.industryLevel + investment.industryDelta,
      happinessIndex: state.happinessIndex + investment.happinessDelta,
      population: state.population + investment.populationDelta,
      animalCount: state.animalCount + investment.animalDelta,
      zoneHealth: newZoneHealth,
    );
    return true;
  }

  /// Called once per day tick by the simulation timer.
  void advanceDay() {
    // Passive income scales with population and industry
    final income = state.population * 0.5 + state.industryLevel * 50;

    // Natural drift: high industry slowly degrades environment
    final envDrift = -state.industryLevel * 0.005;

    // Animals grow when environment is healthy, decline otherwise
    final animalDrift = state.environmentHealth > 0.5 ? 1 : -1;

    // Population grows with happiness, shrinks with low environment
    final popDrift = state.happinessIndex > 0.5 ? 1 : -1;

    state = state.copyWith(
      day: state.day + 1,
      budget: state.budget + income,
      environmentHealth: state.environmentHealth + envDrift,
      animalCount: state.animalCount + animalDrift,
      population: state.population + popDrift,
    );
  }
}

final worldProvider = NotifierProvider<WorldNotifier, WorldState>(WorldNotifier.new);
