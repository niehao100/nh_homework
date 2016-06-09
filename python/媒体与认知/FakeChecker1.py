import cv2
import numpy as np

background = None
frames = []
# fgbg = cv2.bgsegm.createBackgroundSubtractorMOG()


def refresh(frame):
    MAX_LIST = 150
    MAX = 15
    global background
    # global fgbg
    if background is None:
        background = frame
    # background = fgbg.apply(frame)
    s = np.float64(background) * MAX
    frames.append(frame)
    if len(frames) > MAX_LIST:
        frames.pop(0)
    for f in frames:
        s += f
    s = s / (MAX + len(frames))
    background = np.uint8(s)


class fakeChecker1:

    def __init__(self, det, frame):
        # self.background = frame
        global background
        background = frame
        #cv2.imwrite('background.jpg', background)

    def update(self, det, frame):
        # l = det.left()
        # t = det.top()
        # r = det.right()
        # b = det.bottom()
        [l, t, r, b] = det.left(), det.top(), det.right(), det.bottom()
        wid = (r - l) // 3
        wid = 20 if wid < 20 else wid
        width = frame.shape[1]
        if l < wid:
            l = wid
        if r > width - wid:
            r = width - wid

        n = wid * (t - b)
        global background
        mask = np.zeros(frame.shape[:2], np.uint8)
        mask[t:b, l - wid:r + wid] = 255
        mask[t:b, l:r] = 0
        # masked_img = cv2.bitwise_and(frame, frame, mask=mask)
        # cv2.imwrite('mask.jpg', masked_img)
        # cv2.imwrite('unmask.jpg', frame)
        # cv2.imshow('masked', masked_img)
        hist1 = cv2.calcHist([frame], [0], mask, [256], [0.0, 256.0])
        hist2 = cv2.calcHist([background], [0], mask, [256], [0.0, 256.0])
        degree = 0
############
        degree += np.linalg.norm(hist1 / n - hist2 / n)
        # for i in range(len(hist1)):
        #     if hist1[i] != hist2[i]:
        #         degree = degree + \
        #             (1 - abs(hist1[i] - hist2[i]) / max(hist1[i], hist2[i]))
        #     else:
        #         degree = degree + 1
############
        hist1 = cv2.calcHist([frame], [1], mask, [256], [0.0, 256.0])
        hist2 = cv2.calcHist([background], [1], mask, [256], [0.0, 256.0])
        degree += np.linalg.norm(hist1 / n - hist2 / n)
###########
        hist1 = cv2.calcHist([frame], [2], mask, [256], [0.0, 256.0])
        hist2 = cv2.calcHist([background], [2], mask, [256], [0.0, 256.0])
        degree += np.linalg.norm(hist1 / n - hist2 / n)
        # degree /= 5000
        print(degree)
        return degree
