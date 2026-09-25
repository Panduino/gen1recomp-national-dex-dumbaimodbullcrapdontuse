# Battle Effect Colors

A standalone Gen1Recomp graphics mod that gives battle-move animation sprites actual colors instead of the default monochrome appearance.

Examples: Fire -> orange/red; Water -> ocean blue; Electric -> yellow; Grass -> green; Ice -> cyan/blue; Psychic -> pink/purple; Poison -> purple; Ground -> tan/brown; Rock -> brown; Flying -> sky blue; Ghost -> violet; Dragon -> blue.

## How it works

Gen1Recomp's battle renderer already has a color callback for the animation sprite layer. This mod wraps BattleState:animSpriteColors() and returns a themed three-shade palette for selected animation IDs. Everything not listed falls back to the engine's normal behavior.

No animation graphics are replaced, so the original pixel art and timing stay unchanged.

## Installation

Copy the battle_effect_colors folder into the game's mods directory. The mod is standalone.

## Customizing

Edit PALETTES in main.lua. Each palette contains light, mid, and dark RGB values. Add animation IDs to ANIM_PALETTES as needed.