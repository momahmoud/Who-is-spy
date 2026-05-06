import os
import urllib.request

# Maps category id to Twemoji hex code
mapping = {
    "secret_agents": "1f575",       # 🕵️
    "90s_cartoons": "1f4fa",        # ��
    "act_it_out": "1f3ad",          # 🎭
    "animals": "1f42f",             # 🐯
    "anime_charachters": "2694",    # ⚔️
    "caroon_chrachters": "1f921",   # 🤡
    "countries": "1f30d",           # 🌍
    "disney_songs": "1f3b5",        # 🎵
    "disney": "1f3f0",              # 🏰
    "emotions": "1f602",            # 😂
    "english_movies": "1f3ac",      # 🎬
    "everydayitems": "2615",        # ☕
    "food": "1f355",                # ��
    "global_celebrities": "2b50",   # ⭐
    "netflix_tv": "1f37f",          # 🍿
    "party_challenges": "1f389",    # 🎉
    "superheroes": "1f9b8",         # 🦸
    "toy_brands": "1f916",          # 🤖
    "video_games": "1f3ae",         # 🎮
    "villains": "1f9b9"             # 🦹
}

BASE_URL = "https://raw.githubusercontent.com/twitter/twemoji/master/assets/svg/"
DEST_DIR = "assets/images/categories"

if not os.path.exists(DEST_DIR):
    os.makedirs(DEST_DIR)

for cat_id, hex_code in mapping.items():
    svg_url = f"{BASE_URL}{hex_code}.svg"
    dest_path = os.path.join(DEST_DIR, f"{cat_id}.svg")
    try:
        urllib.request.urlretrieve(svg_url, dest_path)
        print(f"Downloaded {cat_id}.svg")
    except Exception as e:
        print(f"Failed to fetch {cat_id}: {e}")

