import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/investment.dart';
import '../../core/services/narrator_service.dart';
import '../../core/state/world_notifier.dart';

class InvestmentScreen extends ConsumerWidget {
  const InvestmentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final world = ref.watch(worldProvider);
    final narrator = ref.read(narratorProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Investieren  •  ${world.budget.toStringAsFixed(0)} ₡'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: kAvailableInvestments.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, i) {
          final inv = kAvailableInvestments[i];
          final canAfford = world.budget >= inv.cost;
          return _InvestmentCard(
            investment: inv,
            canAfford: canAfford,
            onInvest: () {
              final success =
                  ref.read(worldProvider.notifier).invest(inv);
              if (success) {
                narrator.speak(
                  '${inv.name} wurde gebaut. '
                  '${_effectSummary(inv)}',
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${inv.name} gebaut!')),
                );
              } else {
                narrator.speak('Nicht genug Credits für ${inv.name}.');
              }
            },
            onReadAloud: () => narrator.speak(
              '${inv.name}. ${inv.description} Kosten: ${inv.cost.toStringAsFixed(0)} Credits. '
              '${_effectSummary(inv)}',
            ),
          );
        },
      ),
    );
  }

  String _effectSummary(Investment inv) {
    final parts = <String>[];
    if (inv.environmentDelta != 0) {
      parts.add(
          'Umwelt ${inv.environmentDelta > 0 ? "+" : ""}${(inv.environmentDelta * 100).round()}%');
    }
    if (inv.industryDelta != 0) {
      parts.add(
          'Industrie ${inv.industryDelta > 0 ? "+" : ""}${(inv.industryDelta * 100).round()}%');
    }
    if (inv.happinessDelta != 0) {
      parts.add(
          'Glück ${inv.happinessDelta > 0 ? "+" : ""}${(inv.happinessDelta * 100).round()}%');
    }
    if (inv.animalDelta != 0) {
      parts.add(
          'Tiere ${inv.animalDelta > 0 ? "+" : ""}${inv.animalDelta}');
    }
    return parts.join(', ');
  }
}

class _InvestmentCard extends StatelessWidget {
  const _InvestmentCard({
    required this.investment,
    required this.canAfford,
    required this.onInvest,
    required this.onReadAloud,
  });

  final Investment investment;
  final bool canAfford;
  final VoidCallback onInvest;
  final VoidCallback onReadAloud;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    investment.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                Text(
                  '${investment.cost.toStringAsFixed(0)} ₡',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: canAfford
                        ? colorScheme.primary
                        : colorScheme.error,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(investment.description),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Semantics(
                    hint: 'Baut ${investment.name} für ${investment.cost.toStringAsFixed(0)} Credits',
                    button: true,
                    child: ElevatedButton(
                      onPressed: canAfford ? onInvest : null,
                      child: const Text('Bauen'),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Semantics(
                  hint: 'Liest Informationen zu ${investment.name} vor',
                  button: true,
                  child: IconButton.outlined(
                    icon: const Icon(Icons.record_voice_over),
                    onPressed: onReadAloud,
                    tooltip: 'Vorlesen',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
