from PIL import Image
import base64
import io
import numpy as np
import cv2

base64_string = '''
data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAgGBgcGBQgHBwcJCQgKDBQNDAsLDBkSEw8UHRofHh0aHBwgJC4nICIsIxwcKDcpLDAxNDQ0Hyc5PTgyPC4zNDL/wAALCAAPAHcBAREA/8QAHwAAAQUBAQEBAQEAAAAAAAAAAAECAwQFBgcICQoL/8QAtRAAAgEDAwIEAwUFBAQAAAF9AQIDAAQRBRIhMUEGE1FhByJxFDKBkaEII0KxwRVS0fAkM2JyggkKFhcYGRolJicoKSo0NTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqDhIWGh4iJipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uHi4+Tl5ufo6erx8vP09fb3+Pn6/9oACAEBAAA/APn+ipEGVC4OWYY4rc065MVv8qeZsJjIJOVHt+dbOn2SzyxTTmWB1YSIWK4LAjqPcD867Cw+zQSpfMoa4dgd44baW6/h1xV6fTNO8Sx3LuomRwA0Ktglg3UZ+57EdRxV+8tE8PXGlQWFk0MKweTtdfvOrE/Ukq3PJ6Z7V1mn2UcMv2uKONvtERjwznemSeCT7jGap3bW90i6XLcRrPPEJhDJIQEdMjA7ZYdD71myac9ksUudkIYLIyLkAMMrzjnnIP51kWUSQ3UvlBPKkxtYqCS2dp69s4pmrwsuQ+HAXZhR05Ix79Tz6VzV19laNI0kYLhthbvxwOg/nWKyxiLLwlsMDtKY6g/5/Cukj+IPg8Rky+B4jkckRwnGPwqRPiB4AnX5/AwA2/KUih6/pUsHxD+H0m1/+EGO1eDtii6/i1W4viD8O4nEjeCJ12EMSkcQ75B+/wBc1tWnxG+H0wmL+DblN4AyYYWyD/204/CrX/CxPh3mNH8M3QVflRhBGcf+P5roNG8R+BZYLm/07RjG0GzcPsyhm3HAxzjj3xWv4g8V+GLXSYtQ1a2klt4boRIPJDFZCvXGem1qrWPj3wQIobm1cRCZxEuLVgQWy3pxyT+dR33ibwHd6fHqV9xFaMI0cwyBkx0HyjJHNSf8JR4EudPad3UwEtkNbyZJQEHt6ZrOu9X+GMk0dpcKjOxUIBDMPvZIIIHH3T+VZd54r+EMdpBPLIdsp3x7YLjOQeT09azzr3wajZEeWaLdlxmGcjJPsDVSTWfgs8243tzGOh2wzgH/AMdr/9k=
'''

base64_string = base64_string.replace("data:image/jpeg;base64,", "")

base64_decoded = base64.b64decode(base64_string)

image = Image.open(io.BytesIO(base64_decoded))
image_np = np.array(image)

imgim1 = image.save("geeks.jpg")

  
# with open("000.jpg", "rb") as image2string:
#     converted_string = base64.b64encode(image2string.read())
# # print(converted_string)

# f = open("demofile3.txt", "w")
# f.write(str(converted_string))
# f.close()

# # with open('encode.bin', "wb") as file:
# #     file.write(converted_string)