import  json
from xmltodict import unparse
from stanfordcorenlp import StanfordCoreNLP
import  re
class people:
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
        self.map['teacher']=self.teacher
        self.map['student'] = self.student
        self.map['birthloc']=self.birthloc
        self.map['school']=self.school
        return self.map

if __name__ == "__main__":
    with open("../json/data.json", 'r') as f:
        j = f.read()
        f.close()
        data = json.loads(j)['people']
    with open("../json/name.json", 'r') as f:
        j = f.read()
        f.close()
        name= json.loads(j)['people']
    nlp = StanfordCoreNLP("../lib/",lang='zh',memory='8g')
    plist = {}
    for d in data:
        p = people()
        l_s = re.findall("生于.{0,30}?。" ,data[d]['details'])
        l_s.extend(re.findall(".{2,5}?人。", s))
        for l in l_s:
            for word in nlp.ner(l):
                if (word[1] == 'GPE' or word[1] == 'LOCATION' or word[1]=='DEMONYM'):
                    p.birthloc.append(word[0])
        t_s = re.findall("拜.{0,30}?师", data[d]['details'])
        t_s.extend(re.findall("拜师.{0,30}?。", data[d]['details']))
        t_s.extend(re.findall("师从.{0,30}?。", data[d]['details']))
        t_s.extend(re.findall("跟.{0,30}?学习", data[d]['details']))
        t_s.extend(re.findall("从.{0,30}?学习", data[d]['details']))
        t_s.extend(re.findall("随.{0,30}?学习", data[d]['details']))
        for t in t_s:
            for word in nlp.ner(t):
                if (word[1] == 'PERSON' and word[0] != d):
                    p.teacher.append(word[0])
        s_s = re.findall("考入.{3,15}?学院", data[d]['details'])
        s_s.extend(re.findall("考入.{3,15}?学校", data[d]['details']))
        s_s.extend(re.findall("考入.{3,15}?大学", data[d]['details']))
        s_s.extend(re.findall("毕业.{3,15}?学校", data[d]['details']))
        s_s.extend(re.findall("毕业.{3,15}?学院", data[d]['details']))
        s_s.extend(re.findall("毕业.{3,15}?大学", data[d]['details']))
        for s in s_s:
            flag= 1
            for word in nlp.pos_tag(s[2:len(s)]):
                     if(word[1]=='VV' or word[1]=='DEG' ):
                         flag=0
            if(flag == 1):
                p.school.append(s[2:len(s)])
        s_s=re.findall("从.{3,15}?毕业", data[d]['details'])
        s_s.extend(re.findall("在.{3,15}?毕业", data[d]['details']))
        s_s.extend(re.findall("至.{3,15}?学习", data[d]['details']))
        s_s.extend(re.findall("到.{3,15}?学习", data[d]['details']))
        s_s.extend(re.findall("在.{3,15}?学习", data[d]['details']))
        s_tmp = re.findall("入.{2,10}?班", data[d]['details'])
        p.school.extend(s_tmp[1:len(s_tmp)])
        p.school.extend(data[d]['school'].split(' '))
        for s in s_s:
            flag = 1
            for word in nlp.pos_tag(s[1:len(s)-2]):
                if (word[1] == 'VV' or word[1] == 'DEG'):
                    flag = 0
            if (flag == 1):
                p.school.append(s[1:len(s)-2])
        plist[d] = p.single()
    with open("../json/relate.json", "w") as f:
        f.write(json.dumps({'people': plist}))
    with open("../json/relate.xml", "w") as f:
        f.write(unparse({'people': plist}))




