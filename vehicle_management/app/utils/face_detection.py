# import cv2

# # Load the cascade
# face_cascade = cv2.CascadeClassifier('utils/haarcascade_frontalface_default.xml')

# cw = 325     # 8.6 cm
# ch = 204    # 5.4 cm

# def faceDetectionAndRotate(img):

#     # Convert into grayscale
#     gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

#     height, width = gray.shape

#     # if height > width:
#     #     # แนวตั้ง
#     #     gray = cv2.resize(gray, (ch, cw))
#     # else:
#     #     # แนวนอน
#     #     gray = cv2.resize(gray, (cw, ch))
#     # cv2.imwrite("grey_resize.jpg", gray)

#     # Detect faces
#     faces = face_cascade.detectMultiScale(gray, 1.1, 4)

    

#     # Draw rectangle around the faces
#     for (x, y, w, h) in faces:
#         cv2.rectangle(img, (x, y), (x+w, y+h), (255, 0, 0), 10)

#         print(x, y, w, h)

#         # if height > width:
#         #     # แนวตั้ง
#         #     pass
#         # else:
#         #     # แนวนอน
#         #     pass

#     cv2.imwrite("face.jpg", img)
        

#         # driver 30 95
#         # personal 265 110
#         # center 162.5
#         # if x < width / 2:
#         #     print("Driver")
#         # else:
#         #     print("Personal")