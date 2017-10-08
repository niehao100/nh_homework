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
    details = {}
    html = ""
    url = ""

    def __init__(self):
        self.details = {}

    def update_url(self, url):
        self.url = url
        html_tmp = get_html(url)
        s_t = BeautifulSoup(html_tmp.data,from_encoding="gb18030")
        self.html = s_t.find_all("div", {"class": "Rnamer"})
        news_tmp = s_t.find_all("span", {"class": "Ltxt"})
        news = ""
        for new in news_tmp:
            news = news + ";" + new.text
        s = self.html[0].text
        self.details["all"] = s
        self.details["url"] = url
        s = s.replace('。','。\n')
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
    soup = BeautifulSoup(html.data,from_encoding="gb18030")
    ulist = soup.find_all("a", {"class": "c963"})
    for u in ulist:
        p_t = People()
        p_t.update_url("http://www.jingju.com/" + u['href'])
        plist.append(p_t.details)


if __name__ == "__main__":
    plist = []
    url = "http://www.jingju.com/jingjurenwu/yuantuanmingjia/"
    get_artists(url, plist)
    for i in range(2, 20):
        get_artists(url+"index_"+str(i)+".html", plist)
    plist = {'plist': plist}
    j = json.dumps(plist, ensure_ascii=False)
    with open("data.json", "w") as f:
        f.write(j)


