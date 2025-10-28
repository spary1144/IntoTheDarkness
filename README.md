# 🕯️ Into The Darkness

**Into The Darkness** is a *side-scrolling runner* developed in **Z80 Assembly** for the **Amstrad CPC**, using [**CPCTELERA**](https://github.com/lronaldo/cpctelera) environment and ECS arquitecture.
You must run away from a relentless monster while collecting oil flasks to keep your lantern burning.  
If the light goes out… darkness wins.

---

## 🎮 Gameplay

- Run to the right to escape from the monster.
- Dodge obstacles and collect **oil flasks** to keep your lantern lit.
- As the lantern fades, the monster will get closer...
- The goal is simple: **collect all flasks!**.
<!--
*(You can place a screenshot or gameplay GIF here)*  
`![Into The Darkness screenshot](images/screenshot.png)`
-->
---

## 🧩 Project Structure

The project is split into several `.asm` modules to keep the code organized and maintainable:

| File | Description |
|------|--------------|
| [`main.s`](.src/main.s) | Entry point of the game. Initializes memory, graphics, and the main loop. |
| [`ia_manager.s`](.src/ia_manager.s) | Controls the monster’s behavior and chasing logic. |
| [`game_manager.s`](.src/game_manager.s) | Initializes all entities, with its components and controls the game flow |
| [`physics.s`](.src/physics.s) | Controls the positions of the entities involved in the game |
| [`input.s`](.src/input.s) | Reads keyboard input and translates it into in-game actions. |

---

## ⚙️ Development

The game was entirely built in **Z80 Assembly**, developed and tested using [**CPCTELERA**](https://github.com/lronaldo/cpctelera).
My part of the development focused on:

- Spawners of oil flasks and obstacles, aplying movement to them and creating the scrolling sensation.
- Collision detection system, making the player pick up the flasks or moved by the obstacles and getting him closer to the monter.
- AI behavior, making the monster follow the players position
- Composing and implementing the music, loading it into the game's memory.

---
3. Run the following command:

