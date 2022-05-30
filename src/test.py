from fastapi import FastAPI, File, UploadFile
from fastapi.responses import FileResponse, StreamingResponse, JSONResponse
from io import BytesIO
from PIL import Image, ImageFilter

app = FastAPI()

file_path = "videos/large-video-file.mp4"

# @app.get("/")
# def main():
#     def iterfile():
#         with open(file_path, mode="rb") as file_like:
#             yield from file_like

#     return StreamingResponse(iterfile(), media_type="video/mp4")


@app.get("/image")
# @app.post("/image")
# def image_filter(img: UploadFile = File(...)):
def image_filter():
    # original_image = Image.open(img.file)
    original_image = Image.open('images/1410501130726.jpg')
    original_image = original_image.filter(ImageFilter.BLUR)

    filtered_image = BytesIO()
    original_image.save(filtered_image, "JPEG")
    filtered_image.seek(0)

    return StreamingResponse(filtered_image, media_type="image/jpeg")
