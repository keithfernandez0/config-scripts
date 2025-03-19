import os
import random
import piexif
import curses
from PIL import Image

def zero_out_exif(image_path):
    """Remove all EXIF metadata from an image."""
    try:
        img = Image.open(image_path)
        img.save(image_path, "jpeg", exif=piexif.dump({}))
        return f"[DONE] Cleared EXIF data for: {image_path}"

    except Exception as e:
        return f"[!] Error clearing EXIF for {image_path}: {e}"

def randomize_exif(image_path):
    """Randomize EXIF metadata with junk data."""
    try:
        img = Image.open(image_path)

        # Retrieve EXIF safely
        exif_bytes = img.info.get("exif", b"")

        if not exif_bytes:
            return f"[!] No EXIF data to randomize: {image_path}"

        try:
            exif_dict = piexif.load(exif_bytes)

        except Exception:
            return f"[!] Error parsing EXIF for {image_path}: Invalid EXIF data"

        # Randomize EXIF entries
        for ifd in exif_dict:
            for tag in exif_dict[ifd]:
                if isinstance(exif_dict[ifd][tag], bytes):
                    exif_dict[ifd][tag] = bytes(random.choices(b"abcdefghijklmnopqrstuvwxyz0123456789", k=10))
                elif isinstance(exif_dict[ifd][tag], (int, float)):
                    exif_dict[ifd][tag] = random.randint(0, 9999)

        # Save changes
        exif_bytes = piexif.dump(exif_dict)
        img.save(image_path, "jpeg", exif=exif_bytes)

        return f"[DONE] Randomized EXIF data for: {image_path}"

    except Exception as e:
        return f"[!] Error randomizing EXIF for {image_path}: {e}"


def read_exif_data(image_path):
    """Read and return EXIF metadata from an image."""
    try:
        img = Image.open(image_path)
        exif_data = img.info.get("exif", b"")
        exif_dict = piexif.load(exif_data) if exif_data else {}

        if not exif_dict:
            return f"[!] No EXIF data found: {image_path}"

        output_lines = [f"[DONE] EXIF for {image_path}:"]
        for ifd in exif_dict:
            for tag, value in exif_dict[ifd].items():
                tag_name = piexif.TAGS[ifd].get(tag, {"name": str(tag)})["name"]
                if isinstance(value, bytes):  # Decode byte values safely
                    value = value.decode(errors="ignore")  # Ignore decoding errors
                output_lines.append(f"  {tag_name}: {value}")

        return "\n".join(output_lines)

    except Exception as e:
        return f"[!] Error reading EXIF for {image_path}: {e}"


def process_directory(directory, mode):
    """Process all images in a directory."""
    results = []
    for file in os.listdir(directory):
        if file.lower().endswith((".jpg", ".jpeg", ".png")):
            file_path = os.path.join(directory, file)
            if mode == "zero":
                results.append(zero_out_exif(file_path))
            elif mode == "random":
                results.append(randomize_exif(file_path))
            elif mode == "read":
                results.append(read_exif_data(file_path))
    return results

def tui(stdscr):
    curses.curs_set(0)
    stdscr.clear()
    stdscr.addstr(1, 2, r"""
  ______________       _____      ______________
  ___  __ \__  /_________  /________  ____/__  /__________ ____________________
  __  /_/ /_  __ \  __ \  __/  __ \  /    __  /_  _ \  __ `/_  __ \  _ \_  ___/
  _  ____/_  / / / /_/ / /_ / /_/ / /___  _  / /  __/ /_/ /_  / / /  __/  /
  /_/     /_/ /_/\____/\__/ \____/\____/  /_/  \___/\__,_/ /_/ /_/\___//_/

                   By: Keith Michelangelo Fernandez
    A tool for scrubbing EXIF metadata on bulk media files, photos, etc.

                  """, curses.A_BOLD)
    stdscr.addstr(11, 2, "[*] Welcome to the PhotoCleaner!")
    stdscr.addstr(12, 2, "[?] Select an option:")
    stdscr.addstr(14, 4, "[1] - Zero out all EXIF data.")
    stdscr.addstr(15, 4, "[2] - Randomize EXIF data.")
    stdscr.addstr(16, 4, "[3] - Read existing EXIF data.")
    stdscr.addstr(17, 4, "[q] - Quit.")
    stdscr.refresh()

    while True:
        key = stdscr.getch()

        if key == ord('1'):
            results = process_directory(os.getcwd(), "zero")
            stdscr.clear()
            stdscr.addstr(2, 2, "[DONE] EXIF Data Cleared:")
            for i, res in enumerate(results[:10]):
                stdscr.addstr(4 + i, 4, res)
            stdscr.addstr(15, 2, "[*] Press any key to return to the menu...")
            stdscr.getch()

        elif key == ord('2'):
            results = process_directory(os.getcwd(), "random")
            stdscr.clear()
            stdscr.addstr(2, 2, "[DONE] EXIF Data Randomized:")
            line = 4
            for res in results[:10]:
                for exif_line in res.split("\n"):  # Ensure each line prints separately
                    stdscr.addstr(line, 4, exif_line)
                    line += 1
            stdscr.addstr(15, 2, "[*] Press any key to return to the menu...")
            stdscr.getch()

        elif key == ord('3'):
            results = process_directory(os.getcwd(), "read")
            stdscr.clear()
            stdscr.addstr(2, 2, "[DONE] EXIF Data Read:")
            for i, res in enumerate(results[:10]):
                stdscr.addstr(4 + i, 4, res)
            stdscr.addstr(15, 2, "[*] Press any key to return to the menu...")
            stdscr.getch()

        elif key in [ord('q'), ord('Q')]:
            break


        stdscr.clear()
        stdscr.addstr(1, 2, r"""
          ______________       _____      ______________
          ___  __ \__  /_________  /________  ____/__  /__________ ____________________
          __  /_/ /_  __ \  __ \  __/  __ \  /    __  /_  _ \  __ `/_  __ \  _ \_  ___/
          _  ____/_  / / / /_/ / /_ / /_/ / /___  _  / /  __/ /_/ /_  / / /  __/  /
          /_/     /_/ /_/\____/\__/ \____/\____/  /_/  \___/\__,_/ /_/ /_/\___//_/

                           By: Keith Michelangelo Fernandez
            A tool for scrubbing EXIF metadata on bulk media files, photos, etc.

                          """, curses.A_BOLD)
        stdscr.addstr(11, 2, "[*] Welcome to the PhotoCleaner!")
        stdscr.addstr(12, 2, "[?] Select an option:")
        stdscr.addstr(14, 4, "[1] - Zero out all EXIF data.")
        stdscr.addstr(15, 4, "[2] - Randomize EXIF data.")
        stdscr.addstr(16, 4, "[3] - Read existing EXIF data.")
        stdscr.addstr(17, 4, "[q] - Quit.")
        stdscr.refresh()

if __name__ == "__main__":
    curses.wrapper(tui)
