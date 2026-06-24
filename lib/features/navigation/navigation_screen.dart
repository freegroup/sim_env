import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/world_state.dart';
import '../../core/services/narrator_service.dart';
import '../../core/state/world_notifier.dart';

class NavigationScreen extends ConsumerWidget {
  const NavigationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final world = ref.watch(worldProvider);
    final narrator = ref.read(narratorProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Erkunden')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Du bist im ${_zoneName(world.playerPosition)}',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Gesundheit dieser Zone: '
              '${(world.zoneHealth[world.playerPosition]! * 100).round()}%',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            _ZoneMap(
              current: world.playerPosition,
              zoneHealth: world.zoneHealth,
              onZoneSelected: (zone) {
                ref.read(worldProvider.notifier).movePlayer(zone);
                final name = _zoneName(zone);
                narrator.speak(
                  'Du bewegst dich in den $name. '
                  'Umweltgesundheit: ${(world.zoneHealth[zone]! * 100).round()} Prozent.',
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String _zoneName(WorldZone z) => switch (z) {
        WorldZone.north => 'Norden',
        WorldZone.east => 'Osten',
        WorldZone.south => 'Süden',
        WorldZone.west => 'Westen',
        WorldZone.center => 'Zentrum',
      };
}

class _ZoneMap extends StatelessWidget {
  const _ZoneMap({
    required this.current,
    required this.zoneHealth,
    required this.onZoneSelected,
  });

  final WorldZone current;
  final Map<WorldZone, double> zoneHealth;
  final void Function(WorldZone) onZoneSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ZoneButton(WorldZone.north, current, zoneHealth, onZoneSelected),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: _ZoneButton(
                    WorldZone.west, current, zoneHealth, onZoneSelected)),
            const SizedBox(width: 8),
            Expanded(
                child: _ZoneButton(
                    WorldZone.center, current, zoneHealth, onZoneSelected)),
            const SizedBox(width: 8),
            Expanded(
                child: _ZoneButton(
                    WorldZone.east, current, zoneHealth, onZoneSelected)),
          ],
        ),
        _ZoneButton(WorldZone.south, current, zoneHealth, onZoneSelected),
      ],
    );
  }
}

class _ZoneButton extends StatelessWidget {
  const _ZoneButton(this.zone, this.current, this.zoneHealth, this.onPressed);

  final WorldZone zone;
  final WorldZone current;
  final Map<WorldZone, double> zoneHealth;
  final void Function(WorldZone) onPressed;

  @override
  Widget build(BuildContext context) {
    final health = zoneHealth[zone] ?? 0.5;
    final isActive = zone == current;
    final label = switch (zone) {
      WorldZone.north => 'Norden',
      WorldZone.east => 'Osten',
      WorldZone.south => 'Süden',
      WorldZone.west => 'Westen',
      WorldZone.center => 'Zentrum',
    };

    return Padding(
      padding: const EdgeInsets.all(4),
      child: Semantics(
        button: true,
        selected: isActive,
        hint: '$label — Gesundheit ${(health * 100).round()}%',
        child: ElevatedButton(
          onPressed: () => onPressed(zone),
          style: ElevatedButton.styleFrom(
            backgroundColor:
                isActive ? Theme.of(context).colorScheme.primary : null,
            foregroundColor:
                isActive ? Theme.of(context).colorScheme.onPrimary : null,
            padding: const EdgeInsets.symmetric(vertical: 20),
          ),
          child: Column(
            children: [
              Text(label, style: const TextStyle(fontSize: 16)),
              Text('${(health * 100).round()}%',
                  style: const TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}
