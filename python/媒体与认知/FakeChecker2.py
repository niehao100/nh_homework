import cv2
import dlib
import numpy as np
from numpy import fft

PREDICTOR_PATH = "shape_predictor_68_face_landmarks.dat"
PREDICTOR = dlib.shape_predictor(PREDICTOR_PATH)
PRE_FAKE=0
PRE_HFD=0
PRE_CFD=0
PRE_POS=None
FSTDLIST=[]

def face_fourier(img):

    F=fft.fft2(img)
    F = fft.fftshift( F )
    # the 2D power spectrum is:
    F = np.abs( F )
    F = np.log(F+1);
    return F
    
def refresh(frame):
    pass

class fakeChecker2:
    def __init__(self, det, frame):
        self.threshold = 0.07
        self.frame=frame
 
    def face(self,shape):
        if self.frame is None or self.det is None:
            return None
        right,left,up,down=shape[16,0],shape[0,0],min(shape[19,1],shape[24,1]),shape[8,1]
        a = np.zeros([down - up + 1, right - left + 1])
        for i in range(up, down + 1):
            for j in range(left, right +1):
                a[i - up][j - left] = self.frame[i][j][0] * 0.299 + self.frame[i][j][1] * 0.587  + self.frame[i][j][2] * 0.114
        return a
        #print(up, down, left, right, len(self.frame), len(self.frame[0]), len(self.frame[0][0]))
        #print(cv2.cvtColor(self.frame[up : down][left : right][:], cv2.COLOR_BGR2GRAY))
        #return cv2.cvtColor(self.frame[up : down][left : right][:], cv2.COLOR_BGR2GRAY)

    def face_FD(self,shape):
        face=self.face(shape)
        if face is not None:
            return self.face_HFD(face),self.face_FSTD(face)
    
    def face_HFD(self,face):
        F=face_fourier(face)
        N,M=F.shape
        Ftd=float(N**2+M**2)/6
        Fh=0
        for i in range(N):
            for j in range(M):
                if (i-N/2)**2+(j-M/2)**2 > Ftd:
                    Fh=Fh+F[i,j]
        return Fh/F.sum()

    def face_FSTD(self,face):
        F=face_fourier(face)
        return F.sum()/F.size

    def update(self, det, frame):
        global FSTDLIST,PRE_HFD, PRE_CFD, PRE_FAKE, PRE_POS, PREDICTOR
        self.frame=frame
        self.det=det
        shape = PREDICTOR(self.frame, self.det)
        shape = np.matrix([[p.x, p.y] for p in shape.parts()])

        try:
            if PRE_POS.sum()-shape[0].sum()>50:
                PRE_POS=shape[0]
                return 0.5
        except AttributeError:
            pass

        PRE_POS=shape[0]
        # if shape[16,0]-shape[0,0]<100:
        #     PRE_FAKE,PRE_CFD=1,PRE_CFD+1
        #     return 1

        HFD,FSTD=self.face_FD(shape)
        # print('HFD:{}'.format(HFD))
        PRE_HFD=HFD
        FSTDLIST.append(FSTD)
        if len(FSTDLIST)>=10:
            # print('STD:{}'.format(np.std(FSTDLIST)))
            if np.std(FSTDLIST)<0.005:
                PRE_FAKE,PRE_CFD=1,5
                FSTDLIST=[]
                return 1

            if np.std(FSTDLIST)>0.2:
                PRE_FAKE,CFD=0, 0
                FSTDLIST=[]
                return 0

            FSTDLIST=[]             
        
        if HFD>self.threshold :
            PRE_FAKE, PRE_CFD=1,PRE_CFD+1
            return 1
 
        if PRE_CFD>=5:
            PRE_FAKE,PRE_CFD=1,PRE_CFD+1
            return 1

        PRE_FAKE,PRE_CFD=0,0
        return 0

