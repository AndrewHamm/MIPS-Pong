MIPS-PONG
==========

The age-old game of pong implemented in MIPS assembly.  Please excuse our mess. It's a work in progress!

This is meant to be run in the MARS simulator.  It uses both the Bitmap Dislay and the Keyboard and Display MIMO Simulator tools.

The MARS simulator had a bug a threading bug involving using multiple tools. A fix was published by the internet user [Confect](https://dtconfect.wordpress.com/2013/02/09/mars-mips-simulator-lockup-hackfix/). We also used Confect's [MIPS snake game](https://dtconfect.wordpress.com/projects/year2/mips-snake-and-primlib/) as a learning source.

## Demo

![Gif of Gameplay]
(https://raw.githubusercontent.com/AndrewHamm/MIPS-Pong/master/GamePlay.gif)

## How To Run

1. Open the Mars .jar file from our repo.
2. Load the pong.asm file into Mars with File -> Open.
3. Go to Run -> Assemble
4. Go to tools -> Bitmap Display
5. The Bitmap Display settings should be as follows:
  - Unit Width: 8
  - Unit Height: 8
  - Display Width: 512
  - Display Height: 256
  - Base Address: $gp
6. Go to tools -> Keyboard and Display MMIO Simulator
7. Press connect to MIPS on both of the displays
8. Go to Run -> Go
9. All controls should take place in the lower portion of the Keyboard and Display Simulator

## Controls

For 1 player press 1
For 2 player press 2

Player 1 moves using the A and Z keys.
Player 2 moves using the K and M keys.
