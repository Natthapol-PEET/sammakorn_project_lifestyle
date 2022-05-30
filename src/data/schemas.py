from pydantic import BaseModel
from typing import Optional

# ------------------------------------- Authentication  ---------------------------


class RegisterDetails(BaseModel):
    firstname: str
    lastname: str
    username: str
    password: str
    email: str
    card_info: str


class RegisterAGDetails(BaseModel):
    firstname: str
    lastname: str
    username: str
    password: str
    email: str


class LoginDetails(BaseModel):
    username: str
    password: str


class LoginResident(BaseModel):
    username: str
    password: str
    device_token: str
    deviceId: str


class distTest(BaseModel):
    Class: str
    home_id: str


class NotificationItem(BaseModel):
    title: str
    body: str
    data: Optional[distTest]

# ------------------------------------- End Authentication  ---------------------------

# class NoteIn(BaseModel):
#     text: str
#     completed: bool


# class Note(BaseModel):
#     id: int
#     text: str
#     completed: bool

# ------------------------------------- Application ---------------------------
# insert visitor


class VisitorIN(BaseModel):
    Class: str
    class_id: str
    firstname: str
    lastname: str
    home_id: str
    license_plate: str
    id_card: str
    invite_date: str
    qrGenId: str


# insert whitelist
class WhitelistIN(BaseModel):
    Class: str = 'admin'
    id: int
    firstname: str
    lastname: str
    home_id: int
    license_plate: str
    email: str
    id_card: str


class BlacklistIN(BaseModel):
    Class: str = 'admin'
    id: int = 0
    firstname: str
    lastname: str
    home_id: int
    license_plate: str
    id_card: str


class listItem_whitelist_blacklist(BaseModel):
    home_id: str
    resident_id: str  # class_id


class deleteBlackWhite(BaseModel):
    type: str
    index: str


class HomeId(BaseModel):
    home_id: str


class VisitorId(BaseModel):
    visitor_id: str


class HistoryLog(BaseModel):
    log_id: str


class SendToAdmin(BaseModel):
    log_id: str
    reason: str


class AdminDelete(BaseModel):
    type: str
    id: str
    reason: str


class ResidentId(BaseModel):
    resident_id: str


class CancelRequest(BaseModel):
    type: str
    id: str


class DeleteWhiteBlackWhite(BaseModel):
    type: str
    id: str
    reason: str


# class VisitorOUT(BaseModel):
#     visitor_id: int
#     firstname: str
#     lastname: str
#     home_number: str
#     license_plate: str
#     date: date
#     start_time: time
#     end_time: time
#     timestamp: datetime


# insert blacklist
# class Blacklist(BaseModel):
#     firstname: str
#     lastname: str
#     home_number: str
#     license_plate: str


# class CreateResponse(BaseModel):
#     id: int
#     msg: str

# ------------------------------------- End Application ---------------------------

# -------------------------------- Website ------------------------
# update whitelist


# class UpdateVisitor(BaseModel):
#     timestamp: datetime


# class UpdateVisitorResponse(BaseModel):
#     id: int
#     timestamp: datetime


# # insert whitelist_log
# class WhitelistLog(BaseModel):
#     firstname: str
#     lastname: str
#     home_number: str
#     license_plate: str
#     timestamp: datetime

class ResidentHomeIn(BaseModel):
    resident_id: int
    home_id: int


class HomeIn(BaseModel):
    home_name: str
    home_number: str


class startDateendDate(BaseModel):
    datestart: str
    dateend: str


class GuardhouseCheckin(BaseModel):
    classname: str
    class_id: int
    datetime_in: str


class GuardhouseCheckout(BaseModel):
    datetime_out: str
    log_id: int


class GuardhouseAddvisitor(BaseModel):
    id_number: str                  # id card
    firstname: str
    lastname: str
    home_number: str                # check home_id
    username: str = "guard"         # add_by -> class guard
    datetime_in: str
    license_plate: str
    email: str


class Adminstamp(BaseModel):
    admin_approve: bool
    log_id: int
    admin_reason: str
    admin_datetime: str


class ApproveBlacklist(BaseModel):
    admin_approve: bool
    blacklist_id: int
    admin_reason: str
    admin_datetime: str


class ApproveWhitelist(BaseModel):
    admin_approve: bool
    whitelist_id: int
    admin_reason: str
    admin_datetime: str


class DeleteWhitelist(BaseModel):
    whitelist_id: int


class DeleteBlacklist(BaseModel):
    blacklist_id: int


class DeclineDeleteWhitelist(BaseModel):
    admin_decline_reason: str
    admin_decline_datetime: str
    whitelist_id: int


class DeclineDeleteBlacklist(BaseModel):
    admin_decline_reason: str
    admin_decline_datetime: str
    blacklist_id: int

class GetIDResident(BaseModel):
    firstname: str
    lastname: str
    username: str

# -------------------------------- End Website ------------------------

class ResidentHomeIn(BaseModel):
    resident_id: int
    home_id: int


class HomeIn(BaseModel):
    home_name: str
    home_number: str


class QRCode(BaseModel):
    qrGenId: str


class WalkInRegister(BaseModel):
    firstname: str
    lastname: str
    id_card: str
    gender: str
    address: str
    license_plate: str
    goto_home_address: str
    qrGenId: str
    imageBase64: str


class CropImage(BaseModel):
    imageBase64: str

class CropImageResponse(BaseModel):
    cropImageBase64: str
    classCardImage: str

class PayloadFromPi(BaseModel):
    topic: str
    payload: str


class GetHomeId(BaseModel):
    home_name: str
    home_number: str

class UpdateHome(BaseModel):
    resident_id: int
    home_id: int


class ChangePassword(BaseModel):
    resident_id: str
    old_password: str
    new_password: str


class EmailModel(BaseModel):
    email: str