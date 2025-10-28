# 🕯️ Into The Darkness

**Into The Darkness** is a *side-scrolling runner* developed in **Z80 Assembly** for the **Amstrad CPC**, using [**CPCTELERA**](https://github.com/lronaldo/cpctelera) environment.  
You must run away from a relentless monster while collecting oil flasks to keep your lantern burning.  
If the light goes out… darkness wins.

---

## 🎮 Gameplay

- Run to the right to escape from the monster.
- Dodge obstacles and collect **oil flasks** to keep your lantern lit.
- As the lantern fades, the monster will get closer...
- The goal is simple: **collect all flasks!**.

*(You can place a screenshot or gameplay GIF here)*  
`![Into The Darkness screenshot](images/screenshot.png)`

---

## 🧩 Project Structure

The project is split into several `.asm` modules to keep the code organized and maintainable:

| File | Description |
|------|--------------|
| [`main.asm`](./main.asm) | Entry point of the game. Initializes memory, graphics, and the main loop. |
| [`player.asm`](./player.asm) | Handles player movement, collision detection, and running/jumping animations. |
| [`monster.asm`](./monster.asm) | Controls the monster’s behavior and chasing logic. |
| [`oil.asm`](./oil.asm) | Manages oil flask spawning, collection, and lantern energy depletion. |
| [`graphics.asm`](./graphics.asm) | Loads and draws sprites and background elements. |
| [`input.asm`](./input.asm) | Reads keyboard input and translates it into in-game actions. |
| [`sound.asm`](./sound.asm) | Contains sound and music routines (if available). |

*(Adjust filenames according to your repository)*

---

## ⚙️ Development

The game was entirely built in **Z80 Assembly**, developed and tested using [**CPCTELERA**](https://github.com/lronaldo/cpctelera).
My part of the development focused on:

- Spawners of oil flasks and obstacles, aplying movement to them and creating the scrolling sensation.
- AI behavior, making the monster follow the players position
- Composing and implementing the music, loading it into the game's memory.

---
3. Run the following command:

