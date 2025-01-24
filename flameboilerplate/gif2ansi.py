#!/usr/bin/env python3

import sys
import time
from math import sqrt
from PIL import Image, ImageSequence

# Optional: Adjust these for your ASCII "pixels"
BLOCK_CHAR = "█"  # Full block

# For speed and simplicity, we use a precomputed palette of 256 colors
# for the terminal (indexed 0-255). We'll find the nearest color in the palette.
# We can store the (r, g, b) values for each of the 256 terminal colors in a list
def generate_ansi_palette_256():
    """Return a list of (r,g,b) for the 256-color ANSI palette."""
    # 0-15 are the basic + bright colors
    # 16-231 form a 6x6x6 color cube
    # 232-255 are grayscale ramp
    palette = []

    # 0-15 standard + bright colors (we could define explicitly, but let's skip exact mapping)
    # We'll approximate by also building them via color cube logic
    for i in range(16):
        palette.append((0, 0, 0))  # Placeholder, override if needed

    # 16-231: 6x6x6 color cube
    for r in range(6):
        for g in range(6):
            for b in range(6):
                palette.append((
                    int(r * 255 / 5),
                    int(g * 255 / 5),
                    int(b * 255 / 5),
                ))

    # 232-255: Grayscale ramp (24 steps)
    for i in range(24):
        val = int(8 + (i * 10))  # range is 8..238
        palette.append((val, val, val))

    return palette

ANSI_PALETTE_256 = generate_ansi_palette_256()

def nearest_ansi_color_index(r, g, b):
    """Find the nearest color index in ANSI_PALETTE_256 for the pixel (r,g,b)."""
    best_index = 0
    min_distance = float('inf')
    for i, (pr, pg, pb) in enumerate(ANSI_PALETTE_256):
        # Euclidean distance in RGB space
        dist = (r - pr)**2 + (g - pg)**2 + (b - pb)**2
        if dist < min_distance:
            min_distance = dist
            best_index = i
    return best_index

def frame_to_ansi(frame):
    """
    Convert a PIL image frame to ANSI strings row by row.
    Return a list of strings, each representing one row in ANSI color.
    """
    frame = frame.convert("RGB")
    width, height = frame.size

    output_lines = []
    for y in range(height):
        row_str = []
        for x in range(width):
            r, g, b = frame.getpixel((x, y))
            ansi_index = nearest_ansi_color_index(r, g, b)
            # Construct ANSI escape for foreground color in 256-color mode
            # \x1b[38;5;<color>m   sets the FG color
            color_code = f"\x1b[38;5;{ansi_index}m"
            row_str.append(f"{color_code}{BLOCK_CHAR*2}")  # 2 blocks wide
        # Reset color at end of line
        row_str.append("\x1b[0m")
        output_lines.append("".join(row_str))
    return output_lines

def main():
    if len(sys.argv) < 2:
        print("Usage: python gif2ansi.py <path_to_gif>")
        sys.exit(1)

    gif_path = sys.argv[1]

    try:
        im = Image.open(gif_path)
    except Exception as e:
        print(f"Error opening GIF: {e}")
        sys.exit(1)

    # Iterate frames
    for frame_idx, frame in enumerate(ImageSequence.Iterator(im)):
        # Convert each frame to ANSI
        ansi_lines = frame_to_ansi(frame)

        # Clear screen
        # \x1b[2J = clear screen, \x1b[H = move cursor to top-left
        print("\x1b[2J\x1b[H", end='')

        # Print the ANSI lines
        for line in ansi_lines:
            print(line)

        # Respect frame duration if available
        # The Pillow "info" dict for GIF frames often uses 'duration' in milliseconds
        duration_ms = frame.info.get('duration', 100)  # default 100ms
        time.sleep(duration_ms / 1000.0)

    # Reset ANSI color after completion
    print("\x1b[0m")

if __name__ == "__main__":
    main()
