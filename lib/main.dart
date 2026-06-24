import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'audio/soundscape/soundscape_service.dart';
import 'core/services/narrator_service.dart';
import 'core/state/world_notifier.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Enable accessibility announcements for blind users
  SemanticsBinding.instance.ensureSemantics();

  runApp(
    const ProviderScope(
      child: _AppBootstrap(),
    ),
  );
}

class _AppBootstrap extends ConsumerStatefulWidget {
  const _AppBootstrap();

  @override
  ConsumerState<_AppBootstrap> createState() => _AppBootstrapState();
}

class _AppBootstrapState extends ConsumerState<_AppBootstrap> {
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    await ref.read(soundscapeServiceProvider).init();
    await ref.read(narratorProvider).init();

    // Day simulation: 30 s real time = 1 game day
    Stream.periodic(const Duration(seconds: 30)).listen((_) {
      ref.read(worldProvider.notifier).advanceDay();
    });

    // Keep soundscape in sync with world state changes
    ref.listenManual(worldProvider, (_, next) {
      ref.read(soundscapeServiceProvider).updateScore(next.soundscapeScore);
    });

    if (mounted) setState(() => _ready = true);
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }
    return const SimEnvApp();
  }
}
