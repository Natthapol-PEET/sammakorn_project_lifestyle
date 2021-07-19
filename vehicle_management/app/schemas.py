from sqlalchemy.sql.functions import user
from pydantic import BaseModel
from datetime import date, time, datetime
from typing import List, Optional, Union

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
    home: str
    username: str
    password: str

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
    # homename: str
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
    # homename: str
    home_id: str
    license_plate: str


class BlacklistIN(BaseModel):
    Class: str
    id: str
    firstname: str
    lastname: str
    # homename: str
    home_id: str
    license_plate: str


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


# -------------------------------- End Website ------------------------

class ResidentHomeIn(BaseModel):
    resident_id: int
    home_id: int


class HomeIn(BaseModel):
    home_name: str
    home_number: str
