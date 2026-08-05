import urllib.request
import re
import os

try:
    print("Fetching Play Store page for com.androidapp.digikhata...")
    html = urllib.request.urlopen("https://play.google.com/store/apps/details?id=com.androidapp.digikhata").read().decode("utf-8")
    match = re.search(r'<meta property="og:image" content="(https://play-lh\.googleusercontent\.com/[^\"]+)"', html)
    if match:
        url = match.group(1).replace("=w240-h480-rw", "=s512-rw")
        print("Downloading:", url)
        os.makedirs("assets", exist_ok=True)
        urllib.request.urlretrieve(url, "assets/icon.png")
        print("Saved to assets/icon.png")
    else:
        print("Failed to find icon URL using meta tag.")
except Exception as e:
    print("Error:", e)
