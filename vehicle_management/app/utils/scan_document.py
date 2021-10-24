import numpy as np
import cv2


def scanDocument(img):
    # w, h, d = img.shape
    # img = cv2.resize(img, (int(h/2), int(w/2)))

    cv2.imwrite('card.jpg', img)

    height, width, channels = img.shape  # Find Height And Width Of Image

    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)  # RGB To Gray Scale
    # cv2.imshow('gray', gray)

    kernel = np.ones((5, 5), np.uint8)  # Reduce Noise Of Image

    erosion = cv2.erode(gray, kernel, iterations=1)
    # cv2.imshow('erosion', erosion)

    opening = cv2.morphologyEx(erosion, cv2.MORPH_OPEN, kernel)
    # cv2.imshow('opening', opening)

    closing = cv2.morphologyEx(opening, cv2.MORPH_CLOSE, kernel)
    # cv2.imshow('closing', closing)

    blurred = cv2.GaussianBlur(closing, (5, 5), 0)
    # Step 1: Edge Detection
    edges = cv2.Canny(blurred, 20, 240)
    wide = cv2.Canny(blurred, 10, 200)
    mid = cv2.Canny(blurred, 30, 150)
    tight = cv2.Canny(blurred, 240, 250)
    # cv2.imshow('edges', edges)
    # cv2.imshow('wide', wide)
    # cv2.imshow('mid', mid)
    # cv2.imshow('tight', tight)

    # setting threshold of gray image
    _, threshold = cv2.threshold(gray, 127, 255, cv2.THRESH_BINARY)

    # Get Threshold Of Canny
    # ทำขอบให้หนาขึ้น
    thresh = cv2.adaptiveThreshold(
        threshold, 255, cv2.ADAPTIVE_THRESH_GAUSSIAN_C, cv2.THRESH_BINARY_INV, 11, 2)
    # cv2.imshow('thresh', thresh)

    thresh = cv2.dilate(thresh, kernel, iterations=1)
    thresh = cv2.dilate(thresh, kernel, iterations=1)

    thresh = cv2.erode(thresh, kernel, iterations=1)
    
    # เพิ่มจุด
    # thresh = cv2.morphologyEx(thresh, cv2.MORPH_OPEN, kernel)
    # thresh = cv2.morphologyEx(thresh, cv2.MORPH_OPEN, kernel)

    # ลดจุด
    thresh = cv2.morphologyEx(thresh, cv2.MORPH_CLOSE, kernel)
    thresh = cv2.morphologyEx(thresh, cv2.MORPH_CLOSE, kernel)
    thresh = cv2.morphologyEx(thresh, cv2.MORPH_CLOSE, kernel)

    cv2.imwrite('thresh.jpg', thresh)


    # Find Contours In Image
    # ค้นหาทรงของรูปภาพ
    contours, hierarchy = cv2.findContours(
        thresh, cv2.RETR_TREE, cv2.CHAIN_APPROX_NONE)

    # Find Biggest Contour
    # หารูปร่างที่ใหญ่ที่สุด
    areas = [cv2.contourArea(c) for c in contours]
    max_index = np.argmax(areas)
    print(max_index)

    if max_index < 15:
        # Find approxPoly Of Biggest Contour
        epsilon = 0.1 * cv2.arcLength(contours[max_index], True)
        approx = cv2.approxPolyDP(contours[max_index], epsilon, True)

        # Crop The Image To approxPoly
        pts1 = np.float32(approx)
        pts = np.float32([[0, 0], [width, 0], [width, height], [0, height]])
        
        try:
            matrix = cv2.getPerspectiveTransform(pts1, pts)
            result = cv2.warpPerspective(img, matrix, (width, height))
        except:
            return None

        flip = cv2.flip(result, 1)  # Flip Image

        cv2.imwrite("flip.jpg", flip)

        return flip

    return None