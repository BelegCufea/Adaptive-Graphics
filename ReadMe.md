# Adaptive Graphics

A UE4SS mod for `Oblivion Remastered` that dynamically switches basic graphics settings based on your current location.

## Inspiration

This project was heavily inspired by [Disable lumen outdoors (vram - Performance fix)](https://www.nexusmods.com/oblivionremastered/mods/510).

All credit goes to the original author, [Baronysmith12](https://next.nexusmods.com/profile/Baronysmith12).

## Features

This mod allows you to define graphics settings depending on your location in the game.
Currently, it supports four location types:

- INDOOR – Areas inside buildings, caves, dungeons, etc.
- CITY – Inside city gates, but not within interior buildings.
- OBLIVION – Inside Oblivion gates.
- WORLD – Any outdoor area not covered by the categories above.

Settings are configured manually by editing the `AG_config.lua` file found in the `scripts` folder.
Each location type has its own configuration section. The structure is largely based on the original `Disable Lumen Outdoors` mod.

## Dependencies

[UE4SS for OblivionRemastered](https://www.nexusmods.com/oblivionremastered/mods/32)

## Instalation

1. Download and extract this mod.
2. Copy the entire `AdaptiveGraphics` folder structure into `\OblivionRemastered\Binaries\Win64\UE4SS\Mods`
