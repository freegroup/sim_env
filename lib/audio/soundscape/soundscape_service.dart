import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'sound_layers.dart';

class SoundscapeService {
  final Map<String, AudioPlayer> _players = {};

  Future<void> init() async {
    for (final layer in kSoundLayers) {
      final player = AudioPlayer();
      try {
        await player.setAsset(layer.assetPath);
        await player.setLoopMode(layer.loop ? LoopMode.one : LoopMode.off);
        await player.setVolume(0.0);
        player.play();
      } catch (_) {
        // Asset may not exist yet during development — silent fail
      }
      _players[layer.id] = player;
    }
  }

  /// Update all layer volumes to match the new world score.
  Future<void> updateScore(double score) async {
    for (final layer in kSoundLayers) {
      final player = _players[layer.id];
      if (player == null) continue;
      final targetVolume = layerVolume(layer, score);
      await player.setVolume(targetVolume);
    }
  }

  Future<void> dispose() async {
    for (final player in _players.values) {
      await player.dispose();
    }
    _players.clear();
  }
}

final soundscapeServiceProvider = Provider<SoundscapeService>((ref) {
  final service = SoundscapeService();
  ref.onDispose(service.dispose);
  return service;
});
