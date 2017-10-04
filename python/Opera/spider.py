import urllib3
from bs4 import BeautifulSoup


def get_html(url):
    http = urllib3.PoolManager()
    r = http.request('GET', url)
    return r


class People:
    name = ""
    artname = ""
    sex = ""
    hangdang = ""
    genre = ""
    pic = ""
    artistic = ""
    detail = ""
    f = []
    s = []
    html = ""
    url = ""

    def update_url(self, url):
        self.url = url
        html_tmp = get_html(url)
        s_t = BeautifulSoup(html_tmp.data)
        self.html = s_t.find_all("div", {"class": "Rnamer"})
        

if __name__ == "__main__":
    html = get_html("http://www.jingju.com/jingjurenwu/yuantuanmingjia/")
    soup = BeautifulSoup(html.data)
    ulist = soup.find_all("a", {"class": "c963"})
    plist =[]
    for url in ulist:
        p_t = People()
        p_t.update_url("http://www.jingju.com/" + url['href'])
        plist.append(p_t)
    print(plist)

