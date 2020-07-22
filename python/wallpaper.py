#!/usr/bin/env python
# -*- coding:utf-8 -*-
# -*- author:neil -*-
# python抓取bing主页所有背景图片
import requests
from bs4 import BeautifulSoup
import re,sys,os
def get_bing_backphoto():
    if (os.path.exists('photos')== False):
        os.mkdir('photos')
    Path=sys.path[0]
    for i in range(0,1):
        url = 'https://cn.bing.com/'
        html = requests.get(url)
        if html == 'null':
            print ('open & read bing error!')
            sys.exit(-1)
        #reg = re.compile('"url":"(.*?)","urlbase"',re.S)
        #text = re.findall(reg,html.__str__())
        #http://s.cn.bing.net/az/hprichbg/rb/LongJi_ZH-CN8658435963_1366x768.jpg
        soup = BeautifulSoup(html.text,"html.parser")
        text = soup.find_all(id='bgImgProgLoad')
        for imgurl in text:
            imgurl = imgurl['data-ultra-definition-src']
            imgurl = imgurl.replace("1920","3840")
            imgurl = imgurl.replace("1080","2160")
            name = imgurl[11:imgurl.find('&')]
            print(name)
            savepath = Path +'/photos/'+ name
            pic = requests.get('http://cn.bing.com'+imgurl).content
            with open(savepath,'wb') as f:
                f.write(pic)
                f.close()
            cmd="/usr/bin/gsettings set org.gnome.desktop.background picture-uri file:///"+savepath
            os.system(cmd)
            print(name + ' save success!')
get_bing_backphoto()        
