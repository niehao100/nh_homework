import  json

class People:
    details = []
    html = ""
    url = ""


if __name__ == "__main__":
    with open("data.json",'r') as f:
        j = f.read()
        f.close()
    j = j.replace(' ', '')
    with open("data.json", 'w') as f:
        f.write(j)
    data = json.loads(j)
    klist = []
    for p in data['plist']:
        for k in p:
            k = k.replace('\"', "\'")
            if(len(k)< 10):
                klist.append(k)
            print(k+':'+p[k])
    klist = list(set(klist))
    print(klist)