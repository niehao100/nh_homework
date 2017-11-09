import  json
from xmltodict import unparse
from stanfordcorenlp import StanfordCoreNLP



class People:
    details = []
    html = ""
    url = ""


if __name__ == "__main__":
    d = {}
    for i in range(1, 8):
        with open("data"+str(i)+".json",'r') as f:
            j = f.read()
            f.close()
            data = json.loads(j)
            for tmp in data['people']:
                data['people'][tmp]['details']=data['people'][tmp]['details'].replace("本页使用了 JavaScript 技术。若使本页能正常显示，请启用您浏览器的 JavaScript 功能。","")
            d = dict(d, **data["people"])
    with open("data.json", "w") as f:
        f.write( json.dumps({'people': d}))
    with open("data.xml", "w") as f:
        f.write(unparse({'people': d}))