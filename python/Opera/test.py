from stanfordcorenlp import StanfordCoreNLP
import  re
import  sys
import os


class People:
    name = ""
    teacher = []
    student = []
    birthloc =[]
    school = []
    map = {}

    def __init__(self):
        self.name = ""
        self.teacher = []
        self.student = []
        self.birthloc = []
        self.school = []
        self.map = {}

    def single(self):
        self.teacher = list(set(self.teacher))
        self.student = list(set(self.student))
        self.birthloc = list(set(self.birthloc))
        self.school = list(set(self.school))


def anay(s,nlp):
    p = People()
    for word in nlp.ner(s[0:50]):
        if(word[1] == 'PERSON' and len(word[0])>=2):
            p.name = word[0]
            break
    l_s = re.findall("生于.{0,30}?。",s)
    l_s.extend(re.findall(".{2,5}?人。", s))
    for l in l_s:
        for word in nlp.ner(l):
            if (word[1] == 'GPE' or word[1] == 'LOCATION' or word[1]=='DEMONYM'):
                p.birthloc.append(word[0])
    t_s = re.findall("拜.{0,30}?师",s)
    t_s.extend(re.findall("拜师.{0,30}?。",s))
    t_s.extend(re.findall("师从.{0,30}?。",s))
    t_s.extend(re.findall("跟.{0,30}?学习",s))
    t_s.extend(re.findall("从.{0,30}?学习",s))
    t_s.extend(re.findall("随.{0,30}?学习",s))
    for t in t_s:
        for word in nlp.ner(t):
            if (word[1] == 'PERSON' and word[0] != p.name):
                p.teacher.append(word[0])
    s_s = re.findall("考入.{3,15}?学院",s)
    s_s.extend(re.findall("考入.{3,15}?学校",s))
    s_s.extend(re.findall("考入.{3,15}?大学",s))
    s_s.extend(re.findall("毕业.{3,15}?学校",s))
    s_s.extend(re.findall("毕业.{3,15}?学院",s))
    s_s.extend(re.findall("毕业.{3,15}?大学",s))
    for s in s_s:
        flag = 1
        for word in nlp.pos_tag(s[2:len(s)]):
            if (word[1] == 'VV' or word[1] == 'DEG'):
                flag = 0
        if (flag == 1):
            p.school.append(s[2:len(s)])
    s_s = re.findall("从.{3,15}?毕业",s)
    s_s.extend(re.findall("在.{3,15}?毕业",s))
    s_s.extend(re.findall("至.{3,15}?学习",s))
    s_s.extend(re.findall("到.{3,15}?学习",s))
    s_s.extend(re.findall("在.{3,15}?学习",s))
    s_tmp = re.findall("入.{2,10}?班",s)
    p.school.extend(s_tmp[1:len(s_tmp)])
    for s in s_s:
        flag = 1
        for word in nlp.pos_tag(s[1:len(s) - 2]):
            if (word[1] == 'VV' or word[1] == 'DEG'):
                flag = 0
        if (flag == 1):
            p.school.append(s[1:len(s) - 2])
    for t in p.teacher:
        print(p.name+' 师徒  '+t)
    for bl in p.birthloc:
        print(p.name+' 出生地  '+bl)
    for  s in p.school:
        print(p.name+' 习艺  '+s)


if __name__ == "__main__":
    dir = sys.argv[1]
    nlp = StanfordCoreNLP("./lib/", lang='zh', memory='8g')
    list = os.listdir(dir)
    for line in list:
        filepath=os.path.join(dir,line)
        print(filepath)
        with open(filepath,'r') as f:
            s=f.read()
            anay(s,nlp)






