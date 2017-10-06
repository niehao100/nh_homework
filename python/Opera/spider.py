# -*- coding: utf-8 -*-
import urllib3
from bs4 import BeautifulSoup
import re
import json


def get_html(url):
    http = urllib3.PoolManager()
    r = http.request('GET', url)
    return r


class People:
    details = []
    html = ""
    url = ""

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
        s = s.replace('。','。\n')
        titles = re.findall("\n.+?：",s)
        details = re.split("\n.+?：", s)
        details.remove(details[0])
        for detail in details:
            if(detail == '\n'):
                details.remove(detail)
        for i in range(0,len(details)):
            self.details.append({'key':titles[i],'value':details[i]})


if __name__ == "__main__":
    html = get_html("http://www.jingju.com/jingjurenwu/yuantuanmingjia/")
    soup = BeautifulSoup(html.data,from_encoding="gb18030")
    ulist = soup.find_all("a", {"class": "c963"})
    plist =[]
    for url in ulist:
        p_t = People()
        p_t.update_url("http://www.jingju.com/" + url['href'])
        plist.append(p_t.details)
    j = json.dumps(plist, ensure_ascii=False)
    f = open("data.json","w")
    print(j)
    f.write(j)
    f.close()


