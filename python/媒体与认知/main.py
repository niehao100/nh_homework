import cv2
import facer

def main():

    CAPTURE_DEVICE = 2
    DELAY = 1
    
    capture = cv2.VideoCapture(CAPTURE_DEVICE)
    
    lastAns = [];
    t = 0;
    
    while (1):
        [ret, frame] = capture.read()
        facer.refresh(frame)
        
        t += 1
        if (t == DELAY):
            lastAns = facer.calculate(frame);
            t = 0;
            #print(lastAns)
            
        for i in range(0, len(lastAns)):
            #print(type)
            cv2.rectangle(frame, (lastAns[i][0].left(), lastAns[i][0].top()), (lastAns[i][0].right(), lastAns[i][0].bottom()), (0, 0, 0), 5)
            cv2.putText(frame, lastAns[i][1], (int((lastAns[i][0].left() + lastAns[i][0].right()) / 2 - 32 * len(lastAns[i][1]) / 2), int((lastAns[i][0].top() + lastAns[i][0].bottom()) / 2)), cv2.FONT_HERSHEY_SIMPLEX, 2, 2, 5)
        
        cv2.imshow('Face Tracker', frame);
        cv2.waitKey(1)
        
if __name__ == '__main__':
    main()