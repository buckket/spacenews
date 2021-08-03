#!/usr/bin/env python
import datetime
import glob
import os
import subprocess
import time
import xml.etree.ElementTree as ET

import cv2
import numpy as np
import pytesseract
import youtube_dl


def main():
    #ydl = youtube_dl.YoutubeDL({})
    #ydl.download(["https://www.youtube.com/channel/UCJRR3CPEVpT03fUsozSmFgA/videos"])

    data = ET.Element('root')

    for video in sorted(glob.glob("*.mkv"), key=os.path.getmtime):
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

        text = []
        for file in sorted(glob.glob('*.png')):
            img = cv2.imread(file, cv2.IMREAD_GRAYSCALE)
            kernel = np.ones((1, 1), np.uint8)
            img = cv2.dilate(img, kernel, iterations=1)
            img = cv2.erode(img, kernel, iterations=1)
            _, img = cv2.threshold(img, 127, 255, cv2.THRESH_BINARY+cv2.THRESH_OTSU)
            text.append(pytesseract.image_to_string(img, lang='deu+eng').replace('\x0c', ''))
            os.remove(file)

        item = ET.SubElement(data, "video")
        item.set("video", video)
        item.set("url", "https://www.youtube.com/watch?v={}".format(video[-15:-4]))
        item.set("timestamp", str(os.path.getmtime(video)))
        item.set("isotime", datetime.datetime.fromtimestamp(os.path.getmtime(video)).isoformat())
        item.text = '\n'.join(text).rstrip()
        print("New video {} from {}".format(video, time.ctime(os.path.getmtime(video))))

    with open("spacenews.xml", "w") as file:
        ET.indent(data)
        file.write('<?xml version="1.0" encoding="UTF-8" ?>\n')
        file.write('<?xml-stylesheet type="text/xsl" href="spacenews.xsl"?>\n')
        file.write(ET.tostring(data, encoding="unicode"))


if __name__ == '__main__':
    main()
