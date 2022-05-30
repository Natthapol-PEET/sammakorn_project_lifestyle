from typing import Optional
from pydantic import BaseModel


class RegisterResidentAccount(BaseModel):
    firstname: str
    lastname: str
    username: str
    password: str
    email: str
    card_info: str
    home_id: list
    license_plate: list
    id_card: str


class UpdateResidentAccount(BaseModel):
    resident_id: int
    firstname: str
    lastname: str
    username: str
    email: str
    card_info: str
    active_user: bool
    home_id: list
    car: list
    id_card: str


class DeleteResident(BaseModel):
    resident_id: int