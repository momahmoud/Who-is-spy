import shutil
import os

base = "assets/images/categories/"

copies = [
    ("caroon_chrachters.svg", "cartoon_characters.svg"),
    ("global_celebrities.svg", "celebrities.svg"),
    ("emotions.svg", "emotions_states.svg"),
    ("english_movies.svg", "movies.svg")
]

for src, dst in copies:
    src_path = os.path.join(base, src)
    dst_path = os.path.join(base, dst)
    if os.path.exists(src_path):
        shutil.copy(src_path, dst_path)
        print(f"Copied {src} to {dst}")
    else:
        print(f"File not found: {src_path}")
