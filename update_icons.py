import os
import glob
import json
import urllib.request

# Maps category id to lucide icon name
mapping = {
    "secret_agents": "glasses",
    "90s_cartoons": "tv",
    "act_it_out": "drama",
    "animals": "cat",
    "anime_charachters": "swords",
    "caroon_chrachters": "smile",
    "countries": "globe",
    "disney_songs": "music",
    "disney": "castle",
    "emotions": "heart",
    "english_movies": "film",
    "everydayitems": "coffee",
    "food": "pizza",
    "global_celebrities": "star",
    "netflix_tv": "monitor-play",
    "party_challenges": "party-popper",
    "superheroes": "zap",
    "toy_brands": "bot",
    "video_games": "gamepad-2",
    "villains": "skull"
}

BASE_URL = "https://raw.githubusercontent.com/lucide-icons/lucide/main/icons/"
DEST_DIR = "assets/images/categories"

if not os.path.exists(DEST_DIR):
    os.makedirs(DEST_DIR)

# Fallback for icons that might not exist in Lucide
fallbacks = {
    "drama": "masks", 
    "masks": "venetian-mask",
    "pizza": "slice",
}

for cat_id, icon_name in mapping.items():
    svg_url = f"{BASE_URL}{icon_name}.svg"
    dest_path = os.path.join(DEST_DIR, f"{cat_id}.svg")
    try:
        urllib.request.urlretrieve(svg_url, dest_path)
    except urllib.error.HTTPError as e:
        print(f"Failed to fetch {icon_name}, trying fallback...")
        if icon_name in fallbacks:
            fallback = fallbacks[icon_name]
            svg_url = f"{BASE_URL}{fallback}.svg"
            try:
                urllib.request.urlretrieve(svg_url, dest_path)
            except:
                pass

        if not os.path.exists(dest_path):
            with open(dest_path, "w") as f:
                f.write(f'<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-{icon_name}"><circle cx="12" cy="12" r="10"/></svg>')
            print(f"Used circle for {cat_id}")

print("SVGs created.")

# Update JSON
dirs = ["assets/data/en", "assets/data/ar"]
for d in dirs:
    files = glob.glob(os.path.join(d, "*.json"))
    for f_path in files:
        if os.path.basename(f_path) == "categories_manifest.json": continue
        with open(f_path, "r") as f:
            data = json.load(f)
        
        cat_id = data.get("id")
        if cat_id:
            data["image"] = f"assets/images/categories/{cat_id}.svg"
            with open(f_path, "w") as fw:
                json.dump(data, fw, indent=2, ensure_ascii=False)

print("JSONs updated.")
