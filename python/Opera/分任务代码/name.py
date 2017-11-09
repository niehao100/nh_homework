import   json
from xmltodict import unparse
from stanfordcorenlp import StanfordCoreNLP
import pynlpir


class people:
    name = ""
    p = []
    org = []
    misc = []
    loc =[]
    map = {}

    def __init__(self):
        name = ""
        self.p = []
        self.org = []
        self.misc = []
        self.loc = []
        self.map = {}
    def single(self):
        self.p = list(set(self.p))
        self.org = list(set(self.org))
        self.misc = list(set(self.misc))
        self.loc = list(set(self.loc))
        self.map['p']=self.p
        self.map['org'] = self.org
        self.map['misc']=self.misc
        self.map['loc']=self.loc

if __name__ == "__main__":
    pynlpir.open()
    with open("../json/data.json", 'r') as f:
        j = f.read()
        f.close()
        data = json.loads(j)['people']
    nlp = StanfordCoreNLP("../lib/", lang='zh', memory='8g')
    plist = {}
    for d in data:
        p = people()
        for word in nlp.ner(data[d]['details']):
            p.name= d
            if(word[1]=="PERSON"):
                p.p.append(word[0])
            elif(word[1]=='ORDINAL'):
                p.p.append(word[0])
            elif(word[1]=="MISC"):
                p.misc.append(word[0])
            elif(word[1]=='GPE' or word[1]=='LOCATION'):
                p.loc.append(word[0])
        p.misc.extend(data[d]['record'].split(' '))
        p.loc.extend(data[d]['school'].split(' '))
        p.single()
        plist[d] = p.map
    with open("../json/name.json", "w") as f:
        f.write(json.dumps({'people': plist}))
    with open("../json/name.xml", "w") as f:
        f.write(unparse({'people': plist}))




