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
    add_by: str
    firstname: str
    lastname: str
    home_number: str
    license_plate: date
    id_card: time
    invite_date: time


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


# insert whitelist
# class Whitelist(BaseModel):
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