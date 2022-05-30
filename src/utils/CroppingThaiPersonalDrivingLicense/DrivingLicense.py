from pathlib import Path
import cv2
import numpy as np
import base64, binascii
import yaml
import os


class DrivingLicense:
    def __init__(self,
                template_threshold: float = 0.7,
                 sift_rate: int = 25000):


        self.index_params = dict(algorithm=0, tree=5)
        self.search_params = dict()
        self.template_threshold = template_threshold

        self.flann = cv2.FlannBasedMatcher(self.index_params, self.search_params)
        self.sift = cv2.SIFT_create(sift_rate)
        self.root_path = Path(__file__).parent.parent
        self.__loadSIFT()
        self.h, self.w = self.source_image_front_tempalte.shape

    
    def __loadSIFT(self):
        self.source_image_front_tempalte = self.__readImage(
            os.path.join(self.root_path, 'CroppingThaiPersonalDrivingLicense/datasets', 'driving_license/thai-driving-license-template.jpg'))
        self.source_front_kp, self.source_front_des = self.sift.detectAndCompute(self.source_image_front_tempalte, None)
        with open(os.path.join(self.root_path, 'CroppingThaiPersonalDrivingLicense/datasets', 'driving_license/config.yaml'), 'r') as f:
            try:
                self.roi_extract = yaml.safe_load(f)
            except yaml.YAMLError as exc:
                raise ValueError(f"Can't load config file {exc}.")

    
    def __readImage(self, image=None):
        try:
            try:
                # handler if image params is base64 encode.
                img = cv2.imdecode(np.fromstring(base64.b64decode(image, validate=True), np.uint8), cv2.IMREAD_GRAYSCALE)
            except binascii.Error:
                # handler if image params is string path.
                img = cv2.imread(image, cv2.IMREAD_GRAYSCALE)

            if img.shape[1] > 1280:
                scale_percent = 60  # percent of original size
                width = int(img.shape[1] * scale_percent / 100)
                height = int(img.shape[0] * scale_percent / 100)
                dim = (width, height)
                img = cv2.resize(img, dim, interpolation=cv2.INTER_AREA)
            return img
        except cv2.error as e:
            raise ValueError(f"Can't read image from source. cause {e.msg}")

        
    def __compareTemplateSimilarity(self, queryDescriptors, trainDescriptors):
        self.good = []
        matches = self.flann.knnMatch(queryDescriptors, trainDescriptors, k=2)
        for x, y in matches:
            if x.distance < self.template_threshold * y.distance:
                self.good.append(x)


    def __findAndWrapObject(self):
        if len(self.good) > 30:
            processPoints = np.float32([self.process_kp[m.queryIdx].pt for m in self.good]).reshape(-1, 1, 2)
            sourcePoints = np.float32([self.source_front_kp[m.trainIdx].pt for m in self.good]).reshape(-1, 1, 2)

            M, _ = cv2.findHomography(processPoints, sourcePoints, cv2.RANSAC, 5.0)
            self.image_scan = cv2.warpPerspective(self.image, M, (self.w, self.h))
        else:
            self.image_scan = self.image

        # self.image_scan = cv2.cvtColor(self.image_scan, cv2.COLOR_GRAY2RGB)
        return self.image_scan

    
    def cropping_front_driving_license(self, image):
        self.image = self.__readImage(image)
        self.process_kp, self.process_des = self.sift.detectAndCompute(self.image, None)
        self.__compareTemplateSimilarity(self.process_des, self.source_front_des)
        return self.__findAndWrapObject()



# import cv2
# import base64, binascii
# import numpy as np
# import os
# import yaml
# from pathlib import Path
# from utils import Card


# class DrivingLicense:
#     def __init__(self,
#                 sift_rate: int = 25000,
#                 template_threshold: float = 0.7):

#         self.index_params = dict(algorithm=0, tree=5)
#         self.search_params = dict()
#         self.template_threshold = template_threshold

#         self.flann = cv2.FlannBasedMatcher(self.index_params, self.search_params)
#         self.sift = cv2.SIFT_create(sift_rate)
#         self.root_path = Path(__file__).parent.parent
#         self.__loadSIFT()
#         self.h, self.w, *other = self.source_image_front_tempalte.shape


#     def __loadSIFT(self):
#         self.source_image_front_tempalte = self.__readImage(
#             os.path.join(self.root_path, 'CroppingThaiPersonalDrivingLicense/datasets', 'driving_license/thai-driving-license-template.jpg'))
#         self.source_front_kp, self.source_front_des = self.sift.detectAndCompute(self.source_image_front_tempalte, None)
#         with open(os.path.join(self.root_path, 'CroppingThaiPersonalDrivingLicense/datasets', 'driving_license/config.yaml'), 'r') as f:
#             try:
#                 self.roi_extract = yaml.safe_load(f)
#             except yaml.YAMLError as exc:
#                 raise ValueError(f"Can't load config file {exc}.")

#     def __readImage(self, image=None):
#         try:
#             try:
#                 # handler if image params is base64 encode.
#                 img = cv2.imdecode(np.fromstring(base64.b64decode(image, validate=True), np.uint8), cv2.IMREAD_COLOR)
#             except binascii.Error:
#                 # handler if image params is string path.
#                 img = cv2.imread(image, cv2.IMREAD_COLOR)

#             img = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
#             if img.shape[1] > 1280:
#                 scale_percent = 60  # percent of original size
#                 width = int(img.shape[1] * scale_percent / 100)
#                 height = int(img.shape[0] * scale_percent / 100)
#                 dim = (width, height)
#                 img = cv2.resize(img, dim, interpolation=cv2.INTER_AREA)
#             return img
#         except cv2.error as e:
#             raise ValueError(f"Can't read image from source. cause {e.msg}")

        
#     def __compareTemplateSimilarity(self, queryDescriptors, trainDescriptors):
#         self.good = []
#         matches = self.flann.knnMatch(queryDescriptors, trainDescriptors, k=2)
#         for x, y in matches:
#             if x.distance < self.template_threshold * y.distance:
#                 self.good.append(x)

            
#     def __findAndWrapObject(self, side: Card = Card.FRONT_TEMPLATE):
#         if len(self.good) > 30:
#             processPoints = np.float32([self.process_kp[m.queryIdx].pt for m in self.good]).reshape(-1, 1, 2)
#             sourcePoints = None
#             if str(side) == str(Card.FRONT_TEMPLATE):
#                 sourcePoints = np.float32([self.source_front_kp[m.trainIdx].pt for m in self.good]).reshape(-1, 1, 2)
#             else:
#                 sourcePoints = np.float32([self.source_back_kp[m.trainIdx].pt for m in self.good]).reshape(-1, 1, 2)

#             M, _ = cv2.findHomography(processPoints, sourcePoints, cv2.RANSAC, 5.0)
#             self.image_scan = cv2.warpPerspective(self.image, M, (self.w, self.h))
#         else:
#             self.image_scan = self.image

#         self.image_scan = cv2.cvtColor(self.image_scan, cv2.COLOR_BGR2RGB)
#         # cv2.imwrite(os.path.join(self.path_to_save, self.path_to_save), self.image_scan)
#         return self.image_scan


#     def cropping_front_driving_license(self, image):
#         self.image = self.__readImage(image)
#         self.process_kp, self.process_des = self.sift.detectAndCompute(self.image, None)
#         self.__compareTemplateSimilarity(self.process_des, self.source_front_des)
#         return self.__findAndWrapObject(Card.FRONT_TEMPLATE)
        