# -*- coding: utf-8 -*-
import urllib3
from bs4 import BeautifulSoup
import re
import json


class People(object):
    name = " "
    artname = " "
    birth = " "
    death = " "
    classify = [" "]
    school = " "
    record = " "
    details = " "
    relate = " "
    html =""
    url = " "
    j = {}

    def __init__(self):
        self.name = " "
        self.artname = " "
        self.birth = " "
        self.death = " "
        self.classify = [" "]
        self.school = " "
        self.record = " "
        self.details = " "
        self.url = " "
        self.j = {}

    def update_url(self):
        html_tmp = get_html(self.url)
        s_t = BeautifulSoup(html_tmp.data,"lxml")
        soup = s_t.find_all("div", {"id": "article"},"lxml")
        h1 = soup[0].h1.text
        h1 = re.findall("（.*?）", h1)
        if(len(h1)>1):
            self.artname = h1[0][1:len(h1)-1]
        namecard = soup[0].find_all("div", {"class": "namecard"})[0]
        self.birth = re.findall("出生：.+?年", namecard.text)
        if(len(self.birth)>0):
            self.birth = self.birth[0][3:len(self.birth[0])]
        self.death = re.findall("逝世：.+?年", namecard.text)
        if (len(self.death) > 0):
            self.death = self.death[0][3:len(self.death[0])]
        self.classify.extend(re.findall(".行演员", namecard.text))
        self.classify.extend(re.findall(".剧", namecard.text))
        if (len(re.findall("教师", namecard.text))>=1):
            self.classify.append("教师")
        school = re.findall("科班院校.+?老唱片", namecard.text);
        if(len(school)==1):
            self.school = school[0][4:len(school)-3]
        else:
            school = re.findall("科班院校.+?\n", namecard.text)
            if (len(school) == 1):
                self.school = school[0][4:len(school) - 1]
        record = re.findall("老唱片.+?\n", namecard.text);
        if (len(record) == 1):
            self.record = record[0][4:len(school) - 3]
        self.details=s_t.td.text.replace(namecard.text, "\n")

    def serlize(self):
        self.j["name"] = self.name
        self.j["artname"] = self.artname
        self.j["birth"] = self.birth
        self.j["death"] = self.death
        self.j["classify"] = self.classify
        self.j["school"] = self.school
        self.j["record"] = self.record
        self.j["details"] = self.details
        self.j["relate"] = self.relate
        self.j["html"] = self.html
        self.j["url"] = self.url


def get_artists(url, plist):
    html = get_html(url)
    soup = BeautifulSoup(html.data,"lxml")
    ulist = soup.find_all("li", {"class": "bullet"})
    for u in ulist:
        p_t = People()
        p_t.url="http://history.xikao.com/" + u.a['href']
        p_t.name=u.a.text
        plist.append(p_t)


def get_html(url):
    http = urllib3.PoolManager()
    r = http.request('GET', url)
    return r


if __name__ == "__main__":
    plist = []
    get_artists("http://history.xikao.com/directory/%E4%BA%AC%E5%89%A7/%E7%94%9F%E8%A1%8C%E6%BC%94%E5%91%98", plist)
    get_artists("http://history.xikao.com/directory/%E4%BA%AC%E5%89%A7/%E6%97%A6%E8%A1%8C%E6%BC%94%E5%91%98", plist)
    jlist = {}
    i=0
    for i in range(1001,1011):
        p=plist[i]
        p.update_url()
        p.serlize()
        jlist[p.name] = p.j
        print(i)
    j = json.dumps({'people':jlist}, ensure_ascii=False)
    with open("data7.json", "w") as f:
        f.write(j)


