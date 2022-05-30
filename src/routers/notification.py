from fastapi import APIRouter, Depends, HTTPException, Header

# data
from data.database import database as db
from data.schemas import NotificationItem

# authentication
from auth.auth import AuthHandler
from auth.check_token import is_token_blacklisted as isTokenBlacklisted

# apis
from apis.notification import send_notification

auth_handler = AuthHandler()

router = APIRouter(
    prefix="/notification",
    tags=["Notification"],
    responses={404: {"message": "Not found"}}
)


@router.post('/', tags=["Notification"], status_code=200)
async def notifications(item: NotificationItem, token=Depends(auth_handler.get_token), username=Depends(auth_handler.auth_wrapper)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(
            status_code=401, detail='Signature has expired')
    return await send_notification(db, item=item)
