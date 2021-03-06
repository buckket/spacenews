#!/usr/bin/env python

import datetime
import glob
import os
import subprocess
import time
import xml.etree.ElementTree as ET
import email.utils

import cv2
import pytesseract
import youtube_dl

tessdata_dir_config = r'--tessdata-dir "tessdata"'


def main():
    ydl = youtube_dl.YoutubeDL({"format": "best", "download_archive": "downloaded_videos"})
    ydl.download(["https://www.youtube.com/channel/UCJRR3CPEVpT03fUsozSmFgA/videos"])

    root = ET.Element("root")
    try:
        tree = ET.parse(os.path.join("gh-pages", "spacenews.xml"))
        root = tree.getroot()
    except (ET.ParseError, FileNotFoundError) as e:
        print("Could not parse old data, starting fresh ({})".format(e))

    for video in sorted(glob.glob("*.mp4"), key=os.path.getmtime):
        if root.find("video[@video='{}']".format(video)):
            print("Skipping video {}".format(video))
            continue

        subprocess.run(["ffmpeg", "-i", video, "-r", "0.25", "output_%04d.png"], stderr=subprocess.DEVNULL)
        files = sorted([x for x in glob.glob('*.png')])
        img_a = cv2.imread(files.pop(0), cv2.IMREAD_COLOR)
        for file in files:
            img_b = cv2.imread(file, cv2.IMREAD_COLOR)
            corr = cv2.matchTemplate(img_a, img_b, cv2.TM_CCOEFF_NORMED)[0][0]
            if corr > 0.9:
                os.remove(file)
            else:
                img_a = img_b

        video_id = video[-15:-4]
        mtime = os.path.getmtime(video)

        item = ET.SubElement(root, "video")
        item.set("video", video)
        item.set("url", "https://www.youtube.com/watch?v={}".format(video_id))
        item.set("isotime", datetime.datetime.fromtimestamp(mtime).isoformat())
        item.set("pubDate", email.utils.formatdate(mtime))

        video_folder = os.path.join("gh-pages", video_id)
        os.makedirs(video_folder, exist_ok=True)
        for counter, file in enumerate(sorted(glob.glob('*.png'))):
            img = cv2.imread(file, cv2.IMREAD_COLOR)
            text = pytesseract.image_to_string(img, lang='deu+eng', config=tessdata_dir_config).replace('\x0c', '')
            os.rename(file, os.path.join(video_folder, "{}.png".format(counter)))
            subprocess.run(["optipng", "-o7", os.path.join(video_folder, "{}.png".format(counter))],
                           stderr=subprocess.DEVNULL)
            image = ET.SubElement(item, "image")
            image.set("filename", os.path.join(video_id, "{}.png".format(counter)))
            image.text = text.strip()
        print("New video {} from {}".format(video, time.ctime(mtime)))

    with open(os.path.join("gh-pages", "spacenews.xml"), "w") as file:
        ET.indent(root)
        file.write('<?xml version="1.0" encoding="UTF-8" ?>\n')
        file.write('<?xml-stylesheet type="text/xsl" href="spacenews.xsl"?>\n')
        file.write(ET.tostring(root, encoding="unicode"))


if __name__ == '__main__':
    main()
