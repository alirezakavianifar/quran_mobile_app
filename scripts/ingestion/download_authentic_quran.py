import urllib.request
import json
import os

BASE_DIR = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
RAW_DIR = os.path.join(BASE_DIR, "data", "raw")
PROCESSED_DIR = os.path.join(BASE_DIR, "data", "processed")
os.makedirs(RAW_DIR, exist_ok=True)
os.makedirs(PROCESSED_DIR, exist_ok=True)

def fetch_json(url):
    print(f"Fetching: {url}")
    req = urllib.request.urlopen(url)
    return json.loads(req.read().decode('utf-8'))

def download_datasets():
    # 1. Arabic Uthmani Text
    ar_data = fetch_json("https://api.alquran.cloud/v1/quran/quran-uthmani")
    with open(os.path.join(RAW_DIR, "quran_uthmani.json"), "w", encoding="utf-8") as f:
        json.dump(ar_data, f, ensure_ascii=False, indent=2)

    # 2. Persian Makarem Shirazi Translation
    fa_data = fetch_json("https://api.alquran.cloud/v1/quran/fa.makarem")
    with open(os.path.join(RAW_DIR, "fa_makarem.json"), "w", encoding="utf-8") as f:
        json.dump(fa_data, f, ensure_ascii=False, indent=2)

    # 3. English Mustafa Khattab / Sahih Translation
    en_data = fetch_json("https://api.alquran.cloud/v1/quran/en.sahih")
    with open(os.path.join(RAW_DIR, "en_sahih.json"), "w", encoding="utf-8") as f:
        json.dump(en_data, f, ensure_ascii=False, indent=2)

    print("Authentic raw datasets downloaded successfully.")

if __name__ == "__main__":
    download_datasets()
