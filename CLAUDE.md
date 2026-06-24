# SimEnv

**SimEnv** (Simulation Environment) is a mobile app designed for **blind and visually impaired people**
that lets them experience, navigate, and shape a living virtual world — entirely through sound.

## Vision

Inspired by Tamagotchi, SimEnv gives the player custody of a world they cannot see but can
*hear*. The soundscape is the only interface that matters. The world lives and breathes:
people laugh or fall silent, birds appear or vanish, factories roar or go quiet — all depending
on how the player invests their resources.

The core question the game asks is: **What kind of world do you want to hear?**

A player who invests in nature reserves and parks will eventually hear seagulls, a flowing river,
children laughing in the park, and a forest full of life. A player who builds factories and chemical
plants will hear industrial noise, traffic, and a world with no animals left. Most players will end
up somewhere in between — and the layered soundscape reflects exactly that balance.

The world is alive on its own too: every 30 seconds a new day passes, populations grow or shrink,
animals return or disappear, and the budget refills based on what was built. The player can move
between five zones (north, south, east, west, center) and invest locally — each zone develops
independently and contributes to the overall world sound.

**Accessibility is not a feature — it is the foundation.** Every screen is fully navigable
by voice via the built-in TTS Narrator, all buttons have semantic labels, and the app is designed
to be used without ever looking at the screen.

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
