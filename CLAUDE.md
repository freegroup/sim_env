# SimEnv

A blind-accessible simulation environment — like a Tamagotchi, but for an entire world.

## Concept

Players navigate a living world by sound. Investments in environment, infrastructure, education,
and industry shape how the world sounds: pristine nature (seagulls, rivers, forest) when ecology
thrives; industrial noise (factories, traffic) when it suffers. The soundscape IS the UI.

## Tech Stack

| Layer | Package |
|---|---|
| State | `flutter_riverpod` |
| Routing | `go_router` |
| Audio | `just_audio` + `just_audio_background` |
| TTS / Narrator | `flutter_tts` |
| Persistence | `shared_preferences`, `sqflite` |

## Project Structure

```
lib/
  main.dart                  # Bootstrap + day-tick timer
  app.dart                   # MaterialApp.router + GoRouter
  core/
    models/
      world_state.dart       # WorldState, WorldZone
      investment.dart        # Investment model + catalogue
    state/
      world_notifier.dart    # Riverpod Notifier — game logic
    services/
      narrator_service.dart  # TTS wrapper
  audio/
    soundscape/
      sound_layers.dart      # Layer definitions + volume math
      soundscape_service.dart # Audio engine (just_audio)
  features/
    world_view/world_screen.dart      # Main dashboard
    navigation/navigation_screen.dart # Zone map
    investment/investment_screen.dart  # Investment list
assets/
  sounds/   # Replace placeholder .mp3 files with real audio
  data/     # Reserved for JSON world configs
```

## Audio Assets

Placeholder `.mp3` files live in `assets/sounds/`. Replace them with real recordings:

| File | Description |
|---|---|
| `factory_noise.mp3` | Heavy industry, metallic rumble |
| `traffic.mp3` | City traffic, honking |
| `city_ambience.mp3` | Quiet urban background |
| `people_talking.mp3` | Murmuring crowd |
| `people_laughing.mp3` | Joyful crowd |
| `birds_common.mp3` | Common city birds |
| `seagulls.mp3` | Seagulls, coastal feel |
| `wind_trees.mp3` | Wind through leaves |
| `river.mp3` | Flowing water |
| `forest_full.mp3` | Rich forest soundscape |

## Commands

```bash
flutter pub get          # Install dependencies
flutter run              # Run on connected device/simulator
flutter build apk        # Android release
flutter build ios        # iOS release
```

## Accessibility

Every interactive element has `Semantics` labels. The Narrator button on the main screen
reads the full world state aloud via TTS. Target: fully usable without looking at the screen.
