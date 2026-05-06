import os
import urllib.request

mapping = {
    "arab_celebs": "1f929",       # 🤩 Star-Struck
    "arab_movies": "1f4fd",       # 📽️ Film Projector
    "arab_series": "1f4fa",       # 📺 TV
    "mbc3": "1f9f8",              # 🧸 Teddy bear
    "ramadan_series": "1f319",    # 🌙 Crescent moon
    "spacetoon": "1f680",         # 🚀 Rocket
    "sports_athletes": "26bd"     # ⚽ Soccer ball
}

BASE_URL = "https://raw.githubusercontent.com/twitter/twemoji/master/assets/svg/"
DEST_DIR = "assets/images/categories"

for cat_id, hex_code in mapping.items():
    svg_url = f"{BASE_URL}{hex_code}.svg"
    dest_path = os.path.join(DEST_DIR, f"{cat_id}.svg")
    try:
        urllib.request.urlretrieve(svg_url, dest_path)
        print(f"Downloaded {cat_id}.svg")
    except Exception as e:
        print(f"Failed to fetch {cat_id}: {e}")

