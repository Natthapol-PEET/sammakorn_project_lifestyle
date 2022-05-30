from fastapi import APIRouter, Depends, HTTPException, Header
from typing import Optional

# data
from data.database import database as db
from data.schemas import NotificationItem

# authentication
from auth.auth import AuthHandler

# apis
from apis.notification import send_notification

# configs
from configs import config

auth_handler = AuthHandler()

router = APIRouter(
    prefix="/notification_pi",
    tags=["Notification"],
    responses={404: {"message": "Not found"}}
)


@router.post('/', tags=["Notification"], status_code=200)
async def notification_pi(item: NotificationItem, user_agent: Optional[str] = Header(None), token=Depends(auth_handler.get_token)):
    if token == config.token:
        # query = f"SELECT home_id FROM home WHERE home_number = '{item.data.home_id}'"
        # item.data.home_id = await db.execute(query)
        return await send_notification(db, item=item)
    else:
        raise HTTPException(status_code=401, detail='Invalid token')
