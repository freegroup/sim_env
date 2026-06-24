/// Soundscape layer definition.
/// Each layer maps to an audio asset and is faded in/out based on the world score.
class SoundLayer {
  final String id;
  final String assetPath;
  final double minScore; // world score threshold to start fading in
  final double maxScore; // score at which this layer is at full volume
  final bool loop;

  const SoundLayer({
    required this.id,
    required this.assetPath,
    required this.minScore,
    required this.maxScore,
    this.loop = true,
  });
}

/// All soundscape layers ordered from most degraded to most pristine.
/// Assets are placeholders — replace with real audio files in assets/sounds/.
const List<SoundLayer> kSoundLayers = [
  // Low score (0.0–0.3): industrial noise
  SoundLayer(
    id: 'factory_noise',
    assetPath: 'assets/sounds/factory_noise.mp3',
    minScore: 0.0,
    maxScore: 0.2,
  ),
  SoundLayer(
    id: 'traffic',
    assetPath: 'assets/sounds/traffic.mp3',
    minScore: 0.1,
    maxScore: 0.35,
  ),

  // Mid score (0.3–0.6): quiet city, some nature returning
  SoundLayer(
    id: 'city_ambience',
    assetPath: 'assets/sounds/city_ambience.mp3',
    minScore: 0.25,
    maxScore: 0.5,
  ),
  SoundLayer(
    id: 'people_talking',
    assetPath: 'assets/sounds/people_talking.mp3',
    minScore: 0.3,
    maxScore: 0.55,
  ),

  // Good score (0.5–0.75): people laughing, first birds
  SoundLayer(
    id: 'people_laughing',
    assetPath: 'assets/sounds/people_laughing.mp3',
    minScore: 0.45,
    maxScore: 0.65,
  ),
  SoundLayer(
    id: 'birds_common',
    assetPath: 'assets/sounds/birds_common.mp3',
    minScore: 0.5,
    maxScore: 0.7,
  ),

  // High score (0.7–1.0): rich nature — seagulls, wind, river
  SoundLayer(
    id: 'seagulls',
    assetPath: 'assets/sounds/seagulls.mp3',
    minScore: 0.65,
    maxScore: 0.85,
  ),
  SoundLayer(
    id: 'wind_trees',
    assetPath: 'assets/sounds/wind_trees.mp3',
    minScore: 0.7,
    maxScore: 0.9,
  ),
  SoundLayer(
    id: 'river',
    assetPath: 'assets/sounds/river.mp3',
    minScore: 0.75,
    maxScore: 0.95,
  ),
  SoundLayer(
    id: 'forest_full',
    assetPath: 'assets/sounds/forest_full.mp3',
    minScore: 0.85,
    maxScore: 1.0,
  ),
];

/// Compute the target volume (0.0–1.0) for a layer given the current score.
double layerVolume(SoundLayer layer, double score) {
  if (score < layer.minScore) return 0.0;
  if (score > layer.maxScore) return 1.0;
  final range = layer.maxScore - layer.minScore;
  if (range == 0) return 1.0;
  return (score - layer.minScore) / range;
}
