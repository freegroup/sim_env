import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';

class NarratorService {
  final FlutterTts _tts = FlutterTts();

  Future<void> init() async {
    await _tts.setLanguage('de-DE');
    await _tts.setSpeechRate(0.45);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);
  }

  Future<void> speak(String text) async {
    await _tts.stop();
    await _tts.speak(text);
  }

  Future<void> stop() async => _tts.stop();

  Future<void> dispose() async => _tts.stop();
}

final narratorProvider = Provider<NarratorService>((ref) {
  final service = NarratorService();
  ref.onDispose(service.dispose);
  return service;
});
