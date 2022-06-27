from io import BytesIO
import os
from fastapi import FastAPI
from PIL import Image
from fastapi.responses import StreamingResponse

image_api = FastAPI(openapi_tags=[])


@image_api.get("/card/{image_name}/",  status_code=200)
async def backgroud(image_name: str):
    from configs import config
    # image_name = f'images/email/{image_name}'
    imagePath =  os.path.join(config.pathEmail, image_name)

    original_image = Image.open(imagePath)
    filtered_image = BytesIO()
    original_image.save(filtered_image, "PNG")
    filtered_image.seek(0)

    return StreamingResponse(filtered_image, media_type="image/png")
