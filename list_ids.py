import json
import glob

all_ids = set()
for d in ['assets/data/en', 'assets/data/ar']:
    for f in glob.glob(f'{d}/*.json'):
        if 'manifest' in f: continue
        with open(f, 'r') as file:
            try:
                data = json.load(file)
                if 'id' in data:
                    all_ids.add(data['id'])
            except:
                pass
print("ALL IDs:", sorted(list(all_ids)))
