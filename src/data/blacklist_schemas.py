

from pydantic import BaseModel


class UpdateBlacklist(BaseModel):
    blacklist_id: int
    home_id: int
    Class: str
    class_id: int
    firstname: str
    lastname: str
    resident_add_reason: str
    license_plate: str
    id_card: str


class DeleteBlacklist(BaseModel):
    blacklist_id: int