import  json

class People:
    details = []
    html = ""
    url = ""


if __name__ == "__main__":
    with open("data.json",'r') as f:
        j = f.read()
    data = json.loads(j)
    klist = []
    for p in data['plist']:
        for k in p:
            k = k.replace('\"', "\'")
            klist.append(k)
            print(k+':'+p[k])
    klist = list(set(klist))
    print(klist)