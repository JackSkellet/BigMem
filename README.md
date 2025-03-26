# BigMem

Some Performance Tweaks for Balatro

![Build Status](https://img.shields.io/badge/build-passing-brightgreen)
![Version](https://img.shields.io/badge/version-0.0.1-blue)

## Table of Contents
- [Introduction](#introduction)
- [Features](#features)
  - [Math Optimizations](#math-optimizations)
  - [Visual Tweaks](#visual-tweaks)
  - [Experimental Stuff](#experimental-stuff)
- [Screenshots](#screenshots)
- [Installation](#installation)
- [Contributing](#contributing)
- [License](#license)

## Introduction
BigMem is a Balatro mod focused on one thing: performance.

I made this mod because I play with Jens Almanac Modpack for Balatro, and after a while... things get chonky. Crashes, lag. BigMem dives into the internals of Lua math and some minor animation handling to keep things smooth.

Use at your own risk. Compatibility with other mods or hardware is not guaranteed.

## Features

### Math Optimizations
- **fastPow** – Optimized power function.
- **fastLog10**, **fastExp**, **fastSqrt**, and more!
- **memoization** – Caches expensive math results.
- Large number versions available (e.g., fastPowLarge).
- You even get:
  - tetration, pentation, hexation, heptation, octation — for those big brain exponential moments.

### Visual Tweaks
- **reduceAnimations** – Fewer fancy effects = faster frames.
- **disableParticles** – Turns off particles.
- **limitFramerate** – Keeps your framerate reasonable (60/144/240/Unlimited).
- **hideDeck** and **hideConsumables** – Less stuff = less work.

### Experimental Stuff
- **enableBatching** – Batches calculations together.
- **fastBinomial**, **fastFibonacci**, **fastReciprocalSqrt**, and more!
- **rainbowTint** – Tries to show a BRB message (currently doesn't work 🤷‍♂️).

## Screenshots
### Before BigMem
<img alt="Before" src="https://preview.redd.it/vagabonds-most-likely-inspiration-v0-1luf50uujr9d1.jpg?width=142&amp;format=pjpg&amp;auto=webp&amp;s=874fa6b2f120c4d5514bfc38e68ad55985f765d1">

### After BigMem
<img alt="After" src="https://static.wikia.nocookie.net/balatrogame/images/4/40/Jolly_Joker.png/revision/latest/thumbnail/width/360/height/360?cb=20240320232234">

Dramatization. May not represent actual gameplay.

## Installation
1. Drop the mod in the mods folder
2. Open mod menu and find BigMem
3. Set the settings you want
4. Play game
5. ????
6. Performance

## Contributing
Contributions are welcome!

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
