from fastapi import FastAPI,  Depends, HTTPException
from fastapi.encoders import jsonable_encoder
from auth.check import Check

# database, schemas, models
from data.database import database as db
from data.imin_schemas import Image
from data.schemas import AdminStamp, BlacklistIN, LoginDetails, ResidentId, \
    GuardhouseCheckin, GuardhouseAddvisitor, GuardhouseCheckout, \
    WhitelistIN, startDateendDate, DeleteWhitelist, DeleteBlacklist
from data.home_schemas import CreateHome, DeleteHome, UpdateHome
from data.password_schemas import ChangePassword, ConfirmPassword, ResetPassword
from data.recovery_password_schemas import ConfirmSchemas, RecoverySchemas
from data.resident_schemas import DeleteResident, RegisterResidentAccount, UpdateResidentAccount
from data.verify_schemas import VerifySchemas
from data.whitelist_schemas import UpdateWhitelist
from data.admin_schemas import CreateAdmin, DeleteAdmin, UpdateAdmin
from data.blacklist_schemas import UpdateBlacklist
from data.guard_schemas import CreateGuard, DeleteGuard, UpdateGuard
from data.models import home as HOME, resident_account, resident_car, resident_home, admin_account, guard_account

# apis
from apis.api import API

# auth
from auth.register import Register
from auth.login import Login
from auth.logout import Logout
from auth.auth import AuthHandler
from auth.check_token import is_token_blacklisted as isTokenBlacklisted
from services.socket_manage import emit_message

# utils
from utils import utils, manageMail

from datetime import datetime, timedelta
from icecream import ic
import uuid

from apis.notification import send_notification_v2
from utils.enums.title import Title
from utils.enums.data import DataClass

check = Check()


tags_metadata = [
    {"name": "Admin", "description": ""},
    {"name": "Guard", "description": ""},
    {"name": "History", "description": ""},
    {"name": "Login", "description": ""},
    {"name": "Logout", "description": ""},
    {"name": "Home", "description": ""},
    {"name": "Resident", "description": ""},
    {"name": "Password Management", "description": ""},
    {"name": "Whitelist", "description": ""},
    {"name": "Blacklist", "description": ""},
    {"name": "Profile", "description": ""},
    {"name": "Verify Password"},
    {"name": "Recovery Password"},
]

web_api = FastAPI(openapi_tags=tags_metadata)
register = Register()
login = Login()
auth_handler = AuthHandler()
api = API()


