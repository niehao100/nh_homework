import FakeChecker1;
import FakeChecker2;
import numpy as np
import cv2
import dlib

FACE_CASCADE = cv2.CascadeClassifier("haarcascade_frontalface_default.xml");

def detector(img):
    if img.ndim == 3:
        gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    else:
        gray = img

    faces = FACE_CASCADE.detectMultiScale(gray, 1.2, 5)

    result = []
    for (x, y, width, height) in faces:
        result.append(dlib.rectangle(x.tolist(), y.tolist(), (x + width).tolist(), (y + height).tolist()))
    return result
    
    
    
allDets = []
fakeChecker1 = []
fakeChecker2 = []

def area(d):
    return (d.right() - d.left()) * (d.bottom() - d.top())
    
def overlap(d1, d2):
    startX = min(d1.left(), d2.left())
    endX = max(d1.right(), d2.right())
    startY = min(d1.top(), d2.top())
    endY = max(d1.bottom(), d2.bottom())
    overlapX = (d1.right() - d1.left()) + (d2.right() - d2.left()) - (endX - startX)
    overlapY = (d1.bottom() - d1.top()) + (d2.bottom() - d2.top()) - (endY - startY)
    if (overlapX > 0 and overlapY > 0):
        return overlapX * overlapY
    else:
        return 0
        
def km(sim):
    def find(x):
        visitx[x] = 1
        for y in range(0, len(sim[0])):
            if (not visity[y]):
                t = lx[x] + ly[y] - sim[x][y]
                if (t == 0):
                    visity[y] = 1;
                    if (match[y] == -1 or find(match[y])):
                        match[y] = x
                        return True 
                else:
                    if (slack[y] > t):
                        slack[y] = t  

    oriXL = len(sim)
    oriYL = len(sim[0])
    
    if (oriXL > oriYL):
        sim = np.concatenate((sim, np.zeros([oriXL, oriXL - oriYL])), axis = 1)
    
    INF = 10000000
    
    lx = -INF * np.ones(len(sim))
    ly = np.zeros(len(sim[0]))
    match = np.int8(-1 * np.ones(len(sim[0])))
    
    for i in range(0, len(sim)):
        for j in range(0, len(sim[0])):
            if (sim[i][j] > lx[i]):
                lx[i] = sim[i][j]
    
    for i in range(0, len(sim)):
        slack = INF * np.ones(len(sim[0]))

        while (1):
            visitx = np.zeros(len(sim))
            visity = np.zeros(len(sim[0]))
            if (find(i)): 
                break
            d = INF
            for j in range(0, len(sim[0])):
                if ((not visity[j]) and d > slack[j]):
                    d = slack[j]
            for j in range(0, len(sim)):
                if (visitx[j]):
                    lx[j] -= d
            for j in range(0, len(sim[0])):
                if (visity[j]):
                    ly[j] += d
                else:
                    slack[j] -= d
    match = match.tolist()
    for i in range(oriYL, len(match)):
        match.pop()
    return match  

def refresh(frame):
    FakeChecker1.refresh(frame)
    FakeChecker2.refresh(frame)

allDets = []
fakeChecker1 = []
fakeChecker2 = []    

def calculate(frame):
    
    global allDets, fakeChecker1, fakeChecker2


    dets = detector(frame)
    result = []
    
    if (len(dets) == 0):
        allDets = []
        fakeChecker1 = []
        fakeChecker2 = []
        return []
    #print([len(dets), len(allDets)]);
    sim = -1 * np.ones([len(dets), len(allDets)])
    for i1, d1 in enumerate(allDets):
        for i2, d2 in enumerate(dets):
            sim[i2][i1] = overlap(d1, d2) / max(area(d1), area(d2)) 
    matches = km(sim)
    
    visit = np.zeros(len(dets))
    newAllDets = []
    newFakeChecker1= []
    newFakeChecker2 = []
    
    for i in range(0, len(allDets)):
        #print(i, matches[i]);
        if (matches[i] >= 0 and sim[matches[i]][i] > 0):
            visit[matches[i]] = 1
            #print(i, matches[i])
            #print(matches[i], dets[matches[i]])
            p1 = fakeChecker1[i].update(dets[matches[i]], frame)
            #p2 = 0.1
            p2 = fakeChecker2[i].update(dets[matches[i]], frame)
            #print('c', p1, p2)
            if (p1 > 0.6 or p2 == 1):
                result.append([dets[matches[i]], 'fake'])
            else:
                result.append([dets[matches[i]], 'real'])
            newAllDets.append(dets[matches[i]])
            newFakeChecker1.append(fakeChecker1[i])
            newFakeChecker2.append(fakeChecker2[i])
   
    for i in range(0, len(visit)):
        if (visit[i] == 0):
            result.append([dets[i], 'unknown'])
            newAllDets.append(dets[i])
            newFakeChecker1.append(FakeChecker1.fakeChecker1(dets[i], frame))
            newFakeChecker2.append(FakeChecker2.fakeChecker2(dets[i], frame))
    
    allDets = newAllDets
    fakeChecker1 = newFakeChecker1
    fakeChecker2 = newFakeChecker2
    
    return result
    
    