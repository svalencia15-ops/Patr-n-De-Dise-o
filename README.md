# Catch the Falling Stars — Godot 4 Starter Project

A simple 2D game to get comfortable with Godot before the Coin Collector project.

## How to open

1. Download and install Godot 4 from https://godotengine.org/download (Standard version)
2. Open Godot, click **Import**
3. Navigate to this folder and select `project.godot`
4. Click **Import & Edit**
5. Press **F5** to run the game

## How to play

- **Arrow keys** or **A/D** — move the basket left and right
- Catch the falling stars to score points
- Miss 3 stars and it's game over
- Press **Enter** to restart after game over

## Project structure

```
catch_game/
├── project.godot       — Godot project config
├── scenes/
│   ├── main.tscn       — the main game scene
│   └── object.tscn     — the falling star scene (instanced at runtime)
├── scripts/
│   ├── main.gd         — game logic, spawning, score, lives
│   ├── player.gd       — player movement
│   └── object.gd       — falling object movement
└── assets/
    ├── player.svg      — basket graphic
    └── star.svg        — falling star graphic
```

## Things to try once it runs

These are suggestions — not assignments. Just explore.

1. **Change the speed** — find `SPEED` in `player.gd` and `speed` in `object.gd`. Make the game easier or harder.
2. **Change the spawn rate** — find `SpawnTimer` in the scene tree. Change its `wait_time` in the Inspector.
3. **Add a second type of object** — create a new scene that looks different and subtracts score when caught.
4. **Make it get harder over time** — increase fall speed every 5 points scored.
5. **Add a sound** — add an `AudioStreamPlayer` node and play a sound when a star is caught.

## How signals are used in this project

Even in this small game, Godot's Signal system (Observer pattern) is doing real work:

- `SpawnTimer.timeout` → triggers `_on_spawn_timer_timeout` in main.gd (spawns a new star)
- `object.area_entered` → triggers `_on_object_caught` in main.gd (detects a catch)
- `object.tree_exiting` → triggers `_on_object_missed` in main.gd (detects a miss)

None of these nodes call each other directly. They communicate through signals.