# --------------------- Upload Profile ---------------------------------
@web_api.post("/upload_profile/", tags=["Profile"], status_code=201)
async def upload(item: Image, username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(status_code=401, detail='Invalid token')
    return await api.upload_profile(db, item)


@web_api.get("/profile_image/{image_name}", tags=["Profile"], status_code=200)
async def guard_profile_image(image_name: str):
    return await api.guard_profile_image(image_name)

# ------------------------------------- Admin ---------------------------


@web_api.post('/register_admin/', tags=["Admin"], status_code=201)
async def register_admin(item: CreateAdmin):
    response = await register.register_admin(db, item=item)

    await emit_message(f'toWeb', 'ADMIN_ACCEPT_ADMIN')
    return response


@web_api.get('/admin/', tags=["Admin"], status_code=200)
async def admin(username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(status_code=401, detail='Invalid token')
    return await api.get_admin(db)


@web_api.delete('/admin/', tags=["Admin"], status_code=200)
async def admin(item: DeleteAdmin, username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(status_code=401, detail='Invalid token')
    response = await api.delete_admin(db, item)

    await emit_message(f'toWeb', 'ADMIN_ACCEPT_ADMIN')
    await emit_message(f'toWeb/Delete', f'ADMIN/{item.admin_id}')
    return response


@web_api.put('/admin/', tags=["Admin"], status_code=200)
async def admin(item: UpdateAdmin, username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(status_code=401, detail='Invalid token')
    response = await api.update_admin(db, item)

    if not item.active_user:
        await emit_message(f'toWeb/Disable', f'ADMIN/{item.admin_id}')

    await emit_message(f'toWeb', 'ADMIN_ACCEPT_ADMIN')
    return response

# ------------------------------------- End Admin ---------------------------

# ------------------------------------- Guard ---------------------------


@web_api.post('/register_guard/', tags=["Guard"], status_code=201)
async def register_guard(item: CreateGuard, username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(status_code=401, detail='Invalid token')
    response = await register.register_guard(db, item=item)

    await emit_message(f'toWeb', 'ADMIN_ACCEPT_GUARD')
    return response


@web_api.get('/guard/', tags=["Guard"], status_code=200)
async def guard(username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(status_code=401, detail='Invalid token')
    return await api.get_guard(db)


@web_api.delete('/guard/', tags=["Guard"], status_code=200)
async def guard(item: DeleteGuard, username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(status_code=401, detail='Invalid token')
    response = await api.delete_guard(db, item)

    await emit_message(f'toWeb', 'ADMIN_ACCEPT_GUARD')
    await emit_message(f'toWeb/Delete', f'GUARD/{item.guard_id}')
    return response


@web_api.put('/guard/', tags=["Guard"], status_code=200)
async def guard(item: UpdateGuard, username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(status_code=401, detail='Invalid token')
    response = await api.update_guard(db, item)

    if not item.active_user:
        await emit_message(f'toWeb/Disable', f'GUARD/{item.guard_id}')

    await emit_message(f'toWeb', 'ADMIN_ACCEPT_GUARD')
    return response
# ------------------------------------- End Guard ---------------------------


@web_api.post('/change_password_resident/', tags=["Password Management"], status_code=200)
async def change_password_resident(item: ChangePassword, username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(status_code=401, detail='Invalid token')
    return await api.change_password_resident(db, item)


@web_api.post('/change_password_admin/', tags=["Password Management"], status_code=200)
async def change_password_admin(item: ChangePassword, username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(status_code=401, detail='Invalid token')
    return await api.change_password_admin(db, item)


@web_api.post('/change_password_guard/', tags=["Password Management"], status_code=200)
async def change_password_guard(item: ChangePassword, username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(status_code=401, detail='Invalid token')
    return await api.change_password_guard(db, item)


@web_api.post('/reset_password_resident/', tags=["Password Management"], status_code=200)
async def reset_password_resident(item: ResetPassword):
    return await api.reset_password_resident(db, item)


@web_api.put('/reset_password_resident_confirm/', tags=["Password Management"], status_code=201)
async def reset_password_resident_confirm(item: ConfirmPassword, username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(status_code=401, detail='Invalid token')
    return await api.reset_password_resident_confirm(db, item)

# ------------------------------------- Login ---------------------------


@web_api.post('/login_admin/', tags=["Login"], status_code=200)
async def login_admin(auth_details: LoginDetails):
    return await login.login_admin(db, auth_details=auth_details)


@web_api.post('/login_guard/', tags=["Login"], status_code=200)
async def login_guard(auth_details: LoginDetails):
    return await login.login_guard(db, auth_details=auth_details)

# ------------------------------------- End Login ---------------------------

# ------------------------------------- End Logout ---------------------------


@web_api.post("/logout/", tags=["Logout"], status_code=200)
async def logout(item: ResidentId, token=Depends(auth_handler.get_token)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(status_code=401, detail='Invalid token')
    return await Logout().logout(db, token=token, item=item)
# ------------------------------------- End Logout ---------------------------

# ------------------------------ Web Application  --------------------------------


@web_api.get("/visitorlist_log/", tags=['Visitor'], status_code=200)
async def visitorlist_log(username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(status_code=401, detail='Invalid token')
    return await api.visitorlist_log(db)


@web_api.get("/whitelist_log/", tags=['Whitelist'], status_code=200)
async def whitelist_log(username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(status_code=401, detail='Invalid token')
    return await api.whitelist_log(db)


@web_api.get("/all_home/", tags=['Home'], status_code=200)
async def all_home(username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(status_code=401, detail='Invalid token')
    return await api.all_home(db)


@web_api.get("/blacklist_log/", tags=['Blacklist'], status_code=200)
async def blacklist_log(username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(status_code=401, detail='Invalid token')
    return await api.blacklist_log(db)


@web_api.get("/history_visitorlist/", tags=['History'], status_code=200)
async def history_visitorlist(username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(status_code=401, detail='Invalid token')
    return await api.history_visitorlist(db)


@web_api.post("/history_visitorlist_date/", tags=['History'], status_code=200)
async def history_visitorlist_date(item: startDateendDate, username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(status_code=401, detail='Invalid token')
    return await api.history_visitorlist_date(db, item)


@web_api.get("/history_whitelist/", tags=['History'], status_code=200)
async def history_whitelist(username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(status_code=401, detail='Invalid token')
    return await api.history_whitelist(db)


@web_api.post("/history_whitelist_date/", tags=['History'], status_code=200)
async def history_whitelist_date(item: startDateendDate, username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(status_code=401, detail='Invalid token')
    return await api.history_whitelist_date(db, item)


@web_api.get("/history_blacklist/", tags=['History'], status_code=200)
async def history_blacklist(username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(status_code=401, detail='Invalid token')
    return await api.history_blacklist(db)


@web_api.post("/history_blacklist_date/", tags=['History'], status_code=200)
async def history_blacklist_date(item: startDateendDate, username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(status_code=401, detail='Invalid token')
    return await api.history_blacklist_date(db, item)


@web_api.post('/guardhouse_checkin/', tags=['Guard'], status_code=200)
async def guardhouse_checkin(item: GuardhouseCheckin, username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(status_code=401, detail='Invalid token')
    response = await api.guardhouse_checkin(db, item)

    # realtime
    await emit_message(f'toApp/{item.home_id}', 'COMING_WALK_IN')
    await emit_message(f'toWeb', 'COMING_WALK_IN')

    # notification
    await send_notification_v2(db, item, Title.guard,
                         DataClass.comming, homeId=item.home_id)

    return response


@web_api.put('/guardhouse_checkout/', tags=['Guard'], status_code=200)
async def guardhouse_checkout(item: GuardhouseCheckout, username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(status_code=401, detail='Invalid token')
    response = await api.guardhouse_checkout(db, item)

    # realtime
    await emit_message(f'toApp/{item.home_id}', 'CHECKOUT')
    await emit_message(f'toWeb', 'CHECKOUT')

    # notification
    await send_notification_v2(db, item, Title.guard,
                         DataClass.checkout, homeId=item.home_id)

    return response


# @web_api.post('/guardhouse_advisitor/', tags=['Guard'], status_code=200)
# async def guardhouse_advisitor(item: GuardhouseAddvisitor, username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):
#     if await isTokenBlacklisted(db, token):
#         raise HTTPException(status_code=401, detail='Invalid token')
#     response = await api.guardhouse_advisitor(db, item)

#     # realtime
#     home_id = await check.checkHomeIdByHomeNumber(db, item)
#     await emit_message(f'toApp/{home_id}', 'COMING_WALK_IN')
#     await emit_message(f'toWeb', 'COMING_WALK_IN')

#     # notification
#     await send_notification_v2(db, item, Title.guard, DataClass.comming, homeId=item.home_id)

#     return response

# # ----------------------- Home -----------------------------


@web_api.get('/home/', tags=["Home"], status_code=200)
async def home(token=Depends(auth_handler.get_token), username=Depends(auth_handler.auth_wrapper)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(status_code=401, detail='Invalid token')
    return await api.get_home(db)


@web_api.post('/home/', tags=["Home"],  status_code=201)
async def home(item: CreateHome, token=Depends(auth_handler.get_token), username=Depends(auth_handler.auth_wrapper)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(status_code=401, detail='Invalid token')
    response = await api.create_home(db, item)

    await emit_message(f'toWeb', 'ADMIN_ACCEPT_HOME')
    return response


@web_api.put('/home/', tags=["Home"],  status_code=200)
async def home(item: UpdateHome, token=Depends(auth_handler.get_token), username=Depends(auth_handler.auth_wrapper)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(status_code=401, detail='Invalid token')
    response = await api.update_home(db, item)

    await emit_message(f'toWeb', 'ADMIN_ACCEPT_HOME')
    return response


@web_api.delete('/home/', tags=["Home"], status_code=200)
async def home_delete(item: DeleteHome, token=Depends(auth_handler.get_token), username=Depends(auth_handler.auth_wrapper)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(status_code=401, detail='Invalid token')
    response = await api.delete_home(db, item)

    await emit_message(f'toWeb', 'ADMIN_ACCEPT_HOME')
    return response


# # -------------------- Register Resident ------------------

@web_api.get('/resident/', status_code=200, tags=["Resident"])
async def resident(token=Depends(auth_handler.get_token), username=Depends(auth_handler.auth_wrapper)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(status_code=401, detail='Invalid token')
    return await api.get_resident(db)


@web_api.post('/register_resident/', status_code=201, tags=["Resident"])
async def resident(item: RegisterResidentAccount, token=Depends(auth_handler.get_token), username=Depends(auth_handler.auth_wrapper)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(status_code=401, detail='Invalid token')
    response = await api.register_resident(db, item)

    await emit_message(f'toWeb', 'ADMIN_ACCEPT_MEMBER')
    return response


@web_api.put('/resident/', status_code=200, tags=["Resident"])
async def resident(item: UpdateResidentAccount, token=Depends(auth_handler.get_token), username=Depends(auth_handler.auth_wrapper)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(status_code=401, detail='Invalid token')
    response = await api.update_resident(db, item)

    await emit_message(f'toWeb', 'ADMIN_ACCEPT_MEMBER')
    return response


@web_api.delete('/resident/', status_code=200, tags=["Resident"])
async def resident(item: DeleteResident, username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(status_code=401, detail='Invalid token')
    response = await api.delete_resident(db, item)

    await emit_message(f'toWeb', 'ADMIN_ACCEPT_MEMBER')
    return response


# # ------------------- Whitelist ------------------------------


@web_api.get("/get_whitelist/", tags=["Whitelist"], status_code=200)
async def get_whitelist(username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(status_code=401, detail='Invalid token')
    return await api.get_whitelist(db)


@web_api.post("/register_whitelist/", tags=["Whitelist"],  status_code=201)
async def register_whitelist(item: WhitelistIN, username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(
            status_code=401, detail='Signature has expired')
    response = await api.register_whitelist(db, item=item, username=username)

    # realtime
    await emit_message(f'toWeb', 'ADMIN_ACCEPT_WHITELIST')

    # notification
    await send_notification_v2(db, item, Title.admin, DataClass.registerWhitelist, homeId=item.home_id)

    return response


@web_api.put("/put_whitelist/", tags=["Whitelist"], status_code=200)
async def put_whitelist(item: UpdateWhitelist, username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(status_code=401, detail='Invalid token')
    response = await api.update_whitelist(db, item)

    await emit_message(f'toWeb', 'ADMIN_ACCEPT_WHITELIST')
    return response


@web_api.delete("/delete_whitelist/", tags=["Whitelist"], status_code=200)
async def delete_whitelist(item: DeleteWhitelist, username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(status_code=401, detail='Invalid token')
    response = await api.delete_whitelist(db, item)

    # realtime
    await emit_message(f'toWeb', 'ADMIN_ACCEPT_WHITELIST')

    # notification
    await send_notification_v2(db, item, Title.admin, DataClass.deleteBlacklist, homeId=item.home_id)

    return response

# -------------------- Blacklist -----------------------------


@web_api.get("/get_blacklist/", tags=["Blacklist"], status_code=200)
async def get_blacklist(username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(status_code=401, detail='Invalid token')
    return await api.get_blacklist(db)


@web_api.post("/register_blacklist/", tags=["Blacklist"],  status_code=201)
async def register_blacklist(item: BlacklistIN, username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(
            status_code=401, detail='Signature has expired')
    response = await api.register_blacklist(db, item=item, username=username)

    # realtime
    await emit_message(f'toWeb', 'ADMIN_ACCEPT_BLACKLIST')

    # notification
    await send_notification_v2(db, item, Title.admin, DataClass.registerBlacklist, homeId=item.home_id)

    return response


@web_api.put("/put_blacklist/", tags=["Blacklist"], status_code=200)
async def put_blacklist(item: UpdateBlacklist, username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(status_code=401, detail='Invalid token')
    respons = await api.update_blacklist(db, item)

    await emit_message(f'toWeb', 'ADMIN_ACCEPT_BLACKLIST')
    return respons


@web_api.delete("/delete_blacklist/", tags=["Blacklist"], status_code=200)
async def delete_blacklist(item: DeleteBlacklist, username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(status_code=401, detail='Invalid token')
    respons = await api.delete_blacklist(db, item)

    # realtime
    await emit_message(f'toWeb', 'ADMIN_ACCEPT_BLACKLIST')

    # notification
    await send_notification_v2(db, item, Title.admin, DataClass.deleteBlacklist, homeId=item.home_id)

    return respons


# ------------------- Profile (Admin, Guard) -----------------------
@web_api.get("/admin/profile/{username}", tags=["Profile"], status_code=200)
async def admin_profile(username: str, user=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(status_code=401, detail='Invalid token')
    return await api.admin_profile(db, username)


@web_api.get("/guard/profile/{username}", tags=["Profile"], status_code=200)
async def guard_profile(username: str, user=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(status_code=401, detail='Invalid token')
    return await api.guard_profile(db, username)


@web_api.get("/guard/profile_image/{image_name}", tags=["Profile"], status_code=200)
async def guard_profile_image(image_name: str):
    return await api.guard_profile_image(image_name)


# -------------------- Verify Password --------------------------
@web_api.post("/admin/verify/", tags=["Verify Password"], status_code=200)
async def admin_verify(item: VerifySchemas, username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(status_code=401, detail='Invalid token')
    return await api.admin_verify(db, item)


@web_api.post("/guard/verify/", tags=["Verify Password"], status_code=200)
async def guard_verify(item: VerifySchemas, username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(status_code=401, detail='Invalid token')
    return await api.guard_verify(db, item)


# ------------- Recovery Password ----------------------------------
@web_api.post("/admin/recovery/", tags=["Recovery Password"], status_code=200)
async def admin_recovery(item: RecoverySchemas):
    return await api.admin_recovery(db, item)


# @web_api.post("/admin/confirm/", tags=["Recovery Password"], status_code=200)
# async def admin_confirm(item: ConfirmSchemas):
#     return await api.admin_confirm(db, item)


@web_api.post("/guard/recovery/", tags=["Recovery Password"], status_code=200)
async def guard_recovery(item: RecoverySchemas):
    return await api.guard_recovery(db, item)


@web_api.post("/confirm/", tags=["Recovery Password"], status_code=200)
async def confirm(item: ConfirmSchemas):
    return await api.confirm(db, item)


@web_api.post("/resident/recovery/", tags=["Recovery Password"], status_code=200)
async def resident_recovery(item: RecoverySchemas):
    return await api.resident_recovery(db, item)

# @web_api.post("/guard/confirm/", tags=["Recovery Password"], status_code=200)
# async def guard_confirm(item: ConfirmSchemas):
#     return await api.guard_confirm(db, item)





# @web_api.post("/resident/confirm/", tags=["Recovery Password"], status_code=200)
# async def resident_confirm(item: ConfirmSchemas):
#     return await api.resident_confirm(db, item)


@web_api.put('/admin_stamp/', tags=['Admin'], status_code=200)
async def admin_stamp(item: AdminStamp, username=Depends(auth_handler.auth_wrapper), token=Depends(auth_handler.get_token)):
    if await isTokenBlacklisted(db, token):
        raise HTTPException(status_code=401, detail='Invalid token')

    # realtime
    await emit_message(f'toWeb', 'ADMIN_OPERATION')
    await emit_message(f'toWeb', 'ADMIN_STAMP')
    await emit_message(f'toApp/{item.home_id}', 'ADMIN_STAMP')

    # notification
    await send_notification_v2(db, item, Title.admin, DataClass.adminStamp, homeId=item.home_id)

    return await api.admin_stamp(db, item)
