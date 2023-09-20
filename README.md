# FPGA Snake Game

This is a Snake Game implemented in VHDL for an FPGA platform. The game is designed to run on a VGA display and uses various components to control the game logic, user input, and rendering.

## Game Overview

The Snake Game is a classic arcade game where the player controls a snake that moves around the screen, eating food to grow longer. The player must avoid running into walls or the snake's own body. The goal is to eat as much food as possible and achieve a high score.

## FPGA Components

The game is divided into several components, each with its specific functionality:

- **Game Entity**: `game` - The top-level entity that connects all the components and manages the game's main logic.
- **Clock and Input Handling**: `clk_wiz_0` - Clock generator component for generating a 65 MHz clock signal from a 100 MHz input clock.I used clock wizard IP core in Vivado instead of custom clock divider. `buttons` - Component for handling user input from buttons and determining the snake's direction and game pause state.
- **VGA Display**: `Sync_VGA` - VGA synchronization component responsible for generating VGA signals (HSync and VSync) and managing the display's timing parameters.
- **Game Logic**: `game_logic` - The core game logic component that handles snake movement, collision detection, food generation, and scoring.
- **Rendering**: `draw` - Component responsible for rendering game objects on the VGA display, including the snake, food, and the game score. `score` - Component for displaying the player's score on the VGA screen.

## How to Use

To use this Snake Game on an FPGA platform, follow these steps:

1. Connect the VGA output to a VGA-compatible display.
2. Connect the buttons or input interface to the FPGA.
3. Ensure that the FPGA is programmed with the VHDL design.
4. Power on the FPGA.
5. Use the connected buttons to control the snake's movement (Up, Down, Left, Right) and to pause the game.
6. Eat the food, avoid collisions, and try to achieve the highest score possible!

## Customization

You can customize various aspects of the game by modifying the generic parameters in the `game_logic` and `sync_vga` components. These parameters include screen resolution, initial snake position, food generation parameters, and more.

Feel free to modify the game's visuals or add additional features to enhance the gameplay.

## License

This project is open-source.  Everyone is permitted to copy and distribute verbatim or modified
copies of this license document, and changing it is allowed as long
as the name is changed. Feel free to use, modify, and distribute it as needed.

Enjoy playing the Snake Game on your FPGA platform!
