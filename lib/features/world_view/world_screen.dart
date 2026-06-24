import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/models/world_state.dart';
import '../../core/services/narrator_service.dart';
import '../../core/state/world_notifier.dart';

class WorldScreen extends ConsumerWidget {
  const WorldScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final world = ref.watch(worldProvider);
    final narrator = ref.read(narratorProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('SimEnv — Deine Welt')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _StatusCard(world: world),
            const SizedBox(height: 24),
            _WorldDescriptionCard(world: world),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _BigButton(
                    label: 'Erkunden',
                    icon: Icons.explore,
                    semanticsHint: 'Bewege dich durch die Welt',
                    onPressed: () => context.push('/navigate'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _BigButton(
                    label: 'Investieren',
                    icon: Icons.account_balance,
                    semanticsHint: 'Investiere in deine Welt',
                    onPressed: () => context.push('/invest'),
                  ),
                ),
              ],
            ),
            const Spacer(),
            _BigButton(
              label: 'Status vorlesen',
              icon: Icons.record_voice_over,
              semanticsHint: 'Lässt den aktuellen Weltzustand vorlesen',
              onPressed: () => narrator.speak(_worldSummary(world)),
            ),
          ],
        ),
      ),
    );
  }

  String _worldSummary(WorldState w) {
    final envPct = (w.environmentHealth * 100).round();
    final happyPct = (w.happinessIndex * 100).round();
    return 'Tag ${w.day}. '
        'Du befindest dich im ${_zoneName(w.playerPosition)}. '
        'Umweltgesundheit: $envPct Prozent. '
        'Bevölkerung: ${w.population} Menschen. '
        'Tiere: ${w.animalCount}. '
        'Glück: $happyPct Prozent. '
        'Budget: ${w.budget.toStringAsFixed(0)} Credits.';
  }

  String _zoneName(WorldZone z) => switch (z) {
        WorldZone.north => 'Norden',
        WorldZone.east => 'Osten',
        WorldZone.south => 'Süden',
        WorldZone.west => 'Westen',
        WorldZone.center => 'Zentrum',
      };
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.world});
  final WorldState world;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tag ${world.day}',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            _Bar('Umwelt', world.environmentHealth, Colors.green),
            _Bar('Industrie', world.industryLevel, Colors.orange),
            _Bar('Glück', world.happinessIndex, Colors.blue),
            const SizedBox(height: 8),
            Text(
              'Bevölkerung: ${world.population}  •  Tiere: ${world.animalCount}  •  Budget: ${world.budget.toStringAsFixed(0)} ₡',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar(this.label, this.value, this.color);
  final String label;
  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: ${(value * 100).round()}%'),
          LinearProgressIndicator(value: value, color: color, minHeight: 8),
        ],
      ),
    );
  }
}

class _WorldDescriptionCard extends StatelessWidget {
  const _WorldDescriptionCard({required this.world});
  final WorldState world;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          _describe(world),
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }

  String _describe(WorldState w) {
    if (w.soundscapeScore > 0.8) {
      return 'Die Luft ist frisch, Vögel singen und Möwen kreisen über dem Fluss. '
          'Die Menschen lachen laut und Kinder spielen im Park.';
    } else if (w.soundscapeScore > 0.6) {
      return 'Erste Vogelstimmen sind zu hören. '
          'Die Leute unterhalten sich freundlich, das Leben kehrt langsam zurück.';
    } else if (w.soundscapeScore > 0.4) {
      return 'Stadtgeräusche dominieren — Autos, leises Gemurmel. '
          'Einzelne Bäume stehen zwischen den Gebäuden.';
    } else if (w.soundscapeScore > 0.2) {
      return 'Das Dröhnen der Fabriken liegt in der Luft. '
          'Kaum Grünflächen, die Stimmung ist gedrückt.';
    } else {
      return 'Ein industrielles Ödland. '
          'Rauch, Lärm und keine Tiere. Es riecht nach Abgasen.';
    }
  }
}

class _BigButton extends StatelessWidget {
  const _BigButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    required this.semanticsHint,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final String semanticsHint;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      hint: semanticsHint,
      button: true,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 28),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
