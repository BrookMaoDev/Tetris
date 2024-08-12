# Tetris in MIPS Assembly

This project is a MIPS assembly implementation of the classic Tetris game, developed as a final project for the Computer Organization course at the University of Toronto.

## Running the Game

To run the Tetris game, follow these steps:

1. **Install MARS:** Ensure that you have the MARS MIPS simulator installed on your machine.
2. **Open Keyboard and Display MMIO Simulator:**

    - In MARS, go to **Tools > Keyboard and Display MMIO Simulator**.
    - Keep this simulator window open.

3. **Open Bitmap Display:**

    - Go to **Tools > Bitmap Display** in MARS.
    - Configure the Bitmap Display according to the settings provided in the preamble of the `tetris.asm` file.
    - These settings match those in the video demo.
    - Keep this window open as well.

4. **Connect to MIPS:**

    - Ensure that both the Keyboard and Display MMIO Simulator and Bitmap Display are connected to the MIPS processor.

5. **Assemble and Run:**
    - Load `tetris.asm` in MARS.
    - Assemble the code by clicking the **Assemble** button.
    - Press **Run** to start playing Tetris.

### Controls

Use the Keyboard and Display MMIO Simulator to control the game:

-   **A**: Move left
-   **D**: Move right
-   **W**: Spin
-   **S**: Speed up drop
