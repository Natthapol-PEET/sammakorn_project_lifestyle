from pydantic import BaseModel
from typing import Optional


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
    home_id: int


class NotificationItem(BaseModel):
    title: str
    body: str
    data: Optional[distTest]

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

class HomeId(BaseModel):
    home_id: int


class VisitorId(BaseModel):
    visitor_id: int
    home_id: int


class HistoryLog(BaseModel):
    log_id: int
    home_id: int


class ResidentId(BaseModel):
    resident_id: str


class startDateendDate(BaseModel):
    datestart: str
    dateend: str


class GuardhouseCheckin(BaseModel):
    classname: str
    class_id: str
    home_id: str
    datetime_in: str
    firstname: str
    lastname: str
    license_plate: str
    qr_gen_id: str


class GuardhouseCheckout(BaseModel):
    datetime_out: str
    log_id: int
    home_id: int
    firstname: str
    lastname: str
    license_plate: str
    qr_gen_id: str


class GuardhouseAddvisitor(BaseModel):
    id_number: str                  # id card
    firstname: str
    lastname: str
    home_id: str
    home_number: str                # check home_id
    username: str = "guard"         # add_by -> class guard
    datetime_in: str
    license_plate: str
    email: str
    qr_gen_id: str


class DeleteWhitelist(BaseModel):
    whitelist_id: int
    firstname: str
    lastname: str
    home_id: int


class DeleteBlacklist(BaseModel):
    blacklist_id: int
    firstname: str
    lastname: str
    home_id: int








# -------------------------------- End Website ------------------------

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


class UpdateHome(BaseModel):
    resident_id: int
    home_id: int


class ChangePassword(BaseModel):
    resident_id: str
    old_password: str
    new_password: str


class EmailModel(BaseModel):
    email: str


class AdminStamp(BaseModel):
    admin_id: int
    home_id: int
    log_id: int
    firstname: str
    lastname: str
    license_plate: str
    qr_gen_id: str

    