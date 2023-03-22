#!/usr/bin/python3

from os import getenv
from pathlib import Path
import json
import subprocess

# Ensure the required paths are set and read the comic database
def setup():
	COMIC_PATH = getenv("COMIC_PATH")
	if COMIC_PATH is None:
		print(f"Error - COMIC_PATH environment variable is not set")
		exit(1)

	COMIC_PATH_HOSTED = getenv("COMIC_PATH_HOSTED")
	if COMIC_PATH_HOSTED is None:
		print(f"Error - COMIC_PATH environment variable is not set")
		exit(1)

	with open(Path(COMIC_PATH) / "comics.json") as f: comics = json.load(f)

	return Path(COMIC_PATH), Path(COMIC_PATH_HOSTED), comics["paths"]

# Create zip files for a comic
def zip_comic(comic, hosted_path, multi):
	# Make the hosted folder if it doesn't already exist
	Path(hosted_path / comic.name).mkdir(parents = True, exist_ok = True)
	print(f"Processing {comic.name}")

	# If we have multiple chapters, zip each of them, otherwise just the base folder
	if multi:
		for i, chapter in enumerate(comic.iterdir()):
			cmd = f'zip -ujq "{hosted_path}/{comic.name}/ch{i + 1}.zip" "{chapter}/"*'
			subprocess.run(cmd, shell=True)
	else:
		cmd = f'zip -ujq "{hosted_path}/{comic.name}/ch1.zip" "{comic}/"*'
		subprocess.run(cmd, shell=True)

if __name__ == "__main__":
	# Get required paths and folders to look for comics in
	COMIC_PATH, COMIC_PATH_HOSTED, paths = setup()

	# Extract all comic paths
	comics = []
	for comic in COMIC_PATH.iterdir():
		if "__" not in comic.name and comic.is_dir(): comics.append(comic)
	for path in paths:
		for comic in (COMIC_PATH / path).iterdir(): comics.append(comic)

	# Zip each comic
	for comic in comics:
		num_subdirs = len([x for x in comic.iterdir() if x.is_dir()])
		zip_comic(comic, COMIC_PATH_HOSTED, num_subdirs > 2)
