from pydantic import BaseModel
from typing import Optional

# ------------------------------------- Authentication  ---------------------------


class RegisterDetails(BaseModel):
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


# insert whitelist
class WhitelistIN(BaseModel):
    Class: str
    id: str
    firstname: str
    lastname: str
    home_id: str
    license_plate: str
    reason_resident: str


class BlacklistIN(BaseModel):
    Class: str
    id: str
    firstname: str
    lastname: str
    home_id: str
    license_plate: str
    reason_resident: str


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


class GuardhouseCheckin(BaseModel):
    classname: str
    class_id: int
    datetime_in: str


class GuardhouseCheckout(BaseModel):
    datetime_out: str
    log_id: int


class GuardhouseAddvisitor(BaseModel):
    id_number: int
    # home_id : int
    firstname: str
    lastname: str
    home_number: str
    username: str
    datetime_in: str


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

# -------------------------------- End Website ------------------------

class ResidentHomeIn(BaseModel):
    resident_id: int
    home_id: int


class HomeIn(BaseModel):
    home_name: str
    home_number: str
