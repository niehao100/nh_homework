# -*- coding: utf-8 -*-
import urllib3
from bs4 import BeautifulSoup
import re
import json


def get_html(url):
    http = urllib3.PoolManager()
    r = http.request('GET', url)
    return r


class People(object):
    name = ""
    artname = ""
    birth = ""
    details = {}
    relate = []
    html = ""
    url = ""

    def __init__(self):
        self.details = {}

    def update_url(self):
        html_tmp = get_html(self.url)
        s_t = BeautifulSoup(html_tmp.data)
        soup = s_t.find_all("div", {"id": "article"})
        h1 = soup[0].h1.text
        h1 = re.findall("（.*?）", h1)[0]
        self.artname = h1[1:len(h1)-1]
        namecard = soup.find_all("div", {"class": "namecard"})[0]
        print(namecard.text)
        s =""
        titles = re.findall("\n.+?：",s)
        details = re.split("\n.+?：", s)
        details.remove(details[0])
        for detail in details:
            if(detail == '\n'):
                details.remove(detail)
        for i in range(0,len(details)):
            title = titles[i].replace('\n', '')
            title = title.replace('：', '')
            title = title.replace('\xa0', '')
            title = title.replace('\u3000', '')
            detail = details[i].replace('\n', '')
            detail = detail.replace('\r', '')
            detail = detail.replace('\xa0', '')
            detail = detail.replace(' ', '')
            self.details[title] = detail


def get_artists(url, plist):
    html = get_html(url)
    soup = BeautifulSoup(html.data)
    ulist = soup.find_all("li", {"class": "bullet"})
    for u in ulist:
        p_t = People()
        p_t.url="http://history.xikao.com/" + u.a['href']
        p_t.name=u.a.text
        plist.append(p_t)


if __name__ == "__main__":
    plist = []
    get_artists("http://history.xikao.com/directory/%E4%BA%AC%E5%89%A7/%E7%94%9F%E8%A1%8C%E6%BC%94%E5%91%98", plist)
    get_artists("http://history.xikao.com/directory/%E4%BA%AC%E5%89%A7/%E6%97%A6%E8%A1%8C%E6%BC%94%E5%91%98", plist)
    for i in range(0,1):
        plist[0].update_url()
    j = json.dumps(plist, ensure_ascii=False)
    with open("data.json", "w") as f:
        f.write(j)


